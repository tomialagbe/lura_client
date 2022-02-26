import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:mobile_printer/ipp/ipp_message.dart';
import 'package:archive/archive_io.dart';

import 'constants.dart';
import 'utils.dart';

class PrintJob {
  int id;
  int state = IppConstants.JOB_PENDING;
  late String uri;
  String? compression;
  String? name;
  String? userName;
  late DateTime createdAt;
  late DateTime printerStartedAt;
  DateTime? completedAt;
  Uint8List? data;

  Function(int statusCode)? onAbort;
  Function(Uint8List, List<Attribute>)? onEnd;
  Function? onCancel;
  Function(dynamic)? onError;

  DateTime? _processingAt;

  PrintJob({
    required this.id,
    required String printerUri,
    required IppMessage requestMessage,
    required this.printerStartedAt,
    this.onAbort,
    this.onEnd,
    this.onError,
    this.onCancel,
  }) {
    final attributes = Utils.getAttributesForGroup(
        requestMessage, IppConstants.OPERATION_ATTRIBUTES_TAG);
    compression = Utils.getFirstValueForName(attributes, 'compression');

    data = requestMessage.data;

    uri = '$printerUri$id';
    name = Utils.getFirstValueForName(attributes, 'job-name');
    userName = Utils.getFirstValueForName(attributes, 'requesting-user-name');
    createdAt = DateTime.now().toUtc();
  }

  List<Attribute> attributes(List<String>? filter) {
    if (filter != null && filter.contains('all')) {
      filter = null;
    }

    if (filter != null) {
      filter = Utils.expandAttrGroups(filter);
    }

    final attrs = <Attribute>[
      Attribute.from(tag: IppConstants.INTEGER, name: 'job-id', value: [id]),
      Attribute.from(tag: IppConstants.ENUM, name: 'job-state', value: [state]),
      Attribute.from(
          tag: IppConstants.URI, name: 'job-printer-uri', value: [uri]),
      Attribute.from(
          tag: IppConstants.INTEGER,
          name: 'job-printer-up-time',
          value: [Utils.time(printerStartedAt, DateTime.now().toUtc())]),
      Attribute.from(
          tag: IppConstants.NAME_WITHOUT_LANG, name: 'job-name', value: [name]),
      Attribute.from(
          tag: IppConstants.NAME_WITHOUT_LANG,
          name: 'job-originating-user-name',
          value: [userName]),
      Attribute.from(
          tag: IppConstants.KEYWORD,
          name: 'job-state-reasons',
          value: ['none']),
      Attribute.from(
          tag: IppConstants.INTEGER,
          name: 'time-at-creation',
          value: [Utils.time(printerStartedAt, createdAt)]),
      Attribute.from(
          tag: IppConstants.DATE_TIME,
          name: 'date-time-at-creation',
          value: [createdAt]),
      Attribute.from(
          tag: IppConstants.CHARSET,
          name: 'attributes-charset',
          value: ['utf-8']),
      Attribute.from(
          tag: IppConstants.NATURAL_LANG,
          name: 'attributes-natural-language',
          value: ['en-us']),
    ];

    if (filter == null || filter.contains('time-at-processing')) {
      if (_processingAt != null) {
        attrs.addAll([
          Attribute.from(
              tag: IppConstants.INTEGER,
              name: 'time-at-processing',
              value: [Utils.time(printerStartedAt, _processingAt!)]),
          Attribute.from(
              tag: IppConstants.DATE_TIME,
              name: 'date-time-at-processing',
              value: [_processingAt!]),
        ]);
      } else {
        attrs.addAll([
          Attribute.from(
              tag: IppConstants.NO_VALUE,
              name: 'time-at-processing',
              value: ['no-value']),
          Attribute.from(
              tag: IppConstants.NO_VALUE,
              name: 'date-time-at-processing',
              value: ['no-value']),
        ]);
      }

      if (filter == null || filter.contains('time-at-completed')) {
        if (completedAt != null) {
          attrs.addAll([
            Attribute.from(
                tag: IppConstants.INTEGER,
                name: 'time-at-completed',
                value: [Utils.time(printerStartedAt, completedAt!)]),
            Attribute.from(
                tag: IppConstants.DATE_TIME,
                name: 'date-time-at-completed',
                value: [completedAt!]),
          ]);
        } else {
          attrs.addAll([
            Attribute.from(
                tag: IppConstants.NO_VALUE,
                name: 'time-at-completed',
                value: ['no-value']),
            Attribute.from(
                tag: IppConstants.NO_VALUE,
                name: 'date-time-at-completed',
                value: ['no-value']),
          ]);
        }
      }
    }

    if (filter == null) {
      return attrs;
    }

    return attrs.where((attr) {
      return filter!.contains(attr.name);
    }).toList();
  }

  void process() {
    _processingAt = DateTime.now().toUtc();
    state = IppConstants.JOB_PROCESSING;

    Uint8List? decodedBytes;
    switch (compression ?? 'undefined') {
      case 'deflate':
        decodedBytes =
            Uint8List.fromList(const ZLibDecoder().decodeBytes(data!));
        break;
      case 'gzip':
        decodedBytes = Uint8List.fromList(GZipDecoder().decodeBytes(data!));
        break;
      case 'undefined':
        decodedBytes = data;
        break;
      default:
        abort(IppConstants.CLIENT_ERROR_COMPRESSION_NOT_SUPPORTED);
        return;
    }

    debugPrint('RETRIEVED PRINT PAYLOAD: LEN: ${decodedBytes?.length ?? 0}');
    if ((decodedBytes?.length ?? 0) > 0) {
      completedAt = DateTime.now().toUtc();
      onEnd?.call(
          decodedBytes!, attributes(['job-uri', 'job-id', 'job-state']));
      state = IppConstants.JOB_COMPLETED;
    }
  }

  void cancel() {
    state = IppConstants.JOB_CANCELED;
    onCancel?.call();
  }

  void abort(int statusCode) {
    state = IppConstants.JOB_ABORTED;
    onAbort?.call(statusCode);
  }
}
