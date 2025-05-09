/// Base class for all CollQL exceptions.
class CollQLException implements Exception {
  final String message;
  final StackTrace stackTrace;
  final dynamic cause;

  CollQLException(this.message, {StackTrace? stackTrace, this.cause})
      : stackTrace = stackTrace ?? StackTrace.current;

  @override
  String toString() => '${runtimeType.toString()}: $message\n$stackTrace'
      '${cause != null ? "\nCaused by: $cause" : ""}';
}

/// Exception thrown during find operations due to invalid filter expression.
class FilterException extends CollQLException {
  FilterException(super.message, {super.stackTrace, super.cause});
}