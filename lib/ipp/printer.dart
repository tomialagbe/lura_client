import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'constants.dart';
import 'print_job.dart';
import 'package:bonsoir/bonsoir.dart';

class Printer {
  int _jobId = 0;
  DateTime started = DateTime.now();
  List<PrintJob> jobs = [];
  final StreamController<PrintJob> _jobStream = StreamController();

  Stream<PrintJob> get onJob => _jobStream.stream;

  final String name;
  final bool zeroconf;
  final bool fallback;
  final int? port;
  final String? uri;
  int state;
  BonsoirBroadcast? broadcast;
  HttpServer? httpServer;

  Printer({
    required this.name,
    this.port = 631,
    this.zeroconf = true,
    this.fallback = true,
    this.uri,
  }) : state = IppConstants.PRINTER_STOPPED {
    _startServer();
    _broadcastIppService();
  }

  Future _startServer() async {
    // httpServer = await HttpServer.bind(InternetAddress.loopbackIPv4, port!);
    httpServer = await HttpServer.bind('0.0.0.0', port!);
    httpServer?.listen((request) {
      handleHttpRequest(request);
    }, onError: (err, stackTrace) {
      debugPrint('http server error: ${err.toString()}');
    });
  }

  void _broadcastIppService() async {
    try {
      BonsoirService service = BonsoirService(
        name: name,
        type: '_ipp._tcp',
        // Put your service type here. Syntax : _ServiceType._TransportProtocolName. (see http://wiki.ros.org/zeroconf/Tutorials/Understanding%20Zeroconf%20Service%20Types).
        port: port ?? 631, // Put your service port here.
      );
      // And now we can broadcast it :
      broadcast = BonsoirBroadcast(service: service);
      await broadcast?.ready;
      await broadcast?.start();
      debugPrint('Printer: Advertising printer $name to network on port $port');
    } catch (err, st) {
      debugPrint(err.toString());
      debugPrint(st.toString());
      rethrow;
    }
  }

  void handleHttpRequest(HttpRequest request) async {
    debugPrint('Handling HTTP request: ${request.method} - ${request.contentLength} bytes');
    if (request.method != 'POST') {
      debugPrint(
          'Printer-HttpRequest: Received a non POST request. Returning a 405 response.');
      request.response
        ..statusCode = HttpStatus.methodNotAllowed // 405
        ..flush()
        ..close();
      return;
    } else if (request.headers.contentType !=
        ContentType.parse('application/ipp')) {
      request.response
        ..statusCode = HttpStatus.badRequest // 400
        ..flush()
        ..close();
      return;
    }

    await for (var data in request) {
      debugPrint('Received data: $data');
    }
  }

  void start() {
    state = IppConstants.PRINTER_IDLE;
    print('printer $name changed state to idle');
  }

  void stop() {
    state = IppConstants.PRINTER_STOPPED;
    print('printer $name changed state to stopped');
    broadcast?.stop();
    httpServer?.close();
  }

  void add(PrintJob job) {
    jobs.add(job);
    _jobStream.add(job);
  }

  PrintJob? getJob(int jobId) {
    for (int i = 0, l = jobs.length; i < l; i++) {
      if (jobs[i].id == jobId) {
        return jobs[i];
      }
    }
  }

  attributes(PrintJob job) {}
}
