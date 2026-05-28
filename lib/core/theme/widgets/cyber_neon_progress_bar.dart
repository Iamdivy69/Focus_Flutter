import 'package:flutter/material.dart';
import '../color_palette.dart';

/// Clean horizontal progress bar — flat fill, no glow.
class CyberNeonProgressBar extends StatelessWidget {
  final double value;
  final double maxValue;
  final double height;
  final List<Color>? gradientColors;
  final Duration animationDuration;

  const CyberNeonProgressBar({
    super.key,
    required this.value,
    this.maxValue = 100,
    this.height = 5,
    this.gradientColors,
    this.animationDuration = const Duration(milliseconds: 700),
  });

  @override
  Widget build(BuildContext context) {
    final progress = (value / maxValue).clamp(0.0, 1.0);
    // Single flat color — no neon gradient by default
    final fillColor = gradientColors?.first ?? CyberColors.neonGreen;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress),
      duration: animationDuration,
      curve: Curves.easeOutCubic,
      builder: (context, animatedProgress, _) {
        return Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: Stack(
            children: [
              FractionallySizedBox(
                widthFactor: animatedProgress,
                child: Container(
                  decoration: BoxDecoration(
                    // If custom gradientColors provided use them, else flat color
                    gradient: gradientColors != null && gradientColors!.length >= 2
                        ? LinearGradient(
                            colors: gradientColors!,
                          )
                        : null,
                    color: gradientColors == null ? fillColor : null,
                    borderRadius: BorderRadius.circular(height / 2),
                    // No glow shadow
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
