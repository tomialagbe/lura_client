abstract class PrinterEmulator {
  Future start();

  Future stop();

  Stream<bool> isRunning();
}
