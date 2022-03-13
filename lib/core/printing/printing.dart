abstract class Printer {
  Future start();

  Future stop();

  Stream<bool> isRunning();
}
