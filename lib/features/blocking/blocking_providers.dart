import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/blocking_repository.dart';
import 'data/permissions_channel.dart';
import 'domain/app_limit.dart';
import 'domain/block_event.dart';
import 'domain/permission_health.dart';
import '../usage/usage_providers.dart';
import '../usage/domain/usage_log.dart';

// ---------------------------------------------------------------------------
// Repository provider
// ---------------------------------------------------------------------------

final blockingRepositoryProvider = Provider<BlockingRepository>((ref) {
  return BlockingRepository();
});

// ---------------------------------------------------------------------------
// App Limits — reactive stream
// ---------------------------------------------------------------------------

/// Reactive stream of all configured app limits from Isar.
final appLimitsProvider = StreamProvider<List<AppLimit>>((ref) {
  final repo = ref.watch(blockingRepositoryProvider);
  return repo.watchAppLimits();
});

// ---------------------------------------------------------------------------
// Block Events — last 7 days
// ---------------------------------------------------------------------------

final blockEventsProvider = FutureProvider<List<BlockEvent>>((ref) async {
  final repo = ref.watch(blockingRepositoryProvider);
  return repo.getBlockEvents(days: 7);
});

// ---------------------------------------------------------------------------
// Limit lookup by package name — for block screen
// ---------------------------------------------------------------------------

final limitForPackageProvider =
    FutureProvider.family<AppLimit?, String>((ref, packageName) async {
  final repo = ref.watch(blockingRepositoryProvider);
  return repo.getLimitForPackage(packageName);
});

// ---------------------------------------------------------------------------
// New Providers for App Limits Management
// ---------------------------------------------------------------------------

/// Provider for checking system permissions required by FocusShield.
final permissionsChannelProvider = Provider<PermissionsChannel>((ref) {
  return PermissionsChannel.instance;
});

final permissionHealthProvider = FutureProvider<PermissionHealth>((ref) async {
  final channel = ref.watch(permissionsChannelProvider);
  final usage = await channel.checkUsageAccessGranted();
  final accessibility = await channel.checkAccessibilityEnabled();
  final notifications = await channel.checkNotificationsGranted();
  return PermissionHealth(
    isUsageAccessGranted: usage,
    isAccessibilityEnabled: accessibility,
    isNotificationsGranted: notifications,
  );
});

/// Returns the number of configured app limits.
final appLimitCountProvider = Provider<int>((ref) {
  final limitsAsync = ref.watch(appLimitsProvider);
  return limitsAsync.maybeWhen(
    data: (limits) => limits.length,
    orElse: () => 0,
  );
});

/// Synchronous family provider to look up a limit from the cached stream state.
final appLimitByPackageProvider = Provider.family<AppLimit?, String>((ref, packageName) {
  final limitsAsync = ref.watch(appLimitsProvider);
  return limitsAsync.maybeWhen(
    data: (limits) {
      try {
        return limits.firstWhere((l) => l.packageName == packageName);
      } catch (_) {
        return null;
      }
    },
    orElse: () => null,
  );
});

/// Derived provider that lists apps nearing or exceeding 70% of their daily limits.
final appsNearLimitProvider = Provider<List<AppLimit>>((ref) {
  final limitsAsync = ref.watch(appLimitsProvider);
  final usageAsync = ref.watch(todayUsageProvider);

  return limitsAsync.maybeWhen(
    data: (limits) {
      return usageAsync.maybeWhen(
        data: (usageLogs) {
          final nearLimit = <AppLimit>[];
          for (final limit in limits) {
            if (!limit.isMonitoringEnabled || limit.isWhitelisted) continue;
            
            final log = usageLogs.firstWhere(
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
            );

            if (limit.currentDailyLimit > 0) {
              final ratio = log.totalMinutes / limit.currentDailyLimit;
              if (ratio >= 0.7) {
                nearLimit.add(limit);
              }
            }
          }
          return nearLimit;
        },
        orElse: () => const [],
      );
    },
    orElse: () => const [],
  );
});
