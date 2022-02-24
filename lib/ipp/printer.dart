import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:mobile_printer/ipp/groups.dart';
import 'package:mobile_printer/ipp/ipp_decoder.dart';
import 'package:mobile_printer/ipp/status_codes.dart';

import 'constants.dart';
import 'ipp_message.dart';
import 'print_job.dart';
import 'package:bonsoir/bonsoir.dart';

class Printer {
  int _jobId = 0;
  DateTime started = DateTime.now();
  List<PrintJob> jobs = [];

  final StreamController<IppMessage> _operationStream = StreamController();
  final StreamController<PrintJob> _jobStream = StreamController();

  Stream<IppMessage> get onOperation => _operationStream.stream;

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
    debugPrint(
        'Handling HTTP request: ${request.method} - ${request.contentLength} bytes');
    debugPrint(
        'Printer-HttpRequest: Request content type: ${request.headers.contentType?.mimeType} - ${request.headers.contentType?.charset}');

    if (request.method != 'POST') {
      debugPrint(
          'Printer-HttpRequest: Received a non POST request. Returning a 405 response.');
      request.response.statusCode = HttpStatus.methodNotAllowed; // 405
      request.response.flush().then((_) {
        request.response.close();
      });
      return;
    } else if (request.headers.contentType?.mimeType != 'application/ipp') {
      debugPrint('Printer-HttpRequest: Request not application/ipp');
      request.response.statusCode = HttpStatus.badRequest; // 405
      request.response.flush().then((_) {
        request.response.close();
      });
      return;
    }

    StreamSubscription<Uint8List>? requestBodySubscription;
    Uint8List? body;

    void consumeAttrGroups(Uint8List bytes) {
      if (body != null) {
        body?.addAll(bytes);
      } else {
        body = Uint8List.fromList(bytes);
      }

      IppMessage? message;
      try {
        final ippDecoder = IppRequestDecoder();
        message = ippDecoder.decode(body!);
      } catch (err, st) {
        debugPrint(err.toString());
        debugPrint(st.toString());
        debugPrint(
            'Printer-HttpRequest: Incomplete IPP body - waiting for more data...');
        return;
      }

      requestBodySubscription?.cancel();
      _operationStream.add(message);
      _routeMessage(message, request);
    }

    requestBodySubscription = request.listen((Uint8List bytes) {
      debugPrint('Printer-HttpRequest: Received ${bytes.length} bytes');
      consumeAttrGroups(bytes);
    }, onError: (err, st) {
      // TODO:
    });
  }

  void _routeMessage(IppMessage message, HttpRequest request) {
    debugPrint(
        'IPP/${message.versionMajor}.${message.versionMinor} operation ${message.operationIdOrStatusCode} (request ${message.requestId})');
    debugPrint('Groups: ${message.groups}. Len: ${message.groups.length}');

    if (message.versionMajor != 1) {
      return _sendResponse(request, message,
          statusCode: IppConstants.SERVER_ERROR_VERSION_NOT_SUPPORTED);
    }

    switch (message.operationIdOrStatusCode) {
      case IppConstants.PRINT_JOB:
        debugPrint('Printer: received Print-Job message');
        return _sendResponse(request, message,
            statusCode: IppConstants.SERVER_ERROR_OPERATION_NOT_SUPPORTED);
      case IppConstants.VALIDATE_JOB:
        debugPrint('Printer: received Validate-Job message');
        return _sendResponse(request, message,
            statusCode: IppConstants.SERVER_ERROR_OPERATION_NOT_SUPPORTED);
      case IppConstants.GET_PRINTER_ATTRIBUTES:
        debugPrint('Printer: received Get-Printer-Attributes message');
        return _sendResponse(request, message,
            statusCode: IppConstants.SERVER_ERROR_OPERATION_NOT_SUPPORTED);
      case IppConstants.GET_JOBS:
        debugPrint('Printer: received Get-Jobs message');
        return _sendResponse(request, message,
            statusCode: IppConstants.SERVER_ERROR_OPERATION_NOT_SUPPORTED);
      case IppConstants.CANCEL_JOB:
        debugPrint('Printer: received Cancel-Job message');
        return _sendResponse(request, message,
            statusCode: IppConstants.SERVER_ERROR_OPERATION_NOT_SUPPORTED);
      case IppConstants.GET_JOB_ATTRIBUTES:
        debugPrint('Printer: received Get-Job-Attributes message');
        return _sendResponse(request, message,
            statusCode: IppConstants.SERVER_ERROR_OPERATION_NOT_SUPPORTED);
    }
  }

  void _sendResponse(HttpRequest request, IppMessage message,
      {int statusCode = IppConstants.SUCCESSFUL_OK,
      List<AttributeGroup>? groups = const []}) {
    final responseMessage = IppMessage();
    if (fallback && message.versionMajor == 1 && message.versionMinor == 0) {
      responseMessage
        ..versionMajor = 1
        ..versionMinor = 0;
    }
    responseMessage
      ..operationIdOrStatusCode = statusCode
      ..requestId =
          message.requestId //  obj.requestId = req ? req.requestId : 0
      ..groups = [operationAttributesTag(IppStatusCodes[statusCode]!)];

    if (groups != null) {
      responseMessage.groups.addAll(groups);
    }

    debugPrint('Responding to request: ${message.requestId}');
    final ippEncoder = IppResponseEncoder();
    final Uint8List encodedResponse = ippEncoder.encode(responseMessage);

    request.response.statusCode = 200;
    request.response.headers.contentType = ContentType('application', 'ipp');
    // request.response.headers.contentLength = encodedResponse.length;
    request.response.writeAll(encodedResponse);
    request.response.flush().then((_) {
      request.response.close();
    });
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
