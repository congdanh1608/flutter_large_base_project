/// Centralised API path constants.
///
/// Usage:
///   _dio.post(AuthPaths.login, data: {...});
abstract final class AuthPaths {
  static const login = '/auth/login';
  static const logout = '/auth/logout';
  static const me = '/auth/me';
}
