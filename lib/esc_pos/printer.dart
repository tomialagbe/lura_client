import 'dart:io';

import 'package:flutter/foundation.dart';

import 'decoder.dart';

class EscPrinter {
  final String name;
  final int port;

  late ServerSocket _socket;
  EscPrinter({required this.name, this.port = 9100}) {
    _startPrintServer();
  }

  Future _startPrintServer() async {
    _socket = await ServerSocket.bind('0.0.0.0', port);
    _socket.listen(_handleClientConn);
  }

  void _handleClientConn(Socket clientConn) async {
    final builder = await clientConn.fold(
        BytesBuilder(), (BytesBuilder builder, data) => builder..add(data));
    final data = builder.takeBytes();
    debugPrint('RECEIVED ${data.length} BYTES');
    debugPrint(data.join(', '));
    final parser = EscPosDecoder();
    final result = parser.decode(data);
    for (final token in result) {
      if (token.isCommand) {
        final commandHeader = token.command!.command.join(', ');
        final commandData = token.command?.data?.join(', ') ?? '';
        debugPrint('Command is: \nHeader: $commandHeader\nData: $commandData\n');
      } else {
        debugPrint('Text is: ${token.data!}');
      }
    }
  }
}
