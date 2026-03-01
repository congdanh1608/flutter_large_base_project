/// A discriminated union representing the result of an API/repository call.
///
/// Usage:
/// ```dart
/// final result = await repo.login(email, password);
/// switch (result) {
///   case ApiSuccess(:final data):
///     // use data
///   case ApiFailure(:final failure):
///     // handle failure
/// }
/// ```
sealed class ApiResult<T> {
  const ApiResult();

  bool get isSuccess => this is ApiSuccess<T>;
  bool get isFailure => this is ApiFailure<T>;

  T? get dataOrNull => switch (this) {
        ApiSuccess(:final data) => data,
        ApiFailure() => null,
      };

  Object? get failureOrNull => switch (this) {
        ApiSuccess() => null,
        ApiFailure(:final failure) => failure,
      };

  /// Transform the success value while preserving failures.
  ApiResult<R> map<R>(R Function(T data) transform) => switch (this) {
        ApiSuccess(:final data) => ApiSuccess(transform(data)),
        ApiFailure(:final failure) => ApiFailure(failure),
      };

  /// Execute a function based on the result type.
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Object failure) onFailure,
  }) =>
      switch (this) {
        ApiSuccess(:final data) => onSuccess(data),
        ApiFailure(:final failure) => onFailure(failure),
      };
}

final class ApiSuccess<T> extends ApiResult<T> {
  final T data;
  const ApiSuccess(this.data);
}

final class ApiFailure<T> extends ApiResult<T> {
  final Object failure; // Failure from failures.dart
  const ApiFailure(this.failure);
}

