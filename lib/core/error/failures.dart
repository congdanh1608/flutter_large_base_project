/// Sealed class hierarchy for domain-layer failures.
///
/// All repository methods return `ApiResult<T>` which carries one of these on failure.
sealed class Failure {
  final String message;
  const Failure(this.message);
}

/// Network connectivity issues (no internet, timeout, etc.)
final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

/// HTTP 4xx / 5xx or unexpected server response
final class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure({required String message, this.statusCode}) : super(message);
}

/// HTTP 401 — token expired or invalid
final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Session expired. Please login again.']);
}

/// Local cache read/write errors (SharedPreferences, Hive, SecureStorage)
final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local storage error']);
}

/// Fallback for unexpected / unclassified errors
final class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred']);
}
