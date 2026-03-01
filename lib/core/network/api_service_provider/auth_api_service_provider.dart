import 'package:dt_digital_studio/core/error/error_mapper.dart';
import 'package:dt_digital_studio/core/network/api_result.dart';
import 'package:dt_digital_studio/core/network/api_service/auth_api_service.dart';
import 'package:dt_digital_studio/core/storage/secure_storage_service.dart';
import 'package:dt_digital_studio/models/user_model.dart';

/// High-level auth orchestrator: wraps [AuthApiService] with token storage
/// and error mapping. Returns [ApiResult] — no exceptions leak upward.
class AuthApiServiceProvider {
  AuthApiServiceProvider({AuthApiService? apiService})
      : _apiService = apiService ?? AuthApiService();

  final AuthApiService _apiService;

  /// Sign in with email + password. Saves tokens on success.
  Future<ApiResult<UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result =
          await _apiService.login(email: email, password: password);
      await SecureStorageService.instance.saveTokens(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );
      return ApiSuccess(result.user);
    } catch (e) {
      return ApiFailure(mapExceptionToFailure(e));
    }
  }

  /// Sign out and clear local tokens (clears tokens even if remote call fails).
  Future<ApiResult<void>> logout() async {
    try {
      await _apiService.logout();
    } catch (_) {
      // ignore remote logout failure — always clear local tokens
    } finally {
      await SecureStorageService.instance.clearTokens();
    }
    return const ApiSuccess(null);
  }

  /// Returns the currently authenticated user, or null if not authenticated.
  Future<ApiResult<UserModel?>> getCurrentUser() async {
    try {
      final user = await _apiService.getCurrentUser();
      return ApiSuccess(user);
    } catch (e) {
      return ApiFailure(mapExceptionToFailure(e));
    }
  }
}
