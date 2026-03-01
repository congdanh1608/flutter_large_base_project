import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dt_digital_studio/app.dart';
import 'package:dt_digital_studio/core/storage/app_preferences.dart';
import 'package:dt_digital_studio/core/storage/hive_service.dart';
import 'package:dt_digital_studio/core/utils/app_logger.dart';
import 'package:dt_digital_studio/core/config/app_flavor.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialise local storage
  await Future.wait([
    AppPreferences.instance.init(),
    HiveService.init(),
  ]);

  AppLogger.info('🚀 Starting ${FlavorConfig.appName} [${FlavorConfig.flavor.name}]');

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
