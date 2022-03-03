import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:mobile_printer/ipp/airprint/type_codec.dart';

abstract class AnswerEncoder {
  int encodedBytes = 0;

  void encode(dynamic data, ByteData buf, int offset);

  int encodingLength(dynamic data);
}

// A, TXT, PTR, SRV
AnswerEncoder answerEncoderForType(String type) {
  switch (type.toUpperCase()) {
    case 'A':
      return _ARecordEncoder();
    case 'TXT':
      return _TxtRecordEncoder();
    case 'PTR':
      return _PtrRecordEncoder();
    case 'SRV':
      return _SrvRecordEncoder();
    default:
      return _UnknownEncoder();
  }
}

class _ARecordEncoder extends AnswerEncoder {
  @override
  void encode(data, ByteData buf, int offset) {
    final host = data as String;
    buf.setUint16(offset, 4);
    offset += 2;
    final hostBytes = InternetAddress(host).rawAddress;
    for (int i = 0; i < hostBytes.length; i++) {
      buf.setUint8(offset, hostBytes[i]);
      offset++;
    }
    encodedBytes = 6;
  }

  @override
  int encodingLength(data) {
    return 6;
  }
}

class _TxtRecordEncoder extends AnswerEncoder {
  @override
  void encode(data, ByteData buf, int offset) {
    if (data is String) {
      data = utf8.encode(data);
    }

    var oldOffset = offset;
    offset += 2;

    data = data as Uint8List;
    final len = data.length;
    var st = offset;
    for (int i = 0; i < len; i++) {
      buf.setUint8(st, data[i]);
      st++;
    }
    offset += len;

    buf.setUint16(oldOffset, offset - oldOffset - 2);
    encodedBytes = offset - oldOffset;
  }

  @override
  int encodingLength(data) {
    if (data is Uint8List) {
      return data.length;
    }

    return utf8.encode(data as String).length + 2;
  }
}

class _PtrRecordEncoder extends AnswerEncoder {
  @override
  void encode(data, ByteData buf, int offset) {
    final name = NameEncoder();
    name.encode(data as String, buf, offset + 2);
    buf.setUint16(offset, name.encodedBytes);
    encodedBytes = name.encodedBytes + 2;
  }

  @override
  int encodingLength(data) {
    final name = NameEncoder();
    return name.encodingLength(data as String) + 2;
  }
}

class SrvRecord {
  final int port;
  final int weight;
  final int priority;
  final String target;

  SrvRecord({
    required this.port,
    required this.weight,
    required this.priority,
    required this.target,
  });
}

class _SrvRecordEncoder extends AnswerEncoder {
  @override
  void encode(data, ByteData buf, int offset) {
    data = data as SrvRecord;
    buf.setUint16(offset + 2, data.priority);
    buf.setUint16(offset + 4, data.weight);
    buf.setUint16(offset + 6, data.port);
    final name = NameEncoder();
    name.encode(data.target, buf, offset + 8);

    final len = name.encodedBytes + 6;
    buf.setUint16(offset, len);

    encodedBytes = len + 2;
  }

  @override
  int encodingLength(data) {
    final name = NameEncoder();
    return 8 + name.encodingLength((data as SrvRecord).target);
  }
}

class _UnknownEncoder extends AnswerEncoder {
  @override
  void encode(data, ByteData buf, int offset) {
    data = data as Uint8List;

    buf.setUint16(offset, data.length);
    var st = offset + 2;
    for (int i = 0; i < data.length; i++) {
      buf.setUint8(st, data[i]);
      st++;
    }
    encodedBytes = data.length + 2;
  }

  @override
  int encodingLength(data) {
    data = data as Uint8List;
    return data.length + 2;
  }
}
