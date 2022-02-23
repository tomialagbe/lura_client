import 'dart:async';
import 'dart:io';

class MulticastDns {
  final int port;
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
  }
}
