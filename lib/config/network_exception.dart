class NetworkException implements Exception {
  final String message;
  final int code;

  NetworkException(this.message, this.code);

  String toString() {
    return "->$code  || ERROR OCCURRED || -> $message";
  }

  String getMessage() {
    return message;
  }
}
