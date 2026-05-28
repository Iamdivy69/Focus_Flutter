import 'package:flutter/material.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/theme/widgets/animated_gradient_background.dart';
import '../../../core/theme/widgets/cyber_glass_card.dart';
import '../../../core/theme/widgets/cyber_progress_ring.dart';

/// Recovery Progress Screen.
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('Recovery Progress')),
      body: AnimatedGradientBackground(
        showAurora: true,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Main progress ring
                CyberGlassCard(
                  borderOpacity: 0.1,
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      CyberProgressRing(
                        value: 65,
                        maxValue: 100,
                        size: 200,
                        strokeWidth: 14,
                        center: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('65%', style: CyberTypography.heroScore.copyWith(color: Colors.white, fontSize: 48)),
                            Text('RECOVERED', style: CyberTypography.scoreLabel.copyWith(color: CyberColors.onSurfaceVariant)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'You\'re making great progress!',
                        style: CyberTypography.titleMedium.copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Milestones
                Text(
                  'Milestones',
                  style: CyberTypography.titleMedium.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                _MilestoneCard(title: '7-Day Streak', subtitle: 'Complete 7 days of focused usage', isComplete: true, icon: Icons.local_fire_department_rounded),
                const SizedBox(height: 8),
                _MilestoneCard(title: 'Screen Time < 3h', subtitle: 'Keep daily screen time under 3 hours', isComplete: true, icon: Icons.timer_rounded),
                const SizedBox(height: 8),
                _MilestoneCard(title: 'Focus Score 90+', subtitle: 'Achieve a focus score above 90', isComplete: false, icon: Icons.emoji_events_rounded),
                const SizedBox(height: 8),
                _MilestoneCard(title: '30-Day Streak', subtitle: 'Complete 30 consecutive days', isComplete: false, icon: Icons.calendar_month_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MilestoneCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isComplete;
  final IconData icon;

  const _MilestoneCard({
    required this.title,
    required this.subtitle,
    required this.isComplete,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return CyberGlassCard(
      borderColor: isComplete ? CyberColors.neonGreen : CyberColors.outlineVariant,
      borderOpacity: isComplete ? 0.25 : 0.08,
      backgroundOpacity: 0.4,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (isComplete ? CyberColors.neonGreen : CyberColors.onSurfaceMuted).withOpacity(0.12),
            ),
            child: Icon(icon, color: isComplete ? CyberColors.neonGreen : CyberColors.onSurfaceMuted, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: CyberTypography.titleSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle, style: CyberTypography.bodySmall.copyWith(color: CyberColors.onSurfaceVariant)),
              ],
            ),
          ),
          if (isComplete)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CyberColors.neonGreen.withOpacity(0.15),
              ),
              child: const Icon(Icons.check_rounded, color: CyberColors.neonGreen, size: 18),
            ),
        ],
      ),
    );
  }
}
