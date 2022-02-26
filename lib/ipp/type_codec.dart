import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import 'constants.dart';
import 'dart:math';

class StringDecoder {
  int decodedBytes = 0;

  String decode(ByteData buffer, int offset) {
    final len = buffer.getInt16(offset);
    final buffSize = buffer.buffer.lengthInBytes;
    final start = offset + 2;
    final end = offset + 2 + len;
    // Uint8List subl;
    // if (start + end <= buffSize) {
    //   subl = buffer.buffer.asUint8List(start, end - start);
    // } else {
    //   subl = buffer.buffer.asUint8List(start);
    // }
    final subl = buffer.buffer.asUint8List(start, end - start);
    String s = utf8.decode(subl); // try allowMalformed if this fails
    debugPrint('StringDecoder, received: $s');
    decodedBytes = len + 2;
    return s;
  }
}

class StringEncoder {
  int encodedBytes = 0;

  void encode(String s, ByteData buffer, int offset) {
    final bytes = utf8.encode(s);
    final len = bytes.length;
    var startOffset = offset + 2;
    for (int i = 0; i < len; i++) {
      buffer.setUint8(startOffset, bytes[i]);
      startOffset++;
    }
    buffer.setInt16(offset, len);
    encodedBytes = len + 2;
  }

  int encodingLength(String s) {
    return utf8.encode(s).length;
  }
}

class IntTagDecoder {
  int decodedBytes = 0;

  int decode(ByteData buffer, int offset) {
    final i = buffer.getInt32(offset + 2);
    decodedBytes = 6;
    return i;
  }
}

class IntTagEncoder {
  int encodedBytes = 0;

  void encode(int i, ByteData buffer, int offset) {
    buffer.setInt16(offset, 4);
    buffer.setInt32(offset + 2, i);
    encodedBytes = 6;
    return;
  }

  int encodingLength() => 6;
}

class BoolTagDecoder {
  int decodedBytes = 0;

  bool decode(ByteData buffer, int offset) {
    final b = buffer.getInt8(offset + 2) == IppConstants.TRUE;
    decodedBytes = 3;
    return b;
  }
}

class BoolTagEncoder {
  int encodedBytes = 0;

  void encode(bool b, ByteData buffer, int offset) {
    buffer.setInt16(offset, 1);
    buffer.setInt8(offset + 2, b ? IppConstants.TRUE : IppConstants.FALSE);
    encodedBytes = 3;
  }

  int encodingLength() => 3;
}

class EnumTagDecoder {
  int decodedbytes = 0;

  int decode(ByteData buffer, int offset) {
    final i = buffer.getInt32(offset + 2);
    decodedbytes = 6;
    return i;
  }
}

class EnumTagEncoder {
  int encodedBytes = 0;

  void encode(int i, ByteData buffer, int offset) {
    buffer.setInt16(offset, 4);
    buffer.setInt32(offset + 2, i);
    encodedBytes = 6;
    return;
  }

  int encodingLength() => 6;
}

class DateTimeDecoder {
  int decodedBytes = 0;

  DateTime decode(ByteData buffer, int offset) {
    var drift =
        (buffer.getInt8(offset + 11) * 60) + buffer.getInt8(offset + 12);
    final start = offset + 10;
    final end = offset + 11;
    final subl = buffer.buffer.asUint8List(start, end - start);
    String s = utf8.decode(subl);
    if (s == '+') {
      drift = drift * -1;
    }

    final date = DateTime.utc(
      buffer.getInt16(offset + 2),
      buffer.getInt8(offset + 4) - 1,
      buffer.getInt8(offset + 5),
      buffer.getInt8(offset + 6),
      buffer.getInt8(offset + 7) + drift,
      buffer.getInt8(offset + 8),
      buffer.getInt8(offset + 9) * 100,
    );
    decodedBytes = 13;
    return date;
  }
}

class DateTimeEncoder {
  int encodedBytes = 0;

  void encode(DateTime d, ByteData buffer, int offset) {
    final jsTzoffset = -(d.timeZoneOffset.inMinutes);
    buffer.setInt16(offset, 11);
    buffer.setInt16(offset + 2, d.year);
    buffer.setInt8(offset + 4, d.month + 1);
    buffer.setInt8(offset + 5, d.day);
    buffer.setInt8(offset + 6, d.hour);
    buffer.setInt8(offset + 7, d.minute);
    buffer.setInt8(offset + 8, d.second);
    buffer.setInt8(offset + 9, (d.millisecond / 100).floor());
    buffer.setUint8(
        offset + 10, jsTzoffset > 0 ? '-'.codeUnits[0] : '+'.codeUnits[0]);
    buffer.setInt8(offset + 11, jsTzoffset ~/ 60);
    buffer.setInt8(offset + 12, jsTzoffset % 60);

    encodedBytes = 13;
  }

  int encodingLength() => 13;
}

class LangStr {
  final String lang;
  final String value;

  LangStr({required this.lang, required this.value});
}

class LangstrDecoder {
  int decodedBytes = 0;

  LangStr decode(ByteData buffer, int offset) {
    final str = StringDecoder();
    var oldOffset = offset;
    offset += 2;
    final lang = str.decode(buffer, offset);
    offset += str.decodedBytes;
    final val = str.decode(buffer, offset);
    offset += str.decodedBytes;
    decodedBytes = offset - oldOffset;
    return LangStr(lang: lang, value: val);
  }
}

class LangStrEncoder {
  int encodedBytes = 0;

  void encode(LangStr obj, ByteData buffer, int offset) {
    final str = StringEncoder();
    str.encode(obj.lang, buffer, offset + 2);
    var len = str.encodedBytes;
    str.encode(obj.value, buffer, offset + 2 + len);
    len += str.encodedBytes;
    buffer.setInt16(offset, len);
    encodedBytes = len + 2;
  }

  int encodingLength(LangStr langStr) {
    return utf8.encode(langStr.lang).length +
        utf8.encode(langStr.value).length +
        6;
  }
}
