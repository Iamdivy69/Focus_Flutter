import 'package:flutter/material.dart';
import '../color_palette.dart';

/// Clean icon container for feature illustrations.
///
/// Flat circle with subtle color fill — no glow, no neon shadows.
/// Used for onboarding pages, permission tiles, and feature badges.
class NeonIconBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final double iconSize;

  const NeonIconBadge({
    super.key,
    required this.icon,
    this.color = CyberColors.neonGreen,
    this.size = 80,
    this.iconSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.10),
        border: Border.all(
          color: color.withOpacity(0.18),
          width: 1.5,
        ),
        // No glow shadows — clean flat icon container
      ),
      child: Icon(
        icon,
        color: color,
        size: iconSize,
      ),
    );
  }
}
