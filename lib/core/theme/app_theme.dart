import 'package:flutter/material.dart';

/// FocusShield brand colours
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF1A56DB);
  static const Color primaryLight = Color(0xFF4D7FE8);
  static const Color primaryDark = Color(0xFF0D3BA8);

  static const Color surfaceDark = Color(0xFF0A1628);
  static const Color surfaceCard = Color(0xFF112240);
  static const Color surfaceElevated = Color(0xFF1A2F4A);

  static const Color onPrimary = Colors.white;
  static const Color onSurface = Color(0xFFE2E8F0);
  static const Color onSurfaceMuted = Color(0xFF94A3B8);

  // Focus Score band colours
  static const Color scoreExcellent = Color(0xFF22C55E); // green
  static const Color scoreHealthy = Color(0xFF14B8A6);   // teal
  static const Color scoreModerate = Color(0xFFF59E0B);  // amber
  static const Color scoreAtRisk = Color(0xFFF97316);    // orange
  static const Color scoreCritical = Color(0xFFEF4444);  // red

  static const Color accent = Color(0xFF38BDF8);
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
}

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryDark,
      onPrimaryContainer: AppColors.onPrimary,
      secondary: AppColors.accent,
      onSecondary: AppColors.surfaceDark,
      secondaryContainer: Color(0xFF1E3A5F),
      onSecondaryContainer: AppColors.onSurface,
      tertiary: AppColors.scoreHealthy,
      onTertiary: AppColors.surfaceDark,
      error: AppColors.error,
      onError: Colors.white,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.onSurface,
      surfaceContainerHighest: AppColors.surfaceElevated,
      outline: Color(0xFF334155),
      outlineVariant: Color(0xFF1E293B),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.surfaceDark,
      cardColor: AppColors.surfaceCard,
      dividerColor: const Color(0xFF1E293B),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF1E293B)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceElevated,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle: const TextStyle(color: AppColors.onSurfaceMuted),
        hintStyle: const TextStyle(color: AppColors.onSurfaceMuted),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceElevated,
        labelStyle: const TextStyle(color: AppColors.onSurface),
        side: const BorderSide(color: Color(0xFF334155)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceCard,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.onSurfaceMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.onSurface,
          fontSize: 57,
          fontWeight: FontWeight.w400,
        ),
        displayMedium: TextStyle(
          color: AppColors.onSurface,
          fontSize: 45,
          fontWeight: FontWeight.w400,
        ),
        headlineLarge: TextStyle(
          color: AppColors.onSurface,
          fontSize: 32,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: TextStyle(
          color: AppColors.onSurface,
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: AppColors.onSurface,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: AppColors.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: AppColors.onSurface,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: AppColors.onSurface,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: AppColors.onSurface,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: AppColors.onSurface,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: AppColors.onSurfaceMuted,
          fontSize: 12,
        ),
        labelLarge: TextStyle(
          color: AppColors.onSurface,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
