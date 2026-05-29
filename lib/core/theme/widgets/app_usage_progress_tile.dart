import 'package:flutter/material.dart';
import '../color_palette.dart';
import '../typography.dart';
import 'cyber_neon_progress_bar.dart';

/// A reusable tile to show an app's usage progress relative to its limit.
class AppUsageProgressTile extends StatelessWidget {
  final String appName;
  final String packageName;
  final int usedMinutes;
  final int limitMinutes;
  final Widget? trailing;

  const AppUsageProgressTile({
    super.key,
    required this.appName,
    required this.packageName,
    required this.usedMinutes,
    required this.limitMinutes,
    this.trailing,
  });

  Color _getStatusColor() {
    if (limitMinutes <= 0) return CyberColors.scoreExcellent;
    final ratio = usedMinutes / limitMinutes;
    if (ratio >= 1.0) return CyberColors.scoreCritical; // Red
    if (ratio >= 0.7) return CyberColors.scoreAtRisk;    // Orange
    return CyberColors.scoreExcellent;                  // Green
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();
    final maxValue = limitMinutes > 0 ? limitMinutes.toDouble() : 60.0;
    final ratio = limitMinutes > 0 ? (usedMinutes / limitMinutes) : 0.0;
    final percentage = (ratio * 100).clamp(0, 999).round();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CyberColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Colored Letter Avatar matching dashboard style
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    appName.isNotEmpty ? appName[0].toUpperCase() : '?',
                    style: CyberTypography.titleSmall.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appName,
                      style: CyberTypography.titleSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      limitMinutes > 0
                          ? '$usedMinutes / $limitMinutes min used'
                          : '$usedMinutes min used',
                      style: CyberTypography.bodySmall.copyWith(
                        color: CyberColors.onSurfaceMuted,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ] else if (limitMinutes > 0) ...[
                const SizedBox(width: 8),
                Text(
                  '$percentage%',
                  style: CyberTypography.labelLarge.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          CyberNeonProgressBar(
            value: usedMinutes.toDouble().clamp(0.0, maxValue),
            maxValue: maxValue,
            height: 4,
            gradientColors: [color, color.withOpacity(0.6)],
          ),
        ],
      ),
    );
  }
}
