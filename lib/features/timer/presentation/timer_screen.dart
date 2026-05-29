import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/theme/widgets/cyber_progress_ring.dart';

/// Active Focus Timer Screen.
class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberColors.background,
      body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // Timer ring
                CyberProgressRing(
                  value: 72,
                  maxValue: 100,
                  size: 220,
                  strokeWidth: 12,
                  center: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '18:32',
                        style: CyberTypography.heroScore.copyWith(
                          color: Colors.white,
                          fontSize: 52,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'REMAINING',
                        style: CyberTypography.scoreLabel.copyWith(
                          color: CyberColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                Text(
                  'Deep Focus Mode',
                  style: CyberTypography.titleMedium.copyWith(
                    color: CyberColors.neonGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Stay focused — you\'re doing great! 💪',
                  style: CyberTypography.bodyMedium.copyWith(
                    color: CyberColors.onSurfaceVariant,
                  ),
                ),

                const Spacer(flex: 2),

                // Control buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Stop button
                    _ControlButton(
                      icon: Icons.stop_rounded,
                      color: CyberColors.scoreCritical,
                      size: 56,
                      // Stop = end session, go to session-completed in this branch
                      onTap: () => context.go(
                        AppRoutes.sessionCompleted,
                        extra: {
                          'xpEarned': 120,
                          'durationMinutes': 25,
                          'streakUpdated': true,
                        },
                      ),
                    ),
                    const SizedBox(width: 32),
                    // Pause button
                    _ControlButton(
                      icon: Icons.pause_rounded,
                      color: CyberColors.neonGreen,
                      size: 72,
                      onTap: () {},
                    ),
                    const SizedBox(width: 32),
                    // Skip button
                    _ControlButton(
                      icon: Icons.skip_next_rounded,
                      color: CyberColors.electricBlueBright,
                      size: 56,
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.color,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.12),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 20,
            ),
          ],
        ),
        child: Icon(icon, color: color, size: size * 0.45),
      ),
    );
  }
}
