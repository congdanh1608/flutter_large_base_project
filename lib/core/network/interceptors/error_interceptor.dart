import 'package:dio/dio.dart';
import 'package:dt_digital_studio/core/error/error_mapper.dart';

/// Transforms [DioException] into app-level failures.
/// Also normalises the error message to be user-friendly.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final failure = mapDioExceptionToFailure(err);
    // Enrich the error with the mapped failure message for upstream consumers
    final updatedError = err.copyWith(
      message: failure.message,
    );
    super.onError(updatedError, handler);
  }
}
