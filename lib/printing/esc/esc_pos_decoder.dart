import 'dart:typed_data';

import 'commands.dart';
import 'get_full_command.dart';
import 'models.dart';

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
        tokens.add(PrintToken.fullCommand(commandWithArgs));
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
        // String text = utf8.decode(textBB.toBytes(), allowMalformed: true);
        tokens.add(PrintToken.data(textBB.toBytes()));
      }
    }

    return tokens;
  }

  bool isCommand(int byte) {
    return commands.contains(byte);
  }
}
