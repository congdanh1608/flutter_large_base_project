import 'package:dio/dio.dart';
import 'package:dt_digital_studio/core/storage/secure_storage_service.dart';
import 'package:dt_digital_studio/core/config/app_constants.dart';

/// Attaches the Bearer token to every outgoing request.
/// On 401, attempts a token refresh and retries the original request once.
class AuthInterceptor extends Interceptor {
  final Dio _dio;

  AuthInterceptor(this._dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await SecureStorageService.instance.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshed = await _tryRefreshToken();
      if (refreshed) {
        // Retry original request with new token
        final token = await SecureStorageService.instance.getAccessToken();
        final opts = err.requestOptions;
        opts.headers['Authorization'] = 'Bearer $token';
        try {
          final response = await _dio.fetch(opts);
          return handler.resolve(response);
        } catch (_) {}
      }
      // Clear tokens and propagate the 401
      await SecureStorageService.instance.clearTokens();
    }
    super.onError(err, handler);
  }

  Future<bool> _tryRefreshToken() async {
    try {
      final refreshToken = await SecureStorageService.instance.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
        options: Options(headers: {'Authorization': ''}), // skip auth interceptor
      );

      final newAccessToken = response.data[AppConstants.keyAccessToken] as String?;
      final newRefreshToken = response.data[AppConstants.keyRefreshToken] as String?;

      if (newAccessToken != null) {
        await SecureStorageService.instance.saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken ?? refreshToken,
        );
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
