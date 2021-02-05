class HttpException implements Exception {
  // implements means it takes on all the functions of Exception class
  final String message;
  HttpException(this.message);

  @override
  String toString() {
    // TODO: implement toString
    return message;
  }
}
