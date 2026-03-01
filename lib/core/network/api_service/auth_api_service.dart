import 'package:dio/dio.dart';
import 'package:dt_digital_studio/core/network/api_paths.dart';
import 'package:dt_digital_studio/core/network/dio_client.dart';
import 'package:dt_digital_studio/models/user_model.dart';

/// Direct API service for authentication endpoints.
///
/// Talks to the network only — no caching, token storage, or error wrapping.
/// Use [AuthApiServiceProvider] for higher-level orchestration.
class AuthApiService {
  AuthApiService({Dio? dio}) : _dio = dio ?? DioClient.instance;

  final Dio _dio;

  /// POST [AuthPaths.login] — returns user + tokens on success.
  Future<({UserModel user, String accessToken, String refreshToken})> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      AuthPaths.login,
      data: {'email': email, 'password': password},
    );

    final data = response.data!;
    return (
      user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
      accessToken: data['access_token'] as String,
      refreshToken: data['refresh_token'] as String,
    );
  }

  /// POST [AuthPaths.logout]
  Future<void> logout() => _dio.post<void>(AuthPaths.logout);

  /// GET [AuthPaths.me] — returns current authenticated user.
  Future<UserModel> getCurrentUser() async {
    final response =
        await _dio.get<Map<String, dynamic>>(AuthPaths.me);
    return UserModel.fromJson(response.data!);
  }
}
