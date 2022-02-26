import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import 'constants.dart';
import 'ipp_message.dart';
import 'type_codec.dart';

class IppRequestDecoder {
  int decodedBytes = 0;

  IppMessage decode(Uint8List buffer, {int? start = 0, int? end}) {
    final message = IppMessage();

    start ??= 0;
    end ??= buffer.length;
    var offset = start;
    final byteData = ByteData.view(buffer.buffer);

    message.versionMajor = byteData.getInt8(offset++);
    message.versionMinor = byteData.getInt8(offset++);
    message.operationIdOrStatusCode = byteData.getInt16(offset);
    offset += 2;
    message.requestId = byteData.getInt32(offset);
    offset += 4;

    // process attribute groups
    var tag = byteData.getInt8(offset++);
    while (tag != IppConstants.END_OF_ATTRIBUTES_TAG && offset < end) {
      final group = AttributeGroup();
      group.tag = tag;

      tag = byteData.getInt8(offset++); // value-tag
      while (tag > 0x0f) {
        final stringDecoder = StringDecoder();
        String? name;
        // try {
        //   name = stringDecoder.decode(byteData, offset);
        //   offset += stringDecoder.decodedBytes;
        // } catch (err) {}
        name = stringDecoder.decode(byteData, offset);
        offset += stringDecoder.decodedBytes;

        var val;
        switch (tag) {
          case IppConstants.INTEGER:
            final tint = IntTagDecoder();
            val = tint.decode(byteData, offset);
            offset += tint.decodedBytes;
            break;
          case IppConstants.BOOLEAN:
            final tbool = BoolTagDecoder();
            val = tbool.decode(byteData, offset);
            offset += tbool.decodedBytes;
            break;
          case IppConstants.ENUM:
            final tenum = EnumTagDecoder();
            val = tenum.decode(byteData, offset);
            offset += tenum.decodedbytes;
            break;
          case IppConstants.DATE_TIME:
            final tdatetime = DateTimeDecoder();
            val = tdatetime.decode(byteData, offset);
            offset += tdatetime.decodedBytes;
            break;
          case IppConstants.TEXT_WITH_LANG:
          case IppConstants.NAME_WITH_LANG:
            final langstr = LangstrDecoder();
            val = langstr.decode(byteData, offset);
            offset += langstr.decodedBytes;
            break;
          default:
            val = stringDecoder.decode(byteData, offset);
            offset += stringDecoder.decodedBytes;
        }

        final attr = Attribute();
        if (name == null || name.isEmpty) {
          attr.value.add(val);
        } else {
          attr
            ..tag = tag
            ..name = name
            ..value = [val];
          group.attributes.add(attr);
        }

        tag = byteData.getInt8(offset++);
      }

      message.groups.add(group);
    }

    if (offset < end) {
      message.data = byteData.buffer.asUint8List(offset, end - offset);
    }
    decodedBytes = offset - start;
    return message;
  }
}

class IppResponseEncoder {
  int encodedBytes = 0;

  Uint8List encode(IppMessage response) {
    final encLen = encodingLength(response);
    final buffer = ByteData(encLen + 100);   //TODO: FIX THIS, calculate correct encoding length
    var offset = 0;
    var oldOffset = offset;

    buffer.setInt8(offset++, response.versionMajor ?? 1);
    buffer.setInt8(offset++, response.versionMinor ?? 1);

    buffer.setInt16(offset, response.operationIdOrStatusCode!);
    offset += 2;

    buffer.setInt32(offset, response.requestId!);
    offset += 4;

    for (var group in response.groups) {
      buffer.setInt8(offset++, group.tag!);

      for (var attr in group.attributes) {
        var value = attr.value;
        for (int i = 0; i < value.length; i++) {
          var val = value[i];

          buffer.setInt8(offset++, attr.tag!);

          final str = StringEncoder();
          str.encode(attr.name ?? '', buffer, offset);
          offset += str.encodedBytes;

          switch (attr.tag) {
            case IppConstants.INTEGER:
              final tint = IntTagEncoder();
              tint.encode(val as int, buffer, offset);
              offset += tint.encodedBytes;
              break;
            case IppConstants.BOOLEAN:
              final tbool = BoolTagEncoder();
              tbool.encode(val as bool, buffer, offset);
              offset += tbool.encodedBytes;
              break;
            case IppConstants.ENUM:
              final tenum = EnumTagEncoder();
              tenum.encode(val as int, buffer, offset);
              offset += tenum.encodedBytes;
              break;
            case IppConstants.DATE_TIME:
              final tdateTime = DateTimeEncoder();
              tdateTime.encode(val as DateTime, buffer, offset);
              offset += tdateTime.encodedBytes;
              break;
            case IppConstants.TEXT_WITH_LANG:
            case IppConstants.NAME_WITH_LANG:
              final langStr = LangStrEncoder();
              langStr.encode(val as LangStr, buffer, offset);
              offset += langStr.encodedBytes;
              break;
            default:
              debugPrint('Encoding string: ${val as String}');
              str.encode(val as String, buffer, offset);
              offset += str.encodedBytes;
              break;
          }
        }
      }
    }

    buffer.setInt8(offset++, IppConstants.END_OF_ATTRIBUTES_TAG);
    if (response.data != null) {
      buffer.buffer.asUint8List(offset).insertAll(0, response.data!);
      offset += response.data!.length;
    }
    encodedBytes = offset - oldOffset;
    return buffer.buffer.asUint8List();
  }

  int encodingLength(IppMessage message) {
    var encLen = 8; // version-number + status-code + request-id

    encLen += message.groups.fold(0, (len, group) {
      len += 1;
      len += group.attributes.fold(0, (len, attr) {
        var value = attr.value;
        len += value.fold(0, (len, val) {
          len += 1; // value tag
          len +=
              StringEncoder().encodingLength(len == 1 ? attr.name ?? '' : '');

          switch (attr.tag) {
            case IppConstants.INTEGER:
              return len + IntTagEncoder().encodingLength();
            case IppConstants.BOOLEAN:
              return len + BoolTagEncoder().encodingLength();
            case IppConstants.ENUM:
              return len + EnumTagEncoder().encodingLength();
            case IppConstants.DATE_TIME:
              return len + DateTimeEncoder().encodingLength();
            case IppConstants.TEXT_WITH_LANG:
            case IppConstants.NAME_WITH_LANG:
              return len + LangStrEncoder().encodingLength(val as LangStr);
            default:
              debugPrint('Encoding length for ${val as String}');
              return len + StringEncoder().encodingLength(val as String);
          }
        });

        return len;
      });

      return len;
    });

    encLen++; // end-of-attributes-tag
    if (message.data != null) {
      encLen += message.data?.length ?? 0;
    }

    return encLen;
  }
}
