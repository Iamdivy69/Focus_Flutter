import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/theme/widgets/app_usage_progress_tile.dart';
import '../../../core/theme/widgets/cyber_gradient_button.dart';
import '../../usage/usage_providers.dart';
import '../blocking_providers.dart';
import '../domain/app_limit.dart';
import 'app_limit_config_sheet.dart';
import 'app_picker_bottom_sheet.dart';

class AppLimitsScreen extends ConsumerWidget {
  const AppLimitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final limitsAsync = ref.watch(appLimitsProvider);
    final usageAsync = ref.watch(todayUsageProvider);

    return Scaffold(
      backgroundColor: CyberColors.background,
      appBar: AppBar(
        title: const Text('App Limits'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: limitsAsync.when(
        data: (limits) {
          if (limits.isEmpty) {
            return _buildEmptyState(context);
          }

          return usageAsync.maybeWhen(
            data: (usageLogs) {
              final usageMap = {for (final log in usageLogs) log.packageName: log.totalMinutes};
              return _buildLimitsList(context, ref, limits, usageMap);
            },
            orElse: () => _buildLimitsList(context, ref, limits, const {}),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: CyberColors.electricBlue),
        ),
        error: (err, stack) => Center(
          child: Text(
            'Error loading limits: $err',
            style: CyberTypography.bodyMedium.copyWith(color: CyberColors.scoreCritical),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CyberColors.electricBlue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_rounded, size: 28),
        onPressed: () => _showAppPicker(context),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.timer_off_rounded,
              size: 72,
              color: CyberColors.onSurfaceMuted,
            ),
            const SizedBox(height: 18),
            Text(
              'No App Limits Configured',
              style: CyberTypography.headlineSmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Take control of your focus. Set daily usage limits for distracting apps and FocusShield will block them when time is up.',
              style: CyberTypography.bodyMedium.copyWith(
                color: CyberColors.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            CyberGradientButton(
              label: 'Add App Limit',
              icon: Icons.add_rounded,
              onPressed: () => _showAppPicker(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLimitsList(
    BuildContext context,
    WidgetRef ref,
    List<AppLimit> limits,
    Map<String, int> usageMap,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      itemCount: limits.length,
      itemBuilder: (context, index) {
        final limit = limits[index];
        final used = usageMap[limit.packageName] ?? 0;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AppUsageProgressTile(
            appName: limit.appName,
            packageName: limit.packageName,
            usedMinutes: used,
            limitMinutes: limit.currentDailyLimit,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_rounded, color: CyberColors.electricBlue, size: 20),
                  onPressed: () => _editLimit(context, limit),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: CyberColors.scoreCritical, size: 20),
                  onPressed: () => _confirmDelete(context, ref, limit),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAppPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AppPickerBottomSheet(),
    );
  }

  void _editLimit(BuildContext context, AppLimit limit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AppLimitConfigSheet(existing: limit),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, AppLimit limit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: CyberColors.surface,
        title: Text(
          'Delete App Limit?',
          style: CyberTypography.titleMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to remove the limit for ${limit.appName}? This will stop active blocking for this app.',
          style: CyberTypography.bodyMedium.copyWith(color: CyberColors.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: CyberColors.onSurfaceMuted)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: CyberColors.scoreCritical),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(blockingRepositoryProvider).removeLimit(limit.packageName);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Removed limit for ${limit.appName}'),
                    backgroundColor: CyberColors.scoreCritical,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
