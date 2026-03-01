/// Global application constants.
abstract final class AppConstants {
  // Connection
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Pagination
  static const int defaultPageSize = 20;
  static const int firstPage = 1;

  // Storage keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyThemeMode = 'theme_mode';
  static const String keyOnboarded = 'onboarded';
  static const String keyUserBox = 'user_box';

  // Hive box names
  static const String hiveUserBox = 'user_box';
  static const String hiveSettingsBox = 'settings_box';
}
