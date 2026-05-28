import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/theme/widgets/animated_gradient_background.dart';
import '../../../core/theme/widgets/cyber_gradient_button.dart';
import '../../../core/theme/widgets/neon_icon_badge.dart';

/// Session Completed Screen — calm celebration after focus session.
class SessionCompletedScreen extends StatelessWidget {
  final int xpEarned;
  final int durationMinutes;
  final bool streakUpdated;

  const SessionCompletedScreen({
    super.key,
    required this.xpEarned,
    required this.durationMinutes,
    required this.streakUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberColors.background,
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(flex: 2),

                // Success icon — clean, no glow
                const NeonIconBadge(
                  icon: Icons.check_circle_rounded,
                  color: CyberColors.neonGreen,
                  size: 100,
                  iconSize: 48,
                ),
                const SizedBox(height: 28),

                Text(
                  'Session Complete!',
                  style: CyberTypography.headlineLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You crushed it! 🎉',
                  style: CyberTypography.bodyLarge.copyWith(
                    color: CyberColors.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 32),

                // Flat matte stat cards
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        value: '+$xpEarned',
                        label: 'XP Earned',
                        valueColor: CyberColors.neonGreen,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatCard(
                        value: '${durationMinutes}m',
                        label: 'Duration',
                        valueColor: CyberColors.electricBlue,
                      ),
                    ),
                    if (streakUpdated) ...[
                      const SizedBox(width: 10),
                      const Expanded(
                        child: _StatCard(
                          value: '🔥',
                          label: 'Streak!',
                          valueColor: CyberColors.scoreAtRisk,
                          isEmoji: true,
                        ),
                      ),
                    ],
                  ],
                ),

                const Spacer(flex: 2),

                CyberGradientButton(
                  label: 'Back to Dashboard',
                  icon: Icons.home_rounded,
                  onPressed: () => context.go(AppRoutes.dashboard),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;
  final bool isEmoji;

  const _StatCard({
    required this.value,
    required this.label,
    required this.valueColor,
    this.isEmoji = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: CyberColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        children: [
          isEmoji
              ? Text(
                  value,
                  style: CyberTypography.statValue,
                )
              : Text(
                  value,
                  style: CyberTypography.statValue.copyWith(
                    color: valueColor,
                    fontSize: 24,
                  ),
                ),
          const SizedBox(height: 5),
          Text(
            label,
            style: CyberTypography.statLabel.copyWith(
              color: CyberColors.onSurfaceMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
