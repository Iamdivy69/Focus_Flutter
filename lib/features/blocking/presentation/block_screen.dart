import 'package:flutter/material.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/theme/widgets/animated_gradient_background.dart';
import '../../../core/theme/widgets/cyber_neon_progress_bar.dart';
import '../../../core/theme/widgets/neon_icon_badge.dart';

/// Block Screen — displayed when a restricted app is accessed.
class BlockScreen extends StatelessWidget {
  final String packageName;
  final String blockReason;
  final int usageMinutes;
  final int limitMinutes;

  const BlockScreen({
    super.key,
    required this.packageName,
    required this.blockReason,
    required this.usageMinutes,
    required this.limitMinutes,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AnimatedGradientBackground(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Red glow block icon
                  const NeonIconBadge(
                    icon: Icons.block_rounded,
                    color: CyberColors.scoreCritical,
                    size: 120,
                    iconSize: 56,
                  ),
                  const SizedBox(height: 32),

                  Text(
                    'App Blocked',
                    style: CyberTypography.headlineLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    packageName,
                    style: CyberTypography.titleMedium.copyWith(
                      color: CyberColors.scoreCritical,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    blockReason,
                    style: CyberTypography.bodyMedium.copyWith(
                      color: CyberColors.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Usage bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Usage', style: CyberTypography.labelMedium.copyWith(color: CyberColors.onSurfaceVariant)),
                            Text(
                              '$usageMinutes / $limitMinutes min',
                              style: CyberTypography.labelMedium.copyWith(color: CyberColors.scoreCritical),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        CyberNeonProgressBar(
                          value: usageMinutes.toDouble(),
                          maxValue: limitMinutes.toDouble(),
                          height: 8,
                          gradientColors: [CyberColors.scoreCritical, CyberColors.scoreAtRisk],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 48),

                  Text(
                    'Take a break. Your future self will thank you. 🧘',
                    style: CyberTypography.bodyMedium.copyWith(
                      color: CyberColors.onSurfaceMuted,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
