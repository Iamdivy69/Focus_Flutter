import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'color_palette.dart';
import 'typography.dart';

/// Legacy alias — existing screens import [AppColors] from this file.
class AppColors {
  AppColors._();

  static const Color primary = CyberColors.neonGreen;
  static const Color primaryLight = CyberColors.neonGreenDim;
  static const Color primaryDark = CyberColors.neonGreenContainer;

  static const Color surfaceDark = CyberColors.background;
  static const Color surfaceCard = CyberColors.surface;
  static const Color surfaceElevated = CyberColors.surfaceContainerHigh;

  static const Color onPrimary = CyberColors.onNeonGreen;
  static const Color onSurface = CyberColors.onSurface;
  static const Color onSurfaceMuted = CyberColors.onSurfaceMuted;

  // Focus Score band colours
  static const Color scoreExcellent = CyberColors.scoreExcellent;
  static const Color scoreHealthy = CyberColors.scoreHealthy;
  static const Color scoreModerate = CyberColors.scoreModerate;
  static const Color scoreAtRisk = CyberColors.scoreAtRisk;
  static const Color scoreCritical = CyberColors.scoreCritical;

  static const Color accent = CyberColors.electricBlue;
  static const Color error = CyberColors.error;
  static const Color success = CyberColors.success;
  static const Color warning = CyberColors.warning;
}

/// FocusShield Premium Minimal Theme.
///
/// Dark, calm, trustworthy. Inspired by Linear, Headspace, Stripe.
/// No neon, no rainbow gradients, no glowing cards.
class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,

      // Primary — Calm Green
      primary: CyberColors.neonGreen,
      onPrimary: CyberColors.onNeonGreen,
      primaryContainer: CyberColors.neonGreenContainer,
      onPrimaryContainer: CyberColors.neonGreen,

      // Secondary — Calm Blue
      secondary: CyberColors.electricBlue,
      onSecondary: CyberColors.onElectricBlue,
      secondaryContainer: CyberColors.electricBlueContainer,
      onSecondaryContainer: CyberColors.onSurface,

      // Tertiary — also Blue (no cyan)
      tertiary: CyberColors.electricBlueBright,
      onTertiary: CyberColors.onElectricBlue,
      tertiaryContainer: CyberColors.electricBlueContainer,
      onTertiaryContainer: CyberColors.onSurface,

      // Error
      error: CyberColors.error,
      onError: CyberColors.onError,
      errorContainer: CyberColors.errorContainer,
      onErrorContainer: Color(0xFFFFD2C8),

      // Surfaces
      surface: CyberColors.background,
      onSurface: CyberColors.onSurface,
      surfaceContainerHighest: CyberColors.surfaceContainerHighest,
      surfaceContainerHigh: CyberColors.surfaceContainerHigh,
      surfaceContainer: CyberColors.surfaceContainer,
      surfaceContainerLow: CyberColors.surfaceContainerLow,
      surfaceContainerLowest: CyberColors.surfaceContainerLowest,
      surfaceBright: CyberColors.surfaceBright,
      surfaceDim: CyberColors.background,

      // Outline
      outline: CyberColors.outline,
      outlineVariant: CyberColors.outlineVariant,

      // Inverse
      inverseSurface: CyberColors.inverseSurface,
      onInverseSurface: CyberColors.inverseOnSurface,
      inversePrimary: CyberColors.inversePrimary,

      // Surface tint — neutral, no green cast on surfaces
      surfaceTint: Colors.transparent,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: CyberColors.background,
      cardColor: CyberColors.surface,
      dividerColor: CyberColors.borderSubtle,
      canvasColor: CyberColors.background,

      // ─── AppBar ─────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: CyberColors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: CyberTypography.titleLarge.copyWith(
          color: CyberColors.onSurface,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(
          color: CyberColors.onSurface,
          size: 22,
        ),
      ),

      // ─── Cards ──────────────────────────────────────────────
      // Flat matte — no border color tint, no elevation glow
      cardTheme: CardTheme(
        color: CyberColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            color: CyberColors.borderCard,
            width: 1,
          ),
        ),
        margin: EdgeInsets.zero,
      ),

      // ─── Elevated Buttons ────────────────────────────────────
      // Solid green, white text. No gradient, no glow.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CyberColors.neonGreen,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: CyberTypography.labelLarge,
        ),
      ),

      // ─── Outlined Buttons ───────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: CyberColors.onSurface,
          side: const BorderSide(color: CyberColors.borderCard),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: CyberTypography.labelLarge,
        ),
      ),

      // ─── Text Buttons ───────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: CyberColors.electricBlue,
          textStyle: CyberTypography.labelLarge,
        ),
      ),

      // ─── Input Fields ───────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: CyberColors.surfaceContainerHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: CyberColors.borderCard),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: CyberColors.borderCard),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: CyberColors.electricBlue,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: CyberColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: CyberColors.error, width: 1.5),
        ),
        labelStyle: CyberTypography.bodyMedium.copyWith(
          color: CyberColors.onSurfaceVariant,
        ),
        hintStyle: CyberTypography.bodyMedium.copyWith(
          color: CyberColors.onSurfaceMuted,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
      ),

      // ─── Chips ──────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: CyberColors.surfaceContainerHigh,
        labelStyle: CyberTypography.labelMedium.copyWith(
          color: CyberColors.onSurface,
        ),
        side: const BorderSide(color: CyberColors.borderCard),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),

      // ─── Switch ─────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return CyberColors.onSurfaceMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return CyberColors.neonGreen;
          }
          return CyberColors.surfaceContainerHighest;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          return Colors.transparent;
        }),
      ),

      // ─── Bottom Navigation ──────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: CyberColors.surface.withOpacity(0.9),
        selectedItemColor: CyberColors.neonGreen,
        unselectedItemColor: CyberColors.onSurfaceMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: CyberTypography.labelSmall.copyWith(
          color: CyberColors.neonGreen,
        ),
        unselectedLabelStyle: CyberTypography.labelSmall.copyWith(
          color: CyberColors.onSurfaceMuted,
        ),
      ),

      // ─── Dialog ─────────────────────────────────────────────
      dialogTheme: DialogTheme(
        backgroundColor: CyberColors.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        titleTextStyle: CyberTypography.headlineSmall.copyWith(
          color: CyberColors.onSurface,
        ),
      ),

      // ─── Snackbar ───────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: CyberColors.surfaceContainerHighest,
        contentTextStyle: CyberTypography.bodyMedium.copyWith(
          color: CyberColors.onSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // ─── Progress Indicators ────────────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: CyberColors.neonGreen,
        linearTrackColor: CyberColors.surfaceContainerHighest,
        circularTrackColor: CyberColors.surfaceContainerHighest,
      ),

      // ─── Divider ────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: CyberColors.borderSubtle,
        thickness: 1,
      ),

      // ─── Icon ───────────────────────────────────────────────
      iconTheme: const IconThemeData(
        color: CyberColors.onSurface,
        size: 24,
      ),

      // ─── Typography ─────────────────────────────────────────
      textTheme: CyberTypography.textTheme.apply(
        bodyColor: CyberColors.onSurface,
        displayColor: CyberColors.onSurface,
      ),
    );
  }
}
