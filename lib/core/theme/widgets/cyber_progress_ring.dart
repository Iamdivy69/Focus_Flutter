import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../color_palette.dart';

/// Animated circular progress ring — the visual hero of FocusShield.
///
/// This widget retains its subtle score-based glow as the ONE intentional
/// glow effect in the app. All other cards use flat surfaces.
class CyberProgressRing extends StatelessWidget {
  final double value;
  final double maxValue;
  final double size;
  final double strokeWidth;
  final Widget? center;
  final Color? glowColor;
  final Duration animationDuration;

  const CyberProgressRing({
    super.key,
    required this.value,
    this.maxValue = 100,
    this.size = 200,
    this.strokeWidth = 10,
    this.center,
    this.glowColor,
    this.animationDuration = const Duration(milliseconds: 1200),
  });

  @override
  Widget build(BuildContext context) {
    final normalizedValue = (value / maxValue).clamp(0.0, 1.0);
    final effectiveGlowColor = glowColor ??
        CyberColors.scoreGlowColor(normalizedValue);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: normalizedValue),
      duration: animationDuration,
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, child) {
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Subtle ambient glow — tuned for premium feel
              Container(
                width: size * 0.85,
                height: size * 0.85,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: effectiveGlowColor.withOpacity(
                        0.08 * animatedValue,
                      ),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              // Background track
              CustomPaint(
                size: Size(size, size),
                painter: _RingPainter(
                  progress: 1.0,
                  strokeWidth: strokeWidth,
                  color: Colors.white.withOpacity(0.05),
                  isTrack: true,
                ),
              ),
              // Progress arc — gradient is allowed here (the visual hero)
              CustomPaint(
                size: Size(size, size),
                painter: _RingPainter(
                  progress: animatedValue,
                  strokeWidth: strokeWidth,
                  color: effectiveGlowColor,
                  gradient: LinearGradient(
                    colors: [
                      effectiveGlowColor,
                      CyberColors.electricBlue.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
              // Center content
              if (child != null) child,
            ],
          ),
        );
      },
      child: center,
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color color;
  final Gradient? gradient;
  final bool isTrack;

  _RingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.color,
    this.gradient,
    this.isTrack = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = isTrack ? StrokeCap.butt : StrokeCap.round;

    if (gradient != null && !isTrack) {
      paint.shader = gradient!.createShader(rect);
    } else {
      paint.color = color;
    }

    final sweepAngle = 2 * math.pi * progress;
    const startAngle = -math.pi / 2; // Start from top

    if (isTrack) {
      canvas.drawCircle(center, radius, paint);
    } else {
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
