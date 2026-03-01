import 'package:dio/dio.dart';
import 'package:dt_digital_studio/core/error/failures.dart';

/// Maps a [DioException] to a domain-level [Failure].
Failure mapDioExceptionToFailure(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionError:
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
      return const NetworkFailure();
    case DioExceptionType.badResponse:
      final status = e.response?.statusCode;
      if (status == 401) return const UnauthorizedFailure();
      return ServerFailure(
        statusCode: status,
        message: _extractMessage(e.response?.data) ?? e.message ?? 'Server error',
      );
    case DioExceptionType.cancel:
      return const UnknownFailure('Request cancelled');
    default:
      return UnknownFailure(e.message ?? 'An unexpected error occurred');
  }
}

/// Maps any generic [Exception] to a domain-level [Failure].
Failure mapExceptionToFailure(Object e) {
  if (e is DioException) return mapDioExceptionToFailure(e);
  return UnknownFailure(e.toString());
}

String? _extractMessage(dynamic data) {
  if (data is Map<String, dynamic>) {
    return data['message'] as String? ?? data['error'] as String?;
  }
  return null;
}
