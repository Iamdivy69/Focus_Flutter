import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/theme/glow_effects.dart';
import '../../../core/theme/widgets/animated_gradient_background.dart';
import '../../../core/theme/widgets/cyber_progress_ring.dart';
import '../../../core/theme/widgets/cyber_neon_progress_bar.dart';

/// Premium Dashboard — the heart of FocusShield.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Mock data — will be replaced by Riverpod providers
  final int _focusScore = 87;
  final List<_AppUsageData> _appUsage = const [
    _AppUsageData('Instagram', Icons.camera_alt_rounded, 45, 60, CyberColors.scoreAtRisk),
    _AppUsageData('YouTube', Icons.play_circle_rounded, 32, 45, CyberColors.scoreCritical),
    _AppUsageData('Twitter', Icons.tag_rounded, 12, 30, CyberColors.scoreExcellent),
    _AppUsageData('TikTok', Icons.music_note_rounded, 8, 20, CyberColors.scoreExcellent),
  ];

  @override
  Widget build(BuildContext context) {
    final scoreColor = GlowEffects.scoreGlowColor(_focusScore);

    return Scaffold(
      backgroundColor: CyberColors.background,
      extendBody: true,
      body: AnimatedGradientBackground(
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 96),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Header ─────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FocusShield',
                            style: CyberTypography.headlineSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Good morning ☀️',
                            style: CyberTypography.bodyMedium.copyWith(
                              color: CyberColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _HeaderIconButton(
                            icon: Icons.notifications_outlined,
                            onPressed: () {},
                          ),
                          const SizedBox(width: 8),
                          _HeaderIconButton(
                            icon: Icons.settings_outlined,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ─── Focus Score Hero Card ───────────────────────
                // Flat matte card — the ring itself handles the glow
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                    decoration: BoxDecoration(
                      color: CyberColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.06)),
                    ),
                    child: Column(
                      children: [
                        CyberProgressRing(
                          value: _focusScore.toDouble(),
                          maxValue: 100,
                          size: 176,
                          strokeWidth: 11,
                          center: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$_focusScore',
                                style: CyberTypography.heroScore.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'FOCUS SCORE',
                                style: CyberTypography.scoreLabel.copyWith(
                                  color: CyberColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Status chip — flat, no neon pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: scoreColor.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: scoreColor.withOpacity(0.18),
                            ),
                          ),
                          child: Text(
                            '🎯 Excellent — Keep it up!',
                            style: CyberTypography.labelMedium.copyWith(
                              color: scoreColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ─── Quick Actions ──────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: _QuickActionButton(
                          icon: Icons.timer_rounded,
                          label: 'Focus',
                          color: CyberColors.neonGreen,
                          onTap: () => context.go(AppRoutes.timerSetup),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _QuickActionButton(
                          icon: Icons.block_rounded,
                          label: 'Block',
                          color: CyberColors.electricBlue,
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _QuickActionButton(
                          icon: Icons.auto_awesome_rounded,
                          label: 'AI Coach',
                          color: CyberColors.electricBlue,
                          onTap: () => context.go(AppRoutes.arjunaChat),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // ─── App Usage Section ──────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    "Today's Usage",
                    style: CyberTypography.titleMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                ...List.generate(_appUsage.length, (index) {
                  final app = _appUsage[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
                    child: _AppUsageCard(app: app),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Sub-widgets ────────────────────────────────────────────────

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _HeaderIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: CyberColors.surfaceContainerHigh,
          border: Border.all(color: Colors.white.withOpacity(0.07)),
        ),
        child: Icon(icon, size: 19, color: CyberColors.onSurfaceVariant),
      ),
    );
  }
}

class _QuickActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<_QuickActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: CyberColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color.withOpacity(0.10),
                ),
                child: Icon(widget.icon, color: widget.color, size: 20),
              ),
              const SizedBox(height: 9),
              Text(
                widget.label,
                style: CyberTypography.labelMedium.copyWith(
                  color: CyberColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppUsageCard extends StatelessWidget {
  final _AppUsageData app;

  const _AppUsageCard({required this.app});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CyberColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: app.color.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(app.icon, color: app.color, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      app.name,
                      style: CyberTypography.titleSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${app.usageMinutes} / ${app.limitMinutes} min',
                      style: CyberTypography.bodySmall.copyWith(
                        color: CyberColors.onSurfaceMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${((app.usageMinutes / app.limitMinutes) * 100).round()}%',
                style: CyberTypography.labelLarge.copyWith(
                  color: app.color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          CyberNeonProgressBar(
            value: app.usageMinutes.toDouble(),
            maxValue: app.limitMinutes.toDouble(),
            height: 4,
            gradientColors: [app.color, app.color.withOpacity(0.6)],
          ),
        ],
      ),
    );
  }
}

class _AppUsageData {
  final String name;
  final IconData icon;
  final int usageMinutes;
  final int limitMinutes;
  final Color color;

  const _AppUsageData(this.name, this.icon, this.usageMinutes, this.limitMinutes, this.color);
}
