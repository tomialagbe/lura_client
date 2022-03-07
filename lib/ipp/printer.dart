import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:mobile_printer/ipp/airprint_attributes.dart';
import 'package:mobile_printer/ipp/groups.dart';
import 'package:mobile_printer/ipp/ipp_decoder.dart';
import 'package:mobile_printer/ipp/status_codes.dart';
import 'package:mobile_printer/ipp/type_codec.dart';
import 'package:mobile_printer/ipp/utils.dart';
import 'package:mobile_printer/utils/function_call_restricter.dart';

import 'airprint/airprint.dart';
import 'constants.dart';
import 'ipp_message.dart';
import 'print_job.dart';
import 'package:bonsoir/bonsoir.dart';

class IppPrinter {
  int _jobId = 0;
  DateTime started = DateTime.now().toUtc();
  List<PrintJob> jobs = [];

  int get jobId => _jobId;

  final String name;
  final bool fallback;
  final int? port;
  final bool useAirprint;
  String? uri;
  int state;
  List<BonsoirBroadcast> broadcasts = [];
  HttpServer? httpServer;
  AirprintProxy? airprintProxy;

  Function(Uint8List)? onPrintEnd;

  IppPrinter({
    required this.name,
    this.port = 631,
    this.fallback = true,
    this.uri,
    this.useAirprint = false,
  }) : state = IppConstants.PRINTER_STOPPED {
    _startServer();
    _broadcastIppService();
  }

  Future _startServer() async {
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
        type: useAirprint ? '_ipp._tcp,_universal' : '_ipp._tcp',
        // Put your service type here. Syntax : _ServiceType._TransportProtocolName. (see http://wiki.ros.org/zeroconf/Tutorials/Understanding%20Zeroconf%20Service%20Types).
        port: port ?? 631, // Put your service port here.
        attributes: useAirprint ? airPrintAttributes() : {},
      );
      // And now we can broadcast it :
      final broadcast = BonsoirBroadcast(service: service);
      await broadcast.ready;
      await broadcast.start();
      broadcasts.add(broadcast);
      debugPrint('Printer: Advertising printer $name to network on port $port');
      // if (useAirprint) {
      //   await Future.delayed(const Duration(seconds: 2));
      //   airprintProxy = await startAirprintProxy(nameToLookFor: name);
      // }
    } catch (err, st) {
      debugPrint(err.toString());
      debugPrint(st.toString());
      rethrow;
    }
  }

  void handleHttpRequest(HttpRequest request) async {
    if (request.method != 'POST') {
      request.response.statusCode = HttpStatus.methodNotAllowed; // 405
      request.response.flush().then((_) {
        request.response.close();
      });
      return;
    } else if (request.headers.contentType?.mimeType != 'application/ipp') {
      request.response.statusCode = HttpStatus.badRequest; // 405
      request.response.flush().then((_) {
        request.response.close();
      });
      return;
    }

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

      final attributes = Utils.getAttributesForGroup(
          message, IppConstants.OPERATION_ATTRIBUTES_TAG);
      uri ??= Utils.getFirstValueForName(attributes, 'printer-uri');

      _routeMessage(message, request);
    }

    final builder = await request.fold(
        BytesBuilder(), (BytesBuilder builder, data) => builder..add(data));
    final bytes = builder.takeBytes();
    debugPrint('Printer-HttpRequest: Received ${bytes.length} bytes');
    consumeAttrGroups(bytes);
  }

  void _routeMessage(IppMessage message, HttpRequest request) {
    debugPrint(
        'IPP/${message.versionMajor}.${message.versionMinor} operation ${message.operationIdOrStatusCode} (request ${message.requestId})');
    debugPrint('Groups: ${message.groups}. Len: ${message.groups.length}');
    // debugPrint('VERSION: ${message.versionMajor}.${message.versionMinor}');
    // if (message.versionMajor != 1) {
    //   return _sendResponse(request, message,
    //       statusCode: IppConstants.SERVER_ERROR_VERSION_NOT_SUPPORTED);
    // }

    switch (message.operationIdOrStatusCode) {
      case IppConstants.PRINT_JOB:
        debugPrint('Printer: received Print-Job message');
        return _handlePrintJob(request, message);
      case IppConstants.VALIDATE_JOB:
        debugPrint('Printer: received Validate-Job message');
        return _handleValidateJob(request, message);
      case IppConstants.GET_PRINTER_ATTRIBUTES:
        debugPrint('Printer: received Get-Printer-Attributes message');
        return _handleGetPrinterAttributes(request, message);
      case IppConstants.GET_JOBS:
        debugPrint('Printer: received Get-Jobs message');
        return _sendResponse(request, message,
            statusCode: IppConstants.SUCCESSFUL_OK);
      case IppConstants.CANCEL_JOB:
        debugPrint('Printer: received Cancel-Job message');
        return _sendResponse(request, message,
            statusCode: IppConstants.SUCCESSFUL_OK);
      case IppConstants.GET_JOB_ATTRIBUTES:
        debugPrint('Printer: received Get-Job-Attributes message');
        return _sendResponse(request, message,
            statusCode: IppConstants.SUCCESSFUL_OK);
      default:
        debugPrint('Printer: received unknown message');
        break;
    }
  }

  void _sendResponse(HttpRequest request, IppMessage requestMessage,
      {int statusCode = IppConstants.SUCCESSFUL_OK,
      List<AttributeGroup>? groups = const []}) {
    final responseMessage = IppMessage();
    // if (fallback &&
    //     requestMessage.versionMajor == 1 &&
    //     requestMessage.versionMinor == 0) {
    //   responseMessage
    //     ..versionMajor = 1
    //     ..versionMinor = 0;
    // }

    responseMessage
      ..versionMajor = 1
      ..versionMinor = 1;

    responseMessage
      ..operationIdOrStatusCode = statusCode
      ..requestId =
          requestMessage.requestId //  obj.requestId = req ? req.requestId : 0
      ..groups = [Groups.operationAttributesTag(IppStatusCodes[statusCode]!)];

    if (groups != null) {
      responseMessage.groups.addAll(groups);
    }

    debugPrint('Responding to request: ${requestMessage.requestId}');
    final ippEncoder = IppResponseEncoder();
    final Uint8List encodedResponse = ippEncoder.encode(responseMessage);
    debugPrint('Encoded response: ${encodedResponse.length}');

    request.response.statusCode = 200;
    request.response.headers.contentType = ContentType('application', 'ipp');
    request.response.add(encodedResponse);
    request.response.flush().then((_) async {
      await request.response.close();
    });
  }

  void start() {
    state = IppConstants.PRINTER_IDLE;
    debugPrint('printer $name changed state to idle');
  }

  void stop() {
    state = IppConstants.PRINTER_STOPPED;
    debugPrint('printer $name changed state to stopped');
    for (final broadcast in broadcasts) {
      broadcast.stop();
    }
    httpServer?.close();
    airprintProxy?.stop();
  }

  void add(PrintJob job) {
    jobs.add(job);
  }

  PrintJob? getJob(int jobId) {
    for (int i = 0, l = jobs.length; i < l; i++) {
      if (jobs[i].id == jobId) {
        return jobs[i];
      }
    }
  }

  List<Attribute> _attributes(List<String>? filter) {
    if (filter != null && filter.contains('all')) {
      filter = null;
    }

    if (filter != null) {
      filter = Utils.expandAttrGroups(filter);
    }

    final now = DateTime.now().toUtc();
    final attrs = <Attribute>[
      Attribute.from(
          tag: IppConstants.URI, name: 'printer-uri-supported', value: [uri]),
      Attribute.from(
          tag: IppConstants.KEYWORD,
          name: 'uri-security-supported',
          value: ['none']),
      // none, ssl3, tls
      Attribute.from(
          tag: IppConstants.KEYWORD,
          name: 'uri-authentication-supported',
          value: ['none']),
      // none, requesting-user-name, basic, digest, certificate
      Attribute.from(
          tag: IppConstants.NAME_WITH_LANG,
          name: 'printer-name',
          value: [LangStr(lang: 'en-us', value: name)]),
      Attribute.from(
          tag: IppConstants.ENUM, name: 'printer-state', value: [state]),
      Attribute.from(
          tag: IppConstants.KEYWORD,
          name: 'printer-state-reasons',
          value: ['none']),
      Attribute.from(
          tag: IppConstants.KEYWORD,
          name: 'ipp-versions-supported',
          value: ['1.1']),
      // 1.0, 1.1
      Attribute.from(
          tag: IppConstants.ENUM,
          name: 'operations-supported',
          value: [
            IppConstants.PRINT_JOB,
            IppConstants.VALIDATE_JOB,
            IppConstants.GET_JOBS,
            IppConstants.GET_PRINTER_ATTRIBUTES,
            IppConstants.CANCEL_JOB,
            IppConstants.GET_JOB_ATTRIBUTES
          ]),
      Attribute.from(
          tag: IppConstants.CHARSET,
          name: 'charset-configured',
          value: ['utf-8']),
      Attribute.from(
          tag: IppConstants.CHARSET,
          name: 'charset-supported',
          value: ['utf-8']),
      Attribute.from(
          tag: IppConstants.NATURAL_LANG,
          name: 'natural-language-configured',
          value: ['en-us']),
      Attribute.from(
          tag: IppConstants.NATURAL_LANG,
          name: 'generated-natural-language-supported',
          value: ['en-us']),
      Attribute.from(
          tag: IppConstants.MIME_MEDIA_TYPE,
          name: 'document-format-default',
          value: ['application/postscript']),
      Attribute.from(
          tag: IppConstants.MIME_MEDIA_TYPE,
          name: 'document-format-supported',
          value: [
            'text/html',
            'text/plain',
            'application/vnd.hp-PCL',
            'application/octet-stream',
            'application/pdf',
            'application/postscript'
          ]),
      Attribute.from(
          tag: IppConstants.BOOLEAN,
          name: 'printer-is-accepting-jobs',
          value: [true]),
      Attribute.from(
          tag: IppConstants.INTEGER,
          name: 'queued-job-count',
          value: [jobs.length]),
      Attribute.from(
          tag: IppConstants.KEYWORD,
          name: 'pdl-override-supported',
          value: ['not-attempted']),
      // attempted, not-attempted
      Attribute.from(
          tag: IppConstants.INTEGER,
          name: 'printer-up-time',
          value: [Utils.time(started, now)]),
      Attribute.from(
          tag: IppConstants.DATE_TIME,
          name: 'printer-current-time',
          value: [now]),
      Attribute.from(
          tag: IppConstants.KEYWORD,
          name: 'compression-supported',
          value: ['deflate', 'gzip']),
      // none, deflate, gzip, compress
    ];

    if (filter == null || filter.isEmpty) {
      return attrs;
    }

    return attrs.where((attr) {
      return filter!.contains(attr.name);
    }).toList();
  }

  void _handleValidateJob(HttpRequest request, IppMessage requestMessage) {
    _sendResponse(request, requestMessage,
        statusCode: IppConstants.SUCCESSFUL_OK);
  }

  void _handleGetPrinterAttributes(
      HttpRequest request, IppMessage requestMessage) {
    final requested = Utils.requestedAttributes(requestMessage) ?? ['all'];
    final printerAttrs = _attributes(requested);
    final group1 = Groups.unsupportedAttributesTag(printerAttrs, requested);
    var group2 = Groups.printerAttributesTag(printerAttrs);
    _sendResponse(request, requestMessage,
        groups: group1.attributes.isEmpty ? [group2] : [group1, group2]);
  }

  void _handlePrintJob(HttpRequest request, IppMessage requestMessage) {
    final once = FunctionCallRestricter(maxCalls: 1);

    void onError(dynamic err) {}
    void onCancel() {}

    void onAbort(int statusCode) {
      once(() {
        _sendResponse(request, requestMessage, statusCode: statusCode);
      });
    }

    void onEnd(Uint8List data, List<Attribute> attributes) {
      debugPrint('PRINT JOB ENDED: SENDING RESPONSE');
      once(() {
        _sendResponse(request, requestMessage, groups: [
          AttributeGroup()
            ..tag = IppConstants.JOB_ATTRIBUTES_TAG
            ..attributes = attributes
        ]);
      });
      onPrintEnd?.call(data);
    }

    final job = PrintJob(
        id: ++_jobId,
        printerUri: uri!,
        requestMessage: requestMessage,
        printerStartedAt: started,
        onError: onError,
        onAbort: onAbort,
        onCancel: onCancel,
        onEnd: onEnd);
    add(job);

    /* TODO:
    var send = once(res.send)

  req.on('end', function () {
    send({
      tag: C.JOB_ATTRIBUTES_TAG,
      attributes: job.attributes(['job-uri', 'job-id', 'job-state'])
    })
  })
     */

    debugPrint('STARTING PRINT JOB $jobId');
    job.process();
  }
}
