import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App-wide theme tokens and [ThemeData] factories.
/// Uses Google Fonts — Poppins as the primary typeface.
abstract final class AppTheme {
  // ---- Color palette ---------------------------------------------------------

  static const _primarySeed = Color(0xFF4F6AF5); // Indigo-blue
  static const _secondarySeed = Color(0xFF00C6AE); // Teal-mint

  // ---- Light theme -----------------------------------------------------------

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primarySeed,
          secondary: _secondarySeed,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          _buildBaseTextTheme(Brightness.light),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FD),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1A1D2E),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: const Color(0xFF1A1D2E),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _primarySeed,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF1F3F8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _primarySeed, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE53935), width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE53935), width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFEDF0F7)),
          ),
        ),
      );

  // ---- Dark theme ------------------------------------------------------------

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primarySeed,
          secondary: _secondarySeed,
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          _buildBaseTextTheme(Brightness.dark),
        ),
        scaffoldBackgroundColor: const Color(0xFF0F1120),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF181B2E),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _primarySeed,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1E2235),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _primarySeed, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFEF5350), width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFEF5350), width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF181B2E),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF252840)),
          ),
        ),
      );

  // ---- Text theme ------------------------------------------------------------

  static TextTheme _buildBaseTextTheme(Brightness brightness) {
    final baseColor =
        brightness == Brightness.light ? const Color(0xFF1A1D2E) : Colors.white;
    final subtleColor = brightness == Brightness.light
        ? const Color(0xFF6B7280)
        : const Color(0xFF9CA3AF);
    return TextTheme(
      displayLarge: TextStyle(
          fontWeight: FontWeight.w700, fontSize: 32, color: baseColor),
      displayMedium: TextStyle(
          fontWeight: FontWeight.w700, fontSize: 26, color: baseColor),
      headlineMedium: TextStyle(
          fontWeight: FontWeight.w600, fontSize: 22, color: baseColor),
      titleLarge: TextStyle(
          fontWeight: FontWeight.w600, fontSize: 18, color: baseColor),
      titleMedium: TextStyle(
          fontWeight: FontWeight.w500, fontSize: 16, color: baseColor),
      bodyLarge: TextStyle(
          fontWeight: FontWeight.w400, fontSize: 16, color: baseColor),
      bodyMedium: TextStyle(
          fontWeight: FontWeight.w400, fontSize: 14, color: baseColor),
      bodySmall: TextStyle(
          fontWeight: FontWeight.w400, fontSize: 12, color: subtleColor),
      labelLarge: TextStyle(
          fontWeight: FontWeight.w600, fontSize: 14, color: baseColor),
    );
  }
}
