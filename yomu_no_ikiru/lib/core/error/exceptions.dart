/// A custom exception that represents an error occurring on the server side.
/// 
/// This exception should be thrown when the server returns an error response
/// or when there is an issue with the server that prevents a successful
/// operation.
/// 
/// Example usage:
/// 
/// ```dart
/// try {
///   ...
/// } on ServerException {
///   ...
/// }
/// ```
class ServerException implements Exception {
  final String message;

  const ServerException(this.message);

  @override
  String toString() {
    return "ServerException: $message";
  }
}
