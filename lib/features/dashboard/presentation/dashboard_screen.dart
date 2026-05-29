import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/theme/widgets/cyber_progress_ring.dart';
import '../../../features/usage/usage_providers.dart';
import '../../../features/usage/domain/usage_log.dart';
import '../../../features/focus_score/focus_score_providers.dart';
import '../../../features/focus_score/domain/focus_score_label.dart';
import '../../../features/focus_score/domain/focus_score_result.dart';
import '../../../features/blocking/blocking_providers.dart';
import '../../../features/blocking/domain/app_limit.dart';
import '../../../core/theme/widgets/permission_health_card.dart';
import '../../../core/theme/widgets/app_usage_progress_tile.dart';

/// Premium Dashboard — wired to real device data via Riverpod.
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger a sync on first load so we always have fresh data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(syncTodayUsageProvider.future).catchError((e) {
        debugPrint('Dashboard: sync error $e');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final scoreAsync  = ref.watch(focusScoreProvider);
    final usageAsync  = ref.watch(todayUsageProvider);
    final limitsAsync = ref.watch(appLimitsProvider);
    final appsNearLimit = ref.watch(appsNearLimitProvider);

    return Scaffold(
      backgroundColor: CyberColors.background,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: CyberColors.neonGreen,
          backgroundColor: CyberColors.surface,
          onRefresh: () async {
            await ref.read(syncTodayUsageProvider.future);
            ref.invalidate(focusScoreProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 96),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ─────────────────────────────────────────────────
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
                            _greeting(),
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

                // ── Permission Health ───────────────────────────────────────
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: PermissionHealthCard(),
                ),

                // ── Focus Score Hero Card ───────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: scoreAsync.when(
                    data: (result) => _FocusScoreCard(result: result),
                    loading: () => _FocusScoreCard(result: FocusScoreResult.perfect()),
                    error: (_, __) => _FocusScoreCard(result: FocusScoreResult.perfect()),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Quick Actions ───────────────────────────────────────────
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
                          onTap: () => context.go(AppRoutes.appLimits),
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

                // ── Apps Nearing Limit Warning ──────────────────────────────
                if (appsNearLimit.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: CyberColors.scoreAtRisk.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: CyberColors.scoreAtRisk.withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.warning_amber_rounded, color: CyberColors.scoreAtRisk, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Nearing Daily Limits',
                                style: CyberTypography.titleMedium.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ...appsNearLimit.map((limit) {
                            final log = usageAsync.maybeWhen(
                              data: (logs) => logs.firstWhere(
                                (u) => u.packageName == limit.packageName,
                                orElse: () => UsageLog(
                                  packageName: limit.packageName,
                                  appName: limit.appName,
                                  date: DateTime.now(),
                                  totalMinutes: 0,
                                  openCount: 0,
                                  longestSessionMinutes: 0,
                                  nightUsageMinutes: 0,
                                  morningUsageMinutes: 0,
                                  recordedAt: DateTime.now(),
                                ),
                              ),
                              orElse: () => UsageLog(
                                packageName: limit.packageName,
                                appName: limit.appName,
                                date: DateTime.now(),
                                totalMinutes: 0,
                                openCount: 0,
                                longestSessionMinutes: 0,
                                nightUsageMinutes: 0,
                                morningUsageMinutes: 0,
                                recordedAt: DateTime.now(),
                              ),
                            );

                            final ratio = limit.currentDailyLimit > 0 ? (log.totalMinutes / limit.currentDailyLimit) : 0.0;
                            final percentage = (ratio * 100).round();

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text(
                                '• ${limit.appName} has used $percentage% of its daily limit.',
                                style: CyberTypography.bodySmall.copyWith(
                                  color: CyberColors.onSurfaceVariant,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 28),

                // ── App Usage Section ───────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today's Usage",
                        style: CyberTypography.titleMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.tune_rounded, size: 16, color: CyberColors.electricBlue),
                        label: Text(
                          'Manage Limits',
                          style: CyberTypography.labelMedium.copyWith(
                            color: CyberColors.electricBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () => context.go(AppRoutes.appLimits),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // ── Usage Cards ─────────────────────────────────────────────
                usageAsync.when(
                  data: (logs) {
                    final limits = limitsAsync.valueOrNull ?? [];
                    if (logs.isEmpty) {
                      return _EmptyUsageCard();
                    }
                    // Show top 6 apps by usage
                    final topLogs = logs.take(6).toList();
                    return Column(
                      children: topLogs.map((log) {
                        final limit = _limitForLog(log, limits);
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
                          child: AppUsageProgressTile(
                            appName: log.appName,
                            packageName: log.packageName,
                            usedMinutes: log.totalMinutes,
                            limitMinutes: limit?.currentDailyLimit ?? 0,
                          ),
                        );
                      }).toList(),
                    );
                  },
                  loading: () => Column(
                    children: List.generate(3, (_) =>
                      const Padding(
                        padding: EdgeInsets.fromLTRB(24, 0, 24, 10),
                        child: _ShimmerCard(),
                      ),
                    ),
                  ),
                  error: (error, _) => Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
                    child: _ErrorCard(message: error.toString()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppLimit? _limitForLog(UsageLog log, List<AppLimit> limits) {
    try {
      return limits.firstWhere((l) => l.packageName == log.packageName);
    } catch (_) {
      return null;
    }
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning ☀️';
    if (hour < 17) return 'Good afternoon 🌤️';
    if (hour < 21) return 'Good evening 🌙';
    return 'Late night 🌑';
  }
}

// ─── Focus Score Card ─────────────────────────────────────────────────────

class _FocusScoreCard extends StatelessWidget {
  final FocusScoreResult result;

  const _FocusScoreCard({required this.result});

  Color _scoreColor() {
    switch (result.label) {
      case FocusScoreLabel.excellent: return CyberColors.scoreExcellent;
      case FocusScoreLabel.healthy:   return CyberColors.scoreHealthy;
      case FocusScoreLabel.moderate:  return CyberColors.scoreModerate;
      case FocusScoreLabel.atRisk:    return CyberColors.scoreAtRisk;
      case FocusScoreLabel.critical:  return CyberColors.scoreCritical;
    }
  }

  String _statusText() {
    final label = result.label;
    final trend  = result.trend;
    final trendStr = trend > 0 ? '↑$trend pts' : (trend < 0 ? '↓${-trend} pts' : '');
    return '${label.emoji} ${label.displayName}${trendStr.isNotEmpty ? ' · $trendStr' : ''}';
  }

  @override
  Widget build(BuildContext context) {
    final scoreColor = _scoreColor();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      decoration: BoxDecoration(
        color: CyberColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        children: [
          CyberProgressRing(
            value: result.score.toDouble(),
            maxValue: 100,
            size: 164,
            strokeWidth: 10,
            center: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${result.score}',
                  style: CyberTypography.heroScore.copyWith(color: Colors.white),
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

          // Status chip with trend
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: scoreColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: scoreColor.withOpacity(0.18)),
            ),
            child: Text(
              _statusText(),
              style: CyberTypography.labelMedium.copyWith(
                color: scoreColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// _AppUsageCard removed in favor of reusable AppUsageProgressTile

// ─── Empty state ──────────────────────────────────────────────────────────

class _EmptyUsageCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        decoration: BoxDecoration(
          color: CyberColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.04)),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.phone_android_rounded,
              size: 36,
              color: CyberColors.onSurfaceMuted,
            ),
            const SizedBox(height: 12),
            Text(
              'No usage data yet',
              style: CyberTypography.titleSmall.copyWith(
                color: CyberColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Grant Usage Access permission to track app usage.',
              style: CyberTypography.bodySmall.copyWith(
                color: CyberColors.onSurfaceMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Error card ───────────────────────────────────────────────────────────

class _ErrorCard extends StatelessWidget {
  final String message;

  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CyberColors.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: CyberColors.scoreCritical, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Failed to load usage data',
              style: CyberTypography.bodySmall.copyWith(color: CyberColors.scoreCritical),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shimmer placeholder card ─────────────────────────────────────────────

class _ShimmerCard extends StatefulWidget {
  const _ShimmerCard();

  @override
  State<_ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<_ShimmerCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 0.8).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) => Container(
        height: 70,
        decoration: BoxDecoration(
          color: CyberColors.surface.withOpacity(_anim.value),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.04)),
        ),
      ),
    );
  }
}

// ─── Sub-widgets ─────────────────────────────────────────────────────────

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
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

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
        builder: (context, child) =>
            Transform.scale(scale: _scaleAnimation.value, child: child),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: CyberColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.04)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color.withOpacity(0.10),
                ),
                child: Icon(widget.icon, color: widget.color, size: 19),
              ),
              const SizedBox(height: 8),
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
