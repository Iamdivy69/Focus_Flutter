import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/theme/widgets/cyber_glass_card.dart';
import '../../../core/theme/widgets/cyber_gradient_button.dart';
import '../blocking_providers.dart';
import '../domain/app_limit.dart';

class AppLimitConfigSheet extends ConsumerStatefulWidget {
  final AppLimit? existing;
  final String? appName;
  final String? packageName;

  const AppLimitConfigSheet({
    super.key,
    this.existing,
    this.appName,
    this.packageName,
  }) : assert(existing != null || (appName != null && packageName != null),
            'Must provide either an existing limit or new app details');

  @override
  ConsumerState<AppLimitConfigSheet> createState() => _AppLimitConfigSheetState();
}

class _AppLimitConfigSheetState extends ConsumerState<AppLimitConfigSheet> {
  late String _appName;
  late String _packageName;
  late int _dailyLimitMinutes;
  late int _minimumLimitMinutes;
  late bool _isMonitoringEnabled;
  late bool _isWhitelisted;

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      final ext = widget.existing!;
      _appName = ext.appName;
      _packageName = ext.packageName;
      _dailyLimitMinutes = ext.currentDailyLimit;
      _minimumLimitMinutes = ext.minimumLimitMinutes;
      _isMonitoringEnabled = ext.isMonitoringEnabled;
      _isWhitelisted = ext.isWhitelisted;
    } else {
      _appName = widget.appName!;
      _packageName = widget.packageName!;
      _dailyLimitMinutes = 60; // 1 hour default
      _minimumLimitMinutes = 15; // 15 mins default
      _isMonitoringEnabled = true;
      _isWhitelisted = false;
    }
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) return '$minutes min';
    final hrs = minutes ~/ 60;
    final mins = minutes % 60;
    if (mins == 0) return '$hrs ${hrs == 1 ? 'hr' : 'hrs'}';
    return '$hrs ${hrs == 1 ? 'hr' : 'hrs'} $mins min';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Adjust sheet for onscreen keyboard if active
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: CyberGlassCard(
        blurAmount: 16,
        backgroundOpacity: 0.1,
        borderRadius: 24,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Grab handle
            Center(
              child: Container(
                width: 48,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.existing != null ? 'Edit Limit' : 'Set Limit',
                        style: CyberTypography.headlineSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _appName,
                        style: CyberTypography.titleSmall.copyWith(
                          color: CyberColors.electricBlue,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white54),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(color: Colors.white10, height: 24),

            // Slider 1 — Daily Usage Limit
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daily Usage Limit',
                  style: CyberTypography.titleSmall.copyWith(color: Colors.white),
                ),
                Text(
                  _formatDuration(_dailyLimitMinutes),
                  style: CyberTypography.labelLarge.copyWith(
                    color: CyberColors.electricBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: CyberColors.electricBlue,
                inactiveTrackColor: Colors.white10,
                thumbColor: Colors.white,
                overlayColor: CyberColors.electricBlue.withOpacity(0.12),
              ),
              child: Slider(
                value: _dailyLimitMinutes.toDouble(),
                min: 15,
                max: 480,
                divisions: (480 - 15) ~/ 5,
                onChanged: (val) {
                  setState(() {
                    _dailyLimitMinutes = val.round();
                    // Interlocking validation: daily limit cannot be less than minimum limit
                    if (_dailyLimitMinutes < _minimumLimitMinutes) {
                      _minimumLimitMinutes = _dailyLimitMinutes;
                    }
                  });
                },
              ),
            ),
            const SizedBox(height: 12),

            // Slider 2 — Minimum Floor Limit
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Minimum Limit (Floor)',
                  style: CyberTypography.titleSmall.copyWith(color: Colors.white),
                ),
                Text(
                  _formatDuration(_minimumLimitMinutes),
                  style: CyberTypography.labelLarge.copyWith(
                    color: CyberColors.neonGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: CyberColors.neonGreen,
                inactiveTrackColor: Colors.white10,
                thumbColor: Colors.white,
                overlayColor: CyberColors.neonGreen.withOpacity(0.12),
              ),
              child: Slider(
                value: _minimumLimitMinutes.toDouble(),
                min: 5,
                max: 120,
                divisions: (120 - 5) ~/ 5,
                onChanged: (val) {
                  setState(() {
                    _minimumLimitMinutes = val.round();
                    // Interlocking validation: minimum floor cannot exceed daily limit
                    if (_minimumLimitMinutes > _dailyLimitMinutes) {
                      _dailyLimitMinutes = _minimumLimitMinutes;
                    }
                  });
                },
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'The baseline limit reduces dynamically over time but will never drop below this floor.',
              style: CyberTypography.bodySmall.copyWith(
                color: CyberColors.onSurfaceMuted,
                fontSize: 11,
              ),
            ),
            const Divider(color: Colors.white10, height: 32),

            // Switch 1 — Active Monitoring
            SwitchListTile(
              title: Text(
                'Active Monitoring',
                style: CyberTypography.titleSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                'Monitor screen time and enforce limits.',
                style: CyberTypography.bodySmall.copyWith(color: CyberColors.onSurfaceMuted),
              ),
              value: _isMonitoringEnabled,
              activeColor: CyberColors.electricBlue,
              activeTrackColor: CyberColors.electricBlue.withOpacity(0.24),
              inactiveTrackColor: Colors.white10,
              contentPadding: EdgeInsets.zero,
              onChanged: (val) {
                setState(() {
                  _isMonitoringEnabled = val;
                });
              },
            ),

            // Switch 2 — Whitelisted
            SwitchListTile(
              title: Text(
                'Whitelist Application',
                style: CyberTypography.titleSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                'Temporarily suspend limits and bypass blocking.',
                style: CyberTypography.bodySmall.copyWith(color: CyberColors.onSurfaceMuted),
              ),
              value: _isWhitelisted,
              activeColor: CyberColors.neonGreen,
              activeTrackColor: CyberColors.neonGreen.withOpacity(0.24),
              inactiveTrackColor: Colors.white10,
              contentPadding: EdgeInsets.zero,
              onChanged: (val) {
                setState(() {
                  _isWhitelisted = val;
                });
              },
            ),
            const SizedBox(height: 24),

            // Action button
            CyberGradientButton(
              label: 'Save Limit Configuration',
              icon: Icons.check_rounded,
              onPressed: _saveLimit,
            ),
          ],
        ),
      ),
    );
  }

  void _saveLimit() async {
    final limit = AppLimit(
      packageName: _packageName,
      appName: _appName,
      baselineDailyMinutes: _dailyLimitMinutes,
      currentDailyLimit: _dailyLimitMinutes,
      minimumLimitMinutes: _minimumLimitMinutes,
      isMonitoringEnabled: _isMonitoringEnabled,
      isWhitelisted: _isWhitelisted,
      updatedAt: DateTime.now(),
    );

    await ref.read(blockingRepositoryProvider).upsertLimit(limit);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully configured limit for $_appName'),
          backgroundColor: CyberColors.neonGreen,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
