import 'package:flutter/material.dart';
import 'package:dt_digital_studio/l10n/app_localizations.dart';

/// Thin extension helpers for common Dart types.
extension StringExtension on String {
  bool get isBlank => trim().isEmpty;
  bool get isNotBlank => !isBlank;
  String get capitalised => isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
  String? get nullIfBlank => isBlank ? null : this;
  bool get isValidEmail => RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(this);
}

extension NullableStringExtension on String? {
  bool get isNullOrBlank => this == null || this!.trim().isEmpty;
  String get orEmpty => this ?? '';
}

extension IntExtension on int {
  /// Clamp to a range inclusively.
  int clampTo(int min, int max) => clamp(min, max).toInt();
}

extension DoubleExtension on double {
  double clampTo(double min, double max) => clamp(min, max).toDouble();
}

extension IterableExtension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
  T? get lastOrNull => isEmpty ? null : last;
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

extension ColorExtension on Color {
  /// Returns the hex string representation without leading #.
  String toHex({bool leadingHash = true}) {
    final hexColor = toARGB32().toRadixString(16).substring(2).toUpperCase();
    return leadingHash ? '#$hexColor' : hexColor;
  }
}

extension AppLocalizationsExtension on BuildContext {
  /// Helper to access localizations: context.l10n.appName
  AppLocalizations get l10n => AppLocalizations.of(this);
}
