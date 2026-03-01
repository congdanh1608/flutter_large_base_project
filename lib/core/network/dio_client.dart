import 'package:dio/dio.dart';
import 'package:dt_digital_studio/core/config/app_constants.dart';
import 'package:dt_digital_studio/core/config/app_flavor.dart';
import 'package:dt_digital_studio/core/network/interceptors/auth_interceptor.dart';
import 'package:dt_digital_studio/core/network/interceptors/error_interceptor.dart';
import 'package:dt_digital_studio/core/network/interceptors/logging_interceptor.dart';

/// Singleton Dio HTTP client factory.
///
/// Obtain via `DioClient.instance`. All interceptors are pre-configured.
class DioClient {
  DioClient._();

  static Dio? _instance;

  static Dio get instance {
    _instance ??= _createDio();
    return _instance!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: FlavorConfig.baseUrl,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        sendTimeout: AppConstants.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (FlavorConfig.enableLogging) {
      dio.interceptors.add(LoggingInterceptor());
    }
    dio.interceptors.add(AuthInterceptor(dio));
    dio.interceptors.add(ErrorInterceptor());

    return dio;
  }

  /// Invalidate the current instance (e.g., after logout to reset headers).
  static void reset() => _instance = null;
}
