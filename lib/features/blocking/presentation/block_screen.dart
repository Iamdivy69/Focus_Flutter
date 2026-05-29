import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/theme/widgets/animated_gradient_background.dart';
import '../../../core/theme/widgets/cyber_neon_progress_bar.dart';
import '../../../core/theme/widgets/neon_icon_badge.dart';
import '../blocking_providers.dart';
import '../data/blocking_channel.dart';
import '../domain/block_event.dart';

/// Block Screen — displayed whenever a restricted app is accessed.
///
/// - Back button is disabled (PopScope)
/// - Logs the block event to Isar on first appearance
/// - Resolves the real app name from installedAppsProvider
/// - Provides Start Focus, View Progress, and Go Home actions
class BlockScreen extends ConsumerStatefulWidget {
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
  ConsumerState<BlockScreen> createState() => _BlockScreenState();
}

class _BlockScreenState extends ConsumerState<BlockScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;
  bool _eventLogged = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Log the block event once when the screen first appears
    WidgetsBinding.instance.addPostFrameCallback((_) => _logBlockEvent());
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _logBlockEvent() async {
    if (_eventLogged) return;
    _eventLogged = true;
    try {
      final repo = ref.read(blockingRepositoryProvider);
      final overLimit = widget.usageMinutes > widget.limitMinutes
          ? widget.usageMinutes - widget.limitMinutes
          : 0;
      await repo.logBlockEvent(BlockEvent(
        packageName:       widget.packageName,
        reason:            widget.blockReason,
        blockedAt:         DateTime.now(),
        durationOverLimit: overLimit,
      ));
    } catch (e) {
      debugPrint('BlockScreen: failed to log block event: $e');
    }
  }

  Future<void> _goHome() async {
    await BlockingChannel.instance.goHome();
  }

  @override
  Widget build(BuildContext context) {
    // Resolve human-readable app name via the limit record (or fall back to packageName)
    final limitAsync = ref.watch(limitForPackageProvider(widget.packageName));
    final appName = limitAsync.maybeWhen(
      data: (limit) => limit?.appName ?? widget.packageName,
      orElse: () => widget.packageName,
    );

    final blockEvent = BlockEvent(
      packageName: widget.packageName,
      reason: widget.blockReason,
      blockedAt: DateTime.now(),
      durationOverLimit: 0,
    );

    final progressValue  = widget.limitMinutes > 0
        ? widget.usageMinutes.toDouble()
        : 0.0;
    final progressMax    = widget.limitMinutes > 0
        ? widget.limitMinutes.toDouble()
        : 1.0;
    final usagePercent   = widget.limitMinutes > 0
        ? ((widget.usageMinutes / widget.limitMinutes) * 100).clamp(0, 999).round()
        : 0;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AnimatedGradientBackground(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // ── Pulsing block icon ─────────────────────────────────────
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) => Transform.scale(
                      scale: _pulseAnimation.value,
                      child: child,
                    ),
                    child: const NeonIconBadge(
                      icon: Icons.block_rounded,
                      color: CyberColors.scoreCritical,
                      size: 110,
                      iconSize: 52,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── App name & reason ──────────────────────────────────────
                  Text(
                    'App Blocked',
                    style: CyberTypography.headlineLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: CyberColors.scoreCritical.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: CyberColors.scoreCritical.withOpacity(0.25)),
                    ),
                    child: Text(
                      appName,
                      style: CyberTypography.titleSmall.copyWith(
                        color: CyberColors.scoreCritical,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    blockEvent.readableReason,
                    style: CyberTypography.bodyMedium.copyWith(
                      color: CyberColors.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  // ── Usage progress bar (only shown for USAGE_LIMIT) ────────
                  if (widget.limitMinutes > 0) ...[
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: CyberColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.05)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Daily Usage',
                                style: CyberTypography.labelMedium.copyWith(
                                  color: CyberColors.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                '${widget.usageMinutes} / ${widget.limitMinutes} min  ($usagePercent%)',
                                style: CyberTypography.labelMedium.copyWith(
                                  color: CyberColors.scoreCritical,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          CyberNeonProgressBar(
                            value: progressValue.clamp(0, progressMax),
                            maxValue: progressMax,
                            height: 8,
                            gradientColors: const [
                              CyberColors.scoreCritical,
                              CyberColors.scoreAtRisk,
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // ── Motivational text ──────────────────────────────────────
                  Text(
                    'Take a break. Your future self will thank you. 🧘',
                    style: CyberTypography.bodyMedium.copyWith(
                      color: CyberColors.onSurfaceMuted,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const Spacer(flex: 3),

                  // ── Action buttons ─────────────────────────────────────────
                  _BlockActionButton(
                    id: 'btn_start_focus',
                    icon: Icons.timer_rounded,
                    label: 'Start Focus Session',
                    color: CyberColors.neonGreen,
                    onTap: () => context.go(AppRoutes.timerSetup),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _BlockActionButton(
                          id: 'btn_view_progress',
                          icon: Icons.bar_chart_rounded,
                          label: 'View Progress',
                          color: CyberColors.electricBlue,
                          onTap: () => context.go(AppRoutes.stats),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _BlockActionButton(
                          id: 'btn_go_home',
                          icon: Icons.home_rounded,
                          label: 'Go Home',
                          color: CyberColors.onSurfaceVariant,
                          onTap: _goHome,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Action button widget ──────────────────────────────────────────────────

class _BlockActionButton extends StatefulWidget {
  final String id;
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _BlockActionButton({
    required this.id,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_BlockActionButton> createState() => _BlockActionButtonState();
}

class _BlockActionButtonState extends State<_BlockActionButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:  (_) => _ctrl.forward(),
      onTapUp:    (_) { _ctrl.reverse(); widget.onTap(); },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          decoration: BoxDecoration(
            color: widget.color.withOpacity(0.10),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: widget.color.withOpacity(0.20)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: widget.color, size: 18),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: CyberTypography.labelLarge.copyWith(
                  color: widget.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
