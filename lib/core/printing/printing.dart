import 'dart:typed_data';

abstract class PrinterEmulator {
  Future start();

  Future stop();

  Stream<bool> isRunning();
}
