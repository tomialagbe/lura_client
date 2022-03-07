// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:typed_data';


import 'answer_data_encoders.dart';
import 'dns_query_response.dart';
import 'types.dart';

const AUTHORITATIVE_ANSWER = 1 << 10;
const TRUNCATED_RESPONSE = 1 << 9;
const RECURSION_DESIRED = 1 << 8;
const RECURSION_AVAILABLE = 1 << 7;
const AUTHENTIC_DATA = 1 << 5;
const CHECKING_DISABLED = 1 << 4;
const DNSSEC_OK = 1 << 15;

const QUERY_FLAG = 0;
const RESPONSE_FLAG = 1 << 15;
const FLUSH_MASK = 1 << 15;
const NOT_FLUSH_MASK = ~FLUSH_MASK;
const QU_MASK = 1 << 15;
const NOT_QU_MASK = ~QU_MASK;

int encodedBytes = 0;

Uint8List encodeDnsQueryResponse(DnsQueryResponse response) {
  final buffer = ByteData(encodingLength(response));
  int offset = 0;
  final oldOffset = offset;

  final header = HeaderEncoder();
  header.encode(response, buffer, offset);
  offset += header.encodedBytes;

  offset = encodeList(response.answers, buffer, offset);
  encodedBytes = offset - oldOffset;
  return buffer.buffer.asUint8List();
}

int encodingLength(DnsQueryResponse result) {
  final header = HeaderEncoder();
  return header.encodingLength() + encodingLengthList(result.answers);
}

int encodeList(List<DnsAnswer> list, ByteData buf, int offset) {
  final enc = DnsAnswerEncoder();
  for (int i = 0; i < list.length; i++) {
    enc.encode(list[i], buf, offset);
    offset += enc.encodedBytes;
  }
  return offset;
}

int encodingLengthList(List<DnsAnswer> list) {
  int len = 0;
  final enc = DnsAnswerEncoder();
  for (int i = 0; i < list.length; i++) {
    len += enc.encodingLength(list[i]);
  }
  return len;
}

class HeaderEncoder {
  int encodedBytes = 12;

  void encode(DnsQueryResponse response, ByteData buf, int offset) {
    // const flags = 0 & 32767;
    // const type = RESPONSE_FLAG;

    buf.setUint16(offset, 0); // id
    buf.setUint16(offset + 2, RESPONSE_FLAG);
    // buf.setUint16(offset + 2, flags | type);
    buf.setUint16(offset + 4, response.questions.length);
    buf.setUint16(offset + 6, response.answers.length);
    buf.setUint16(offset + 8, response.authorities.length);
    buf.setUint16(offset + 10, response.additionals.length);
  }

  int encodingLength() {
    return 12;
  }
}

class NameEncoder {
  int encodedBytes = 0;

  // TODO: LOOK HERE
  void encode(String name, ByteData buffer, int offset) {
    // final buffer = ByteData(encodingLength(name));
    final oldOffset = offset;

    // strip leading and trailing `.`
    final n = name.replaceAll(RegExp(r'^\.|\.$'), '');
    if (n.isNotEmpty) {
      final list = n.split('.');
      for (int i = 0; i < list.length; i++) {
        final part = list[i];
        final partBytes = utf8.encode(part);
        final len = partBytes.length;
        buffer.setUint8(offset, len);
        var st = offset + 1;
        for (int j = 0; j < partBytes.length; j++) {
          buffer.setUint8(st, partBytes[j]);
          st++;
        }
        offset += len + 1;
      }
    }

    buffer.setUint8(offset++, 0);
    encodedBytes = offset - oldOffset;
  }

  int encodingLength(String n) {
    if (n == '.' || n == '..') {
      return 1;
    }

    final val = n.replaceAll(RegExp(r'^\.|\.$'), '');
    return utf8.encode(val).length + 2;
  }
}

class DnsAnswerEncoder {
  int encodedBytes = 0;

  void encode(DnsAnswer a, ByteData buf, int offset) {
    var oldOffset = offset;
    final name = NameEncoder();
    name.encode(a.name, buf, offset);
    offset += name.encodedBytes;

    buf.setUint16(offset, Types.toType(a.type));

    var klass = 1;
    if (a.flush) {
      klass |= FLUSH_MASK;
    }
    buf.setUint16(offset + 2, klass);

    buf.setUint32(offset + 4, a.ttl);

    final enc = answerEncoderForType(a.type);
    enc.encode(a.data, buf, offset + 8);
    offset += 8 + enc.encodedBytes;

    encodedBytes = offset - oldOffset;
  }

  int encodingLength(DnsAnswer a) {
    final encoder = answerEncoderForType(a.type);
    final name = NameEncoder();
    return name.encodingLength(a.name) + 8 + encoder.encodingLength(a.data);
  }
}
