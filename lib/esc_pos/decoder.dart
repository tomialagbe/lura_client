import 'dart:convert';
import 'dart:typed_data';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;

import 'commands.dart';
import 'extract.dart';

class PrintToken {
  bool isCommand;
  FullCommand? command;
  String? data;
  Uint8List? dataBytes;

  PrintToken.command(this.command) : isCommand = true;

  PrintToken.data(this.data, this.dataBytes) : isCommand = false;

  Map toJson() => {
    'isCommand': isCommand,
    'fullCommand': command?.toJson(),
    'data': dataBytes?.toList(),
  };
}

class EscPosDecoder {
  List<PrintToken> decode(Uint8List data) {
    final tokens = <PrintToken>[];

    int len = data.length;
    int offset = 0;
    final buffer = ByteData.sublistView(data);
    while (offset < len) {
      var byte = buffer.getUint8(offset);
      // check if byte is a command
      if (isCommand(byte)) {
        final commandWithArgs = getFullCommand(byte, buffer, offset);
        if (commandWithArgs == null) {
          // print(
          //     'Unable to extract command. commandWithArgs is empty. Skipping...');
          continue;
        }
        tokens.add(PrintToken.command(commandWithArgs));
        offset += commandWithArgs.lengthInBytes;
      } else {
        final textBB = BytesBuilder();
        while (!isCommand(byte)) {
          textBB.addByte(byte);
          offset++;
          if (offset < buffer.lengthInBytes) {
            byte = buffer.getUint8(offset);
          } else {
            break;
          }
        }
        String text = utf8.decode(textBB.toBytes(), allowMalformed: true);
        tokens.add(PrintToken.data(text, textBB.toBytes()));
      }
    }

    return tokens;
  }

  bool isCommand(int byte) {
    return commands.contains(byte);
  }
}

