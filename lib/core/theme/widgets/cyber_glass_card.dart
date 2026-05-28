import 'dart:ui';
import 'package:flutter/material.dart';
import '../color_palette.dart';

/// Premium flat card with clean matte surface and subtle border.
///
/// Default mode: flat dark surface — no blur, no glow.
/// Set [blurAmount] > 0 for glassmorphism (bottom nav, modals only).
///
/// Usage:
/// ```dart
/// // Standard flat card (default)
/// CyberGlassCard(child: Text('Hello'))
///
/// // Glass (bottom sheet / nav only)
/// CyberGlassCard(blurAmount: 10, backgroundOpacity: 0.08, child: ...)
/// ```
class CyberGlassCard extends StatelessWidget {
  final Widget child;
  final Color? borderColor;
  final double borderOpacity;
  final double backgroundOpacity;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final List<BoxShadow>? glow;
  final double blurAmount;

  const CyberGlassCard({
    super.key,
    required this.child,
    this.borderColor,
    this.borderOpacity = 0.06,
    this.backgroundOpacity = 1.0, // flat matte by default
    this.borderRadius = 20,
    this.padding = const EdgeInsets.all(20),
    this.glow,
    this.blurAmount = 0, // no blur by default — glass only when needed
  });

  @override
  Widget build(BuildContext context) {
    // Flat border color: if caller doesn't specify, use the subtle card border
    final effectiveBorderColor = borderColor ?? Colors.white;
    final effectiveBgColor = CyberColors.surface.withOpacity(
      backgroundOpacity.clamp(0.0, 1.0),
    );

    final decoration = BoxDecoration(
      color: effectiveBgColor,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: effectiveBorderColor.withOpacity(borderOpacity),
        width: 1,
      ),
      boxShadow: glow,
    );

    if (blurAmount <= 0) {
      // Flat matte card — no backdrop filter cost
      return Container(
        padding: padding,
        decoration: decoration,
        child: child,
      );
    }

    // Glassmorphism — use only for nav/modals
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: glow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: CyberColors.surfaceContainer.withOpacity(
                (backgroundOpacity * 0.7).clamp(0.0, 1.0),
              ),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: effectiveBorderColor.withOpacity(borderOpacity),
                width: 1,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
