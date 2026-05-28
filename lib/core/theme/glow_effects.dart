import 'package:flutter/material.dart';
import 'color_palette.dart';

/// Slim glow + shadow utilities for FocusShield premium minimal design.
///
/// Glow is reserved for: focus ring, active nav dot, primary CTA.
/// Everything else uses flat surfaces and subtle shadows.
class GlowEffects {
  GlowEffects._();

  // ─── Box Shadows ──────────────────────────────────────────────

  /// Subtle directional shadow — for cards, containers.
  /// NOT neon. Dark elevation only.
  static List<BoxShadow> cardShadow({double blur = 8, double opacity = 0.12}) => [
    BoxShadow(
      color: Colors.black.withOpacity(opacity),
      blurRadius: blur,
      spreadRadius: 0,
      offset: const Offset(0, 2),
    ),
  ];

  /// Very subtle neon tint glow — used SPARINGLY.
  /// Max opacity: 0.08. Max blur: 12.
  static List<BoxShadow> neonBoxShadow(
    Color color, {
    double blur = 12,
    double spread = 0,
    double opacity = 0.08,
    Offset offset = Offset.zero,
  }) => [
    BoxShadow(
      color: color.withOpacity(opacity),
      blurRadius: blur,
      spreadRadius: spread,
      offset: offset,
    ),
  ];

  // ─── Decorations ──────────────────────────────────────────────

  /// Flat matte card decoration — default for all standard cards.
  /// No blur, no glow. Clean surface.
  static BoxDecoration mattCardDecoration({
    double borderRadius = 20,
    List<BoxShadow>? shadow,
  }) {
    return BoxDecoration(
      color: CyberColors.surface,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: CyberColors.borderCard,
        width: 1,
      ),
      boxShadow: shadow ?? cardShadow(),
    );
  }

  /// Glassmorphism decoration — use ONLY for:
  /// bottom nav, modal bottom sheets, AI overlay.
  static BoxDecoration glassDecoration({
    Color? borderColor,
    double borderOpacity = 0.08,
    double backgroundOpacity = 0.08,
    double borderRadius = 24,
    List<BoxShadow>? shadow,
  }) {
    final effectiveBorderColor = borderColor ?? Colors.white;
    return BoxDecoration(
      color: CyberColors.surfaceContainer.withOpacity(0.7),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: effectiveBorderColor.withOpacity(borderOpacity),
        width: 1,
      ),
      boxShadow: shadow,
    );
  }

  // ─── Score-Based Glow (Focus Ring Only) ───────────────────────

  /// Returns a glow color based on focus score (0–100).
  static Color scoreGlowColor(int score) {
    if (score >= 80) return CyberColors.scoreExcellent;
    if (score >= 60) return CyberColors.scoreHealthy;
    if (score >= 40) return CyberColors.scoreModerate;
    if (score >= 20) return CyberColors.scoreAtRisk;
    return CyberColors.scoreCritical;
  }

  /// Score-based ambient glow — used ONLY on the progress ring.
  /// Tuned down: blurRadius 16, opacity 0.10.
  static List<BoxShadow> scoreGlow(int score, {double intensity = 1.0}) {
    return [
      BoxShadow(
        color: scoreGlowColor(score).withOpacity(0.10 * intensity),
        blurRadius: 16,
        spreadRadius: 2,
      ),
    ];
  }
}
