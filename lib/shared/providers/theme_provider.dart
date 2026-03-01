import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:dt_digital_studio/core/storage/app_preferences.dart';

/// ThemeMode provider — watches and updates the user's preferred theme.
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final idx = AppPreferences.instance.themeMode;
    return ThemeMode.values[idx];
  }

  Future<void> setTheme(ThemeMode mode) async {
    await AppPreferences.instance.setThemeMode(mode.index);
    state = mode;
  }
}
