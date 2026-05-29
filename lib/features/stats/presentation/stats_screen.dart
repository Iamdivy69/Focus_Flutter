import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/theme/widgets/cyber_neon_progress_bar.dart';
import '../../blocking/presentation/dev_tools_section.dart';

/// Statistics Screen — Charts and analytics.
class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('Statistics')),
      body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary stat cards — flat matte row
                const Row(
                  children: [
                    Expanded(
                      child: _StatSummaryCard(
                        label: "Today's Score",
                        value: '87',
                        icon: Icons.shield_rounded,
                        color: CyberColors.neonGreen,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _StatSummaryCard(
                        label: 'Screen Time',
                        value: '2h 14m',
                        icon: Icons.phone_android_rounded,
                        color: CyberColors.electricBlue,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _StatSummaryCard(
                        label: 'Streak',
                        value: '12',
                        icon: Icons.local_fire_department_rounded,
                        color: CyberColors.scoreAtRisk,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Section title
                Text(
                  'Weekly Trend',
                  style: CyberTypography.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),

                // Chart card — flat matte
                Container(
                  padding: const EdgeInsets.fromLTRB(8, 24, 16, 12),
                  decoration: BoxDecoration(
                    color: CyberColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.06)),
                  ),
                  child: SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 25,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: Colors.white.withOpacity(0.05),
                            strokeWidth: 1,
                          ),
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 25,
                              reservedSize: 32,
                              getTitlesWidget: (value, meta) => Text(
                                value.toInt().toString(),
                                style: CyberTypography.bodySmall.copyWith(
                                  color: CyberColors.onSurfaceMuted,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                                if (value.toInt() >= 0 && value.toInt() < days.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      days[value.toInt()],
                                      style: CyberTypography.bodySmall.copyWith(
                                        color: CyberColors.onSurfaceMuted,
                                        fontSize: 10,
                                      ),
                                    ),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        minX: 0,
                        maxX: 6,
                        minY: 0,
                        maxY: 100,
                        lineBarsData: [
                          LineChartBarData(
                            spots: const [
                              FlSpot(0, 72),
                              FlSpot(1, 68),
                              FlSpot(2, 78),
                              FlSpot(3, 82),
                              FlSpot(4, 75),
                              FlSpot(5, 90),
                              FlSpot(6, 87),
                            ],
                            isCurved: true,
                            curveSmoothness: 0.3,
                            // Calm green line — no neon
                            color: CyberColors.neonGreen,
                            barWidth: 2,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) =>
                                  FlDotCirclePainter(
                                    radius: 3.5,
                                    color: CyberColors.neonGreen,
                                    strokeWidth: 2,
                                    strokeColor: CyberColors.surface,
                                  ),
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              // Subtle fill — muted, not glowing
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  CyberColors.neonGreen.withOpacity(0.10),
                                  CyberColors.neonGreen.withOpacity(0.0),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                Text(
                  'App Breakdown',
                  style: CyberTypography.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),

                // App breakdown — flat matte cards
                const _AppBreakdownItem(name: 'Instagram', time: '45 min', progress: 0.75, color: CyberColors.scoreAtRisk),
                const SizedBox(height: 8),
                const _AppBreakdownItem(name: 'YouTube', time: '32 min', progress: 0.71, color: CyberColors.scoreCritical),
                const SizedBox(height: 8),
                const _AppBreakdownItem(name: 'Twitter', time: '12 min', progress: 0.4, color: CyberColors.neonGreen),
                const SizedBox(height: 8),
                const _AppBreakdownItem(name: 'TikTok', time: '8 min', progress: 0.4, color: CyberColors.neonGreen),
                const DevToolsSection(),
              ],
            ),
          ),
        ),
    );
  }
}

class _StatSummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatSummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CyberColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: CyberTypography.statValue.copyWith(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: CyberTypography.statLabel.copyWith(
              color: CyberColors.onSurfaceMuted,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _AppBreakdownItem extends StatelessWidget {
  final String name;
  final String time;
  final double progress;
  final Color color;

  const _AppBreakdownItem({
    required this.name,
    required this.time,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CyberColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: CyberTypography.titleSmall.copyWith(
                  color: Colors.white,
                ),
              ),
              Text(
                time,
                style: CyberTypography.labelMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          CyberNeonProgressBar(
            value: progress * 100,
            maxValue: 100,
            height: 4,
            gradientColors: [color, color.withOpacity(0.5)],
          ),
        ],
      ),
    );
  }
}
