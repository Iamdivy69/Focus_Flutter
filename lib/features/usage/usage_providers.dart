import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/usage_repository.dart';
import 'domain/usage_log.dart';
import '../blocking/blocking_providers.dart';

// ---------------------------------------------------------------------------
// Repository provider
// ---------------------------------------------------------------------------

final usageRepositoryProvider = Provider<UsageRepository>((ref) {
  return UsageRepository();
});

// ---------------------------------------------------------------------------
// Today's usage — reactive stream from Isar
// ---------------------------------------------------------------------------

final todayUsageProvider = StreamProvider<List<UsageLog>>((ref) {
  final repo = ref.watch(usageRepositoryProvider);
  return repo.watchTodayUsage();
});

// ---------------------------------------------------------------------------
// Weekly usage — reactive stream from Isar
// ---------------------------------------------------------------------------

final weeklyUsageProvider = StreamProvider<List<UsageLog>>((ref) {
  final repo = ref.watch(usageRepositoryProvider);
  return repo.watchWeeklyUsage();
});

// ---------------------------------------------------------------------------
// Installed apps — one-shot future
// ---------------------------------------------------------------------------

final installedAppsProvider = FutureProvider<List<Map<String, String>>>((ref) {
  final repo = ref.watch(usageRepositoryProvider);
  return repo.getInstalledApps();
});

/// Filtered installed apps excluding those that already have a limit set.
final installedAppsWithFilterProvider = FutureProvider<List<Map<String, String>>>((ref) async {
  final allApps = await ref.watch(installedAppsProvider.future);
  final limitsAsync = ref.watch(appLimitsProvider);
  
  return limitsAsync.maybeWhen(
    data: (limits) {
      final existingPackages = limits.map((l) => l.packageName).toSet();
      return allApps.where((app) {
        final pkg = app['packageName'] ?? '';
        return !existingPackages.contains(pkg);
      }).toList();
    },
    orElse: () => allApps,
  );
});

// ---------------------------------------------------------------------------
// Sync trigger — call this from UI or background service
// ---------------------------------------------------------------------------

/// Async action provider that syncs usage and invalidates the stream providers.
final syncTodayUsageProvider = FutureProvider.autoDispose<void>((ref) async {
  final repo = ref.watch(usageRepositoryProvider);
  await repo.syncTodayUsage();
  // Invalidate the cached stream so UI re-reads fresh data
  ref.invalidate(todayUsageProvider);
});

final syncWeeklyUsageProvider = FutureProvider.autoDispose<void>((ref) async {
  final repo = ref.watch(usageRepositoryProvider);
  await repo.syncWeeklyUsage();
  ref.invalidate(weeklyUsageProvider);
});
