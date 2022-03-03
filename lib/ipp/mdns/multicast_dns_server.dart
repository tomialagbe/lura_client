import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:multicast_dns/src/constants.dart';
import 'package:multicast_dns/src/lookup_resolver.dart';
import 'package:multicast_dns/src/native_protocol_client.dart';
import 'package:multicast_dns/src/packet.dart';
import 'package:multicast_dns/src/resource_record.dart';

export 'package:multicast_dns/src/resource_record.dart';

/// A callback type for [MDnsQuerier.start] to iterate available network
/// interfaces.
///
/// Implementations must ensure they return interfaces appropriate for the
/// [type] parameter.
///
/// See also:
///   * [MDnsQuerier.allInterfacesFactory]
typedef NetworkInterfacesFactory = Future<Iterable<NetworkInterface>> Function(
    InternetAddressType type);

/// A factory for construction of datagram sockets.
///
/// This can be injected into the [MDnsServer] to provide alternative
/// implementations of [RawDatagramSocket.bind].
typedef RawDatagramSocketFactory = Future<RawDatagramSocket> Function(
    dynamic host, int port,
    {bool reuseAddress, bool reusePort, int ttl});

/// Server for DNS publishing using the mDNS protocol.
///
/// Users should call [MDnsQuerier.start] when ready to start querying and
/// listening. [MDnsQuerier.stop] must be called when done to clean up
/// resources.
///
/// This client only supports "One-Shot Multicast DNS Queries" as described in
/// section 5.1 of [RFC 6762](https://tools.ietf.org/html/rfc6762).
class MDnsServer {
  /// Create a new [MDnsServer].
  MDnsServer({
    RawDatagramSocketFactory rawDatagramSocketFactory = RawDatagramSocket.bind,
  }) : _rawDatagramSocketFactory = rawDatagramSocketFactory;

  bool _starting = false;
  bool _started = false;
  final List<RawDatagramSocket> _sockets = <RawDatagramSocket>[];
  final List<RawDatagramSocket> _toBeClosed = <RawDatagramSocket>[];
  final LookupResolver _resolver = LookupResolver();
  final ResourceRecordCache _cache = ResourceRecordCache();
  final RawDatagramSocketFactory _rawDatagramSocketFactory;

  InternetAddress? _mDnsAddress;
  int? _mDnsPort;

  /// Find all network interfaces with an the [InternetAddressType] specified.
  Future<Iterable<NetworkInterface>> allInterfacesFactory(
      InternetAddressType type) {
    return NetworkInterface.list(
      includeLinkLocal: true,
      type: type,
      includeLoopback: true,
    );
  }

  /// Start the mDNS client.
  ///
  /// With no arguments, this method will listen on the IPv4 multicast address
  /// on all IPv4 network interfaces.
  ///
  /// The [listenAddress] parameter must be either [InternetAddress.anyIPv4] or
  /// [InternetAddress.anyIPv6], and will default to anyIPv4.
  ///
  /// The [interfaceFactory] defaults to [allInterfacesFactory].
  ///
  /// The [mDnsPort] allows configuring what port is used for the mDNS
  /// query. If not provided, defaults to `5353`.
  ///
  /// The [mDnsAddress] allows configuring what internet address is used
  /// for the mDNS query. If not provided, defaults to either `224.0.0.251` or
  /// or `FF02::FB`.
  ///
  /// Subsequent calls to this method are ignored while the mDNS client is in
  /// started state.
  Future<void> start({
    InternetAddress? listenAddress,
    NetworkInterfacesFactory? interfacesFactory,
    int mDnsPort = mDnsPort,
    InternetAddress? mDnsAddress,
  }) async {
    listenAddress ??= InternetAddress.anyIPv4;
    interfacesFactory ??= allInterfacesFactory;

    assert(listenAddress.address == InternetAddress.anyIPv4.address ||
        listenAddress.address == InternetAddress.anyIPv6.address);

    if (_started || _starting) {
      return;
    }
    _starting = true;

    final int selectedMDnsPort = _mDnsPort = mDnsPort;
    _mDnsAddress = mDnsAddress;

    // Listen on all addresses.
    final RawDatagramSocket incoming = await _rawDatagramSocketFactory(
      listenAddress.address,
      selectedMDnsPort,
      reuseAddress: true,
      reusePort: true,
      ttl: 255,
    );

    // Can't send to IPv6 any address.
    if (incoming.address != InternetAddress.anyIPv6) {
      _sockets.add(incoming);
    } else {
      _toBeClosed.add(incoming);
    }

    _mDnsAddress ??= incoming.address.type == InternetAddressType.IPv4
        ? mDnsAddressIPv4
        : mDnsAddressIPv6;

    final List<NetworkInterface> interfaces =
        (await interfacesFactory(listenAddress.type)).toList();

    for (final NetworkInterface interface in interfaces) {
      // Create a socket for sending on each adapter.
      final InternetAddress targetAddress = interface.addresses[0];
      final RawDatagramSocket socket = await _rawDatagramSocketFactory(
        targetAddress,
        selectedMDnsPort,
        reuseAddress: true,
        reusePort: true,
        ttl: 255,
      );
      _sockets.add(socket);
      // Ensure that we're using this address/interface for multicast.
      if (targetAddress.type == InternetAddressType.IPv4) {
        socket.setRawOption(RawSocketOption(
          RawSocketOption.levelIPv4,
          RawSocketOption.IPv4MulticastInterface,
          targetAddress.rawAddress,
        ));
      } else {
        socket.setRawOption(RawSocketOption.fromInt(
          RawSocketOption.levelIPv6,
          RawSocketOption.IPv6MulticastInterface,
          interface.index,
        ));
      }
      // Join multicast on this interface.
      incoming.joinMulticast(_mDnsAddress!, interface);
    }
    incoming.listen((RawSocketEvent event) => _handleIncoming(event, incoming));
    _started = true;
    _starting = false;
  }

  /// Stop the client and close any associated sockets.
  void stop() {
    if (!_started) {
      return;
    }
    if (_starting) {
      throw StateError('Cannot stop mDNS client while it is starting.');
    }

    for (final RawDatagramSocket socket in _sockets) {
      socket.close();
    }
    _sockets.clear();

    for (final RawDatagramSocket socket in _toBeClosed) {
      socket.close();
    }
    _toBeClosed.clear();

    _resolver.clearPendingRequests();

    _started = false;
  }

  // Process incoming datagrams.
  void _handleIncoming(RawSocketEvent event, RawDatagramSocket incoming) {
    Duration timeout = const Duration(seconds: 5);

    if (event == RawSocketEvent.read) {
      final Datagram? datagram = incoming.receive();
      if (datagram == null) {
        return;
      }

      // TODO: work here
      final query = decodeMDnsQuery(datagram.data);
      if (query == null) {
        debugPrint('Failed to parse DNS query');
        return;
      }

      final Stream results = _resolver.addPendingRequest(
          query.resourceRecordType, query.fullyQualifiedName, timeout);

      // Check for published responses.
      final List<ResourceRecord>? response = decodeMDnsResponse(datagram.data);
      if (response != null) {
        _cache.updateRecords(response);
        _resolver.handleResponse(response);
        return;
      }
      // TODO(dnfield): Support queries coming in for published entries.
    }
  }
}
