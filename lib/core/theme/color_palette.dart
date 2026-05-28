import 'package:flutter/material.dart';

/// FocusShield Premium Minimal color palette.
///
/// Calm, trustworthy dark theme inspired by Linear, Headspace, and Stripe.
/// Two-accent identity: green (#22C55E) + blue (#3B82F6).
class CyberColors {
  CyberColors._();

  // ─── Backgrounds ──────────────────────────────────────────────
  static const Color background = Color(0xFF070B14);
  static const Color backgroundDeep = Color(0xFF050810);
  static const Color backgroundNavy = Color(0xFF070B14);
  static const Color backgroundMid = Color(0xFF0B1120);

  // ─── Surfaces ─────────────────────────────────────────────────
  static const Color surface = Color(0xFF111827);
  static const Color surfaceBright = Color(0xFF1E293B);
  static const Color surfaceContainer = Color(0xFF111827);
  static const Color surfaceContainerHigh = Color(0xFF1E293B);
  static const Color surfaceContainerHighest = Color(0xFF263045);
  static const Color surfaceContainerLow = Color(0xFF0F172A);
  static const Color surfaceContainerLowest = Color(0xFF070B14);
  static const Color surfaceVariant = Color(0xFF1E293B);

  // ─── Primary — Calm Green ─────────────────────────────────────
  /// Use for: focus ring, active nav, primary CTA, success states
  static const Color neonGreen = Color(0xFF22C55E);
  static const Color neonGreenDim = Color(0xFF16A34A);
  static const Color neonGreenContainer = Color(0xFF14532D);
  static const Color onNeonGreen = Colors.white;

  // ─── Secondary — Calm Blue ────────────────────────────────────
  /// Use for: focused inputs, links, secondary accents
  static const Color electricBlue = Color(0xFF3B82F6);
  static const Color electricBlueBright = Color(0xFF60A5FA);
  static const Color electricBlueContainer = Color(0xFF1E3A8A);
  static const Color onElectricBlue = Colors.white;

  // ─── Tertiary — maps to Blue (cyan removed) ───────────────────
  static const Color cyan = Color(0xFF3B82F6);
  static const Color cyanBright = Color(0xFF60A5FA);
  static const Color cyanContainer = Color(0xFF1E3A8A);
  static const Color onCyan = Colors.white;

  // ─── On-Surface Text ──────────────────────────────────────────
  static const Color onSurface = Color(0xFFFFFFFF);
  static const Color onSurfaceVariant = Color(0xFFCBD5E1);
  static const Color onSurfaceMuted = Color(0xFF94A3B8);

  // ─── Outline / Border ─────────────────────────────────────────
  static const Color outline = Color(0xFF475569);
  static const Color outlineVariant = Color(0xFF334155);
  static const Color borderSubtle = Color(0xFF1E293B);
  /// Standard card border — very subtle white tint
  static const Color borderCard = Color(0x0FFFFFFF); // white at ~6%

  // ─── Semantic / Score Band Colors ─────────────────────────────
  static const Color scoreExcellent = Color(0xFF22C55E);
  static const Color scoreHealthy = Color(0xFF14B8A6);
  static const Color scoreModerate = Color(0xFFF59E0B);
  static const Color scoreAtRisk = Color(0xFFF97316);
  static const Color scoreCritical = Color(0xFFEF4444);

  static const Color error = Color(0xFFEF4444);
  static const Color errorContainer = Color(0xFF7F1D1D);
  static const Color onError = Colors.white;

  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);

  // ─── Inverse ──────────────────────────────────────────────────
  static const Color inverseSurface = Color(0xFFF1F5F9);
  static const Color inversePrimary = Color(0xFF16A34A);
  static const Color inverseOnSurface = Color(0xFF1E293B);

  // ─── Gradients ────────────────────────────────────────────────

  /// Matte background — very subtle, dark only. NOT glowing.
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundDeep, background],
    stops: [0.0, 1.0],
  );

  /// Primary CTA button — solid green. Subtle, not neon.
  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
  );

  /// Focus score ring gradient — the ONE allowed visual gradient.
  static LinearGradient scoreRingGradient(Color ringColor) => LinearGradient(
    colors: [ringColor, electricBlue.withOpacity(0.7)],
  );

  /// Score-based ring color.
  static Color scoreGlowColor(double normalizedScore) {
    if (normalizedScore >= 0.8) return scoreExcellent;
    if (normalizedScore >= 0.6) return scoreHealthy;
    if (normalizedScore >= 0.4) return scoreModerate;
    if (normalizedScore >= 0.2) return scoreAtRisk;
    return scoreCritical;
  }

  // ─── Box Shadow Presets ───────────────────────────────────────

  /// Subtle elevation shadow for cards — no neon tint.
  static List<BoxShadow> subtleShadow({double blur = 8, double opacity = 0.12}) => [
    BoxShadow(
      color: Colors.black.withOpacity(opacity),
      blurRadius: blur,
      spreadRadius: 0,
      offset: const Offset(0, 2),
    ),
  ];

  /// Score ring ambient glow — used ONLY on the focus score ring.
  static List<BoxShadow> scoreRingGlow(Color color, {double intensity = 1.0}) => [
    BoxShadow(
      color: color.withOpacity(0.12 * intensity),
      blurRadius: 24,
      spreadRadius: 4,
    ),
  ];

  /// Primary CTA button glow — extremely subtle.
  static List<BoxShadow> ctaGlow({double opacity = 0.15}) => [
    BoxShadow(
      color: neonGreen.withOpacity(opacity),
      blurRadius: 12,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
  ];

  // ─── Legacy aliases (kept for backwards compat) ───────────────
  static List<BoxShadow> neonGreenGlow({double blur = 12, double spread = 0, double opacity = 0.08}) => [
    BoxShadow(
      color: neonGreen.withOpacity(opacity),
      blurRadius: blur,
      spreadRadius: spread,
    ),
  ];

  static List<BoxShadow> electricBlueGlow({double blur = 12, double spread = 0, double opacity = 0.08}) => [
    BoxShadow(
      color: electricBlue.withOpacity(opacity),
      blurRadius: blur,
      spreadRadius: spread,
    ),
  ];

  // ignore: non_constant_identifier_names
  static List<BoxShadow> cyanGlow({double blur = 12, double spread = 0, double opacity = 0.08}) => [
    BoxShadow(
      color: electricBlue.withOpacity(opacity),
      blurRadius: blur,
      spreadRadius: spread,
    ),
  ];
}
