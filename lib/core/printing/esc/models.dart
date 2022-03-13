import 'dart:typed_data';

class PrintToken {
  bool isCommand;
  FullCommand? fullCommand;
  Uint8List? dataBytes;

  PrintToken.fullCommand(this.fullCommand) : isCommand = true;

  PrintToken.data(this.dataBytes) : isCommand = false;

  Map toJson() => {
        'isCommand': isCommand,
        'fullCommand': fullCommand?.toJson(),
        'data': dataBytes?.toList(),
      };
}

class FullCommand {
  final Uint8List commandBytes;

  /// for commands that have extra data e.g printing barcodes
  final Uint8List? dataBytes;

  FullCommand({
    required this.commandBytes,
    this.dataBytes,
  });

  int get lengthInBytes => commandBytes.length + (dataBytes?.length ?? 0);

  Map toJson() => {
        'commandBytes': commandBytes.toList(),
        'commandDataBytes': dataBytes?.toList(),
      };
}
