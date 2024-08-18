class ServerException implements Exception {
  final String message;

  const ServerException(this.message);

  String toString() {
    return "ServerException: $message";
  }
}
