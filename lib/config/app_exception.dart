class AppException implements Exception {
  final String message;
  final String description ;

  AppException(this.message, this.description );

  String toString() {
    return "->$message  || ERROR OCCURRED || -> $description";
  }
 }