class TimeoutException implements Exception {
  final String message;

  TimeoutException(this.message);

  @override
  String toString() => 'TimeoutException($message)';
}

class ConnectTimeoutException extends TimeoutException {
  ConnectTimeoutException(String message) : super(message);
}

class ResponseTimeoutException extends TimeoutException {
  ResponseTimeoutException(String message) : super(message);
}

class ResponseException implements TimeoutException {
  final int statusCode;
  @override
  final String message;
  final String? responseMessage;

  ResponseException(
      {required this.statusCode, required this.message, this.responseMessage});
}
