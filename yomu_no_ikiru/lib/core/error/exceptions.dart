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
///
/// See also:
/// - [Exception] for the base class of all exceptions.
class ServerException implements Exception {
  final String message;

  const ServerException(this.message);

  @override
  String toString() {
    return "ServerException: $message";
  }
}

/// Exception thrown when a file is not found in the library.
///
/// This exception should be used to indicate that a specific file,
/// which is expected to be present in the library, is missing.
///
/// Example usage:
/// ```dart
/// void someFunction() {
///   if (!fileExistsInLibrary) {
///     throw FileNotOnLibraryException();
///   }
/// }
/// ```
///
/// See also:
/// - [Exception] for the base class of all exceptions.
class FileNotOnLibraryException implements Exception {
  final String cause;

  const FileNotOnLibraryException(this.cause);

  @override
  String toString() {
    return "FileNotOnLibraryException: $cause";
  }
}

class NoConnectionException implements Exception {
  @override
  String toString() {
    return "NoConnectionException: No connection available, please connect to the internet";
  }
}

class NoMoreMangaException implements Exception {
  @override
  String toString() {
    return "NoMoreMangaException: there is no more manga to load";
  }
}
