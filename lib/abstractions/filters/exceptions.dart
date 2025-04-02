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

/// Exception thrown when there is an error with indexing in CollQL.
class IndexingException extends CollQLException {
  IndexingException(super.message, {super.stackTrace, super.cause});
}

/// Exception thrown when an invalid ID is encountered.
class InvalidIdException extends CollQLException {
  InvalidIdException(super.message, {super.stackTrace, super.cause});
}

/// Exception thrown when an invalid operation is performed.
class InvalidOperationException extends CollQLException {
  InvalidOperationException(super.message, {super.stackTrace, super.cause});
}

/// Exception thrown when there is an IO error while performing an operation
/// on CollQL database.
class CollQLIOException extends CollQLException {
  CollQLIOException(super.message, {super.stackTrace, super.cause});
}

/// Exception thrown when a validation error occurs.
class ValidationException extends CollQLException {
  ValidationException(super.message, {super.stackTrace, super.cause});
}

/// Exception thrown during find operations due to invalid filter expression.
class FilterException extends CollQLException {
  FilterException(super.message, {super.stackTrace, super.cause});
}

/// Exception thrown when an object cannot be identified.
class NotIdentifiableException extends CollQLException {
  NotIdentifiableException(super.message, {super.stackTrace, super.cause});
}

/// Exception thrown when a unique constraint is violated.
class UniqueConstraintException extends CollQLException {
  UniqueConstraintException(super.message, {super.stackTrace, super.cause});
}

/// Exception thrown when there is an error mapping an object to a
/// document or vice versa.
class ObjectMappingException extends CollQLException {
  ObjectMappingException(super.message, {super.stackTrace, super.cause});
}

/// Exception thrown when a CollQL plugin encounters an error.
class PluginException extends CollQLException {
  PluginException(super.message, {super.stackTrace, super.cause});
}

/// Exception thrown when a security violation occurs in CollQL.
class CollQLSecurityException extends CollQLException {
  CollQLSecurityException(super.message, {super.stackTrace, super.cause});
}

/// Exception thrown when there is an error during database migration.
class MigrationException extends CollQLException {
  MigrationException(super.message, {super.stackTrace, super.cause});
}

/// Exception thrown when an error occurs during a transaction.
class TransactionException extends CollQLException {
  TransactionException(super.message, {super.stackTrace, super.cause});
}
