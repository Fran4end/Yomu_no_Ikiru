/// A base class representing a failure or error condition.
///
/// This class can be extended to create specific types of failures
/// that can be used throughout the application to handle different
/// error scenarios in a consistent manner.
class Failure {
  final String message;
  Failure([this.message = "An unexpected error occurred"]);
}