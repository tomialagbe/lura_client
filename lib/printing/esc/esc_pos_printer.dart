import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mobile_printer/printing/printing.dart';
import 'package:rxdart/rxdart.dart';

import 'esc_pos_decoder.dart';

class EscPosPrinter implements Printer {

  final String name;
  final int port;
  final BehaviorSubject<bool> _statusStream = BehaviorSubject.seeded(false);

  ServerSocket? _socket;
  StreamSubscription<Socket>? _clientConnSubscription;

  EscPosPrinter({required this.name, this.port = 9100});

  @override
  Stream<bool> isRunning() {
    return _statusStream.stream;
  }

  @override
  Future start() async {
    _startPrintServer();
  }

  @override
  Future stop() async {
    _clientConnSubscription?.cancel();
    await _socket?.close();
    _statusStream.add(false);
  }

  Future _startPrintServer() async {
    _socket = await ServerSocket.bind('0.0.0.0', port);
    _statusStream.add(true);
    _clientConnSubscription = _socket?.listen(_handleClientConn);
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
        final commandHeader = token.fullCommand!.commandBytes.join(', ');
        final commandData = token.fullCommand?.dataBytes?.join(', ') ?? '';
        debugPrint('Command is: \nHeader: $commandHeader\nData: $commandData\n');
      } else {
        debugPrint('Text is: ${token.dataBytes!}');
      }
    }
  }
}
