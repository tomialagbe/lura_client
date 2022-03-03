import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

// import 'package:udp/udp.dart';

/// This just handles mdns queries, can't be used to send mDNS requests
///
class DnsQuery {}

abstract class MulticastDnsEventDelegate {
  void onQuery(DnsQuery query);
}

class MulticastDnsServer {
  final int port;
  final String type;
  final MulticastDnsEventDelegate? delegate;

  Map memberships = {};
  bool destroyed = false;
  dynamic interval;
  InternetAddress? ip;

  MulticastDnsServer({
    this.port = 5353,
    this.type = 'udp4',
    String? ipOrHost,
    int? ipv6Interface,
    this.delegate,
  }) {
    ip = ipOrHost != null
        ? InternetAddress(ipOrHost)
        : type == 'udp4'
            ? InternetAddress('224.0.0.251', type: InternetAddressType.IPv4)
            : null;
    if (type == 'udp6' && (ip == null || ipv6Interface == null)) {
      throw Exception(
          'For Ipv6 multicast you must specify `ip` and `interface`');
    }
  }

  RawDatagramSocket? _socket;

  Future _bindSocket(Future<void> Function(RawDatagramSocket)? onBind) async {

    // RawDatagramSocket.bind(ip, port, reuseAddress: true)
    //     .then((dgramSocket) async {
    //   dgramSocket.multicastHops = 255; // multicast TTL
    //   dgramSocket.multicastLoopback = true;
    //   _socket = dgramSocket;
    //   await onBind?.call(_socket!);
    //   // dgramSocket.close();
    // });
  }

/*final int port;
  final String type;  // tcp, udp4
  final String ipAddressOrHost;

  bool _destroyed = false;

  StreamSubscription<RawSocketEvent>? _rawSocketSubscription;

  MulticastDns({
    required this.port,
    this.type = 'udp4',
    required this.ipAddressOrHost,
  }) {

    // InternetAddress.anyIPv4
    RawDatagramSocket.bind(ipAddressOrHost, port, reuseAddress: false).then((dgramSocket) {
      _listenOnSocket(dgramSocket);
    });
  }

  void _listenOnSocket(RawDatagramSocket socket) {
    _rawSocketSubscription = socket.listen((RawSocketEvent event) {

    }, onError: (err, stackTrace) {});
  }*/
}
