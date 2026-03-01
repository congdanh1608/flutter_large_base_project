import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:dt_digital_studio/core/config/app_constants.dart';

/// Initialises Hive CE and opens all named boxes.
///
/// Call [HiveService.init] once during app bootstrap, before any box is used.
class HiveService {
  HiveService._();

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    await Hive.initFlutter();
    // Register type adapters here when you add Hive models, e.g.:
    // Hive.registerAdapter(UserModelAdapter());
    await Future.wait([
      Hive.openBox<dynamic>(AppConstants.hiveUserBox),
      Hive.openBox<dynamic>(AppConstants.hiveSettingsBox),
    ]);
    _initialized = true;
  }

  /// Generic accessor — prefer typed box wrappers in feature datasources.
  static Box<dynamic> box(String name) => Hive.box<dynamic>(name);

  static Box<dynamic> get userBox => box(AppConstants.hiveUserBox);
  static Box<dynamic> get settingsBox => box(AppConstants.hiveSettingsBox);

  static Future<void> closeAll() => Hive.close();
}
