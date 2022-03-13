import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import 'commands.dart';
import 'models.dart';

FullCommand? getFullCommand(int command, ByteData buffer, int startOffset) {
  int currOffset = startOffset;

  var filtered = Map<List<int>, int>.from(fullCommands)
    ..removeWhere((key, value) => key[0] != command);
  final commands = filtered.keys.toList();
  List<int> matchingCommand = [];
  for (final comm in commands) {
    final clen = comm.length;
    final len =
    clen + currOffset > buffer.lengthInBytes ? buffer.lengthInBytes : clen;
    final bytes = buffer.buffer.asUint8List(currOffset, len);
    // currOffset += len;
    if (bytes.length != clen) {
      continue;
    }

    bool allMatch = true;
    for (int i = 0; i < len; i++) {
      if (bytes[i] != comm[i]) {
        allMatch = false;
        break;
      }
    }

    if (allMatch && clen > matchingCommand.length) {
      matchingCommand = comm;
    }
  }

  // we've found the command, now get the args
  final en = filtered.entries.firstWhere(
        (entry) => entry.key == matchingCommand,
    orElse: () => const MapEntry(<int>[], 0),
  );

  if (matchingCommand.isEmpty) {
    print(
        'Empty matching command for $command found at $currOffset with neighbouring bytes ${buffer.buffer.asUint8List(currOffset, 10).join(', ')}');
    return null;
  }

  currOffset += matchingCommand.length;

  int paramLen = en.value;

  int? dataLen;
  if (paramLen == -1) {
    final varArgs = variableArgCommands[matchingCommand]!(buffer, currOffset);
    paramLen = varArgs.item1;
    dataLen = varArgs.item2;
  }
  final len = paramLen + currOffset > buffer.lengthInBytes
      ? buffer.lengthInBytes
      : paramLen;
  final bytes = buffer.buffer.asUint8List(currOffset, len);
  currOffset += len;
  final fullCommandBytes = [...matchingCommand, ...bytes];
  Uint8List? dataBytes;
  if (dataLen != null && dataLen > 0) {
    try {
      debugPrint(
          'Attempting to extract data bytes of length: $dataLen.\nBuffer size: ${buffer.lengthInBytes}\nCurr Offset: $currOffset');
      // if (currOffset + dataLen <= buffer.lengthInBytes) {
      dataBytes = buffer.buffer.asUint8List(currOffset, dataLen);
    } catch (err) {
      debugPrint(
          'Failed to extract data bytes of length: $dataLen. ${err.toString()}');
      rethrow;
    }
  }
  debugPrint(
      'Decoded: \nHeader: ${fullCommandBytes.join(', ')}\nData: ${dataBytes?.join(', ') ?? ''}\nData Len: ${dataBytes?.length ?? 0}\nCalculated Data Len: $dataLen\n\n');
  return FullCommand(
      commandBytes: Uint8List.fromList(fullCommandBytes), dataBytes: dataBytes);
}
