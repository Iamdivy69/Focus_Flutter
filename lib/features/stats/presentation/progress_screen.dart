import 'package:flutter/material.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/theme/widgets/cyber_progress_ring.dart';

/// Recovery Progress Screen — flat matte, no glass cards.
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('Recovery Progress')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main progress card — flat matte
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                decoration: BoxDecoration(
                  color: CyberColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.04)),
                ),
                child: Column(
                  children: [
                    CyberProgressRing(
                      value: 65,
                      maxValue: 100,
                      size: 180,
                      strokeWidth: 11,
                      center: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '65%',
                            style: CyberTypography.heroScore.copyWith(
                              color: Colors.white,
                              fontSize: 44,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'RECOVERED',
                            style: CyberTypography.scoreLabel.copyWith(
                              color: CyberColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "You're making great progress!",
                      style: CyberTypography.titleSmall.copyWith(
                        color: CyberColors.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Milestones',
                style: CyberTypography.titleMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              const _MilestoneRow(
                title: '7-Day Streak',
                subtitle: 'Complete 7 days of focused usage',
                isComplete: true,
                icon: Icons.local_fire_department_rounded,
              ),
              const SizedBox(height: 8),
              const _MilestoneRow(
                title: 'Screen Time < 3h',
                subtitle: 'Keep daily screen time under 3 hours',
                isComplete: true,
                icon: Icons.timer_rounded,
              ),
              const SizedBox(height: 8),
              const _MilestoneRow(
                title: 'Focus Score 90+',
                subtitle: 'Achieve a focus score above 90',
                isComplete: false,
                icon: Icons.emoji_events_rounded,
              ),
              const SizedBox(height: 8),
              const _MilestoneRow(
                title: '30-Day Streak',
                subtitle: 'Complete 30 consecutive days',
                isComplete: false,
                icon: Icons.calendar_month_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MilestoneRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isComplete;
  final IconData icon;

  const _MilestoneRow({
    required this.title,
    required this.subtitle,
    required this.isComplete,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final color = isComplete ? CyberColors.neonGreen : CyberColors.onSurfaceMuted;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CyberColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isComplete
              ? CyberColors.neonGreen.withOpacity(0.14)
              : Colors.white.withOpacity(0.04),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.10),
            ),
            child: Icon(icon, color: color, size: 19),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: CyberTypography.titleSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: CyberTypography.bodySmall.copyWith(
                    color: CyberColors.onSurfaceMuted,
                  ),
                ),
              ],
            ),
          ),
          if (isComplete)
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CyberColors.neonGreen.withOpacity(0.12),
              ),
              child: const Icon(
                Icons.check_rounded,
                color: CyberColors.neonGreen,
                size: 14,
              ),
            ),
        ],
      ),
    );
  }
}
