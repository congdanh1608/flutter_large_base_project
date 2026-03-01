import 'package:shared_preferences/shared_preferences.dart';
import 'package:dt_digital_studio/core/config/app_constants.dart';

/// Typed wrapper around [SharedPreferences] for non-sensitive app state.
class AppPreferences {
  AppPreferences._();

  static AppPreferences? _instance;
  static AppPreferences get instance {
    _instance ??= AppPreferences._();
    return _instance!;
  }

  late SharedPreferences _prefs;

  /// Must be called once during app bootstrap (before runApp).
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ---- Theme -----------------------------------------------------------------

  /// 0 = system, 1 = light, 2 = dark
  int get themeMode => _prefs.getInt(AppConstants.keyThemeMode) ?? 0;
  Future<void> setThemeMode(int mode) => _prefs.setInt(AppConstants.keyThemeMode, mode);

  // ---- Onboarding ------------------------------------------------------------

  bool get isOnboarded => _prefs.getBool(AppConstants.keyOnboarded) ?? false;
  Future<void> setOnboarded() => _prefs.setBool(AppConstants.keyOnboarded, true);

  // ---- Reset -----------------------------------------------------------------

  Future<void> clear() => _prefs.clear();
}
