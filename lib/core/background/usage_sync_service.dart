import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import '../../data/local/isar_service.dart';
import '../../features/usage/data/usage_repository.dart';
import '../../features/focus_score/domain/get_focus_score_use_case.dart';

/// Unique task names registered with WorkManager.
class _TaskNames {
  static const syncUsageTask = 'com.focusshield.syncUsage';
}

/// WorkManager-based background sync service.
///
/// Registers a periodic task that:
///   1. Opens Isar (if needed — background isolate)
///   2. Calls UsageRepository.syncTodayUsage()
///   3. Calls GetFocusScoreUseCase.execute() to persist today's snapshot
///
/// Frequency: every 1 hour (WorkManager enforces a 15-minute minimum on Android).
class UsageSyncService {
  UsageSyncService._();

  // ---------------------------------------------------------------------------
  // Registration — call once in main()
  // ---------------------------------------------------------------------------

  static Future<void> initialize() async {
    await Workmanager().initialize(
      _callbackDispatcher,
      isInDebugMode: kDebugMode,
    );
    debugPrint('UsageSyncService: WorkManager initialised');
  }

  /// Registers (or re-registers) the periodic sync task.
  /// Safe to call multiple times — WorkManager deduplicates by unique name.
  static Future<void> registerPeriodicTask() async {
    await Workmanager().registerPeriodicTask(
      _TaskNames.syncUsageTask,
      _TaskNames.syncUsageTask,
      frequency:         const Duration(hours: 1),
      existingWorkPolicy: ExistingWorkPolicy.keep,
      constraints: Constraints(
        networkType: NetworkType.not_required,
        requiresBatteryNotLow: false,
        requiresCharging: false,
      ),
      backoffPolicy: BackoffPolicy.linear,
      backoffPolicyDelay: const Duration(minutes: 5),
    );
    debugPrint('UsageSyncService: periodic task registered (1h interval)');
  }

  /// Cancels the background task (e.g. when the user uninstalls or logs out).
  static Future<void> cancel() async {
    await Workmanager().cancelByUniqueName(_TaskNames.syncUsageTask);
  }
}

// ---------------------------------------------------------------------------
// Top-level callback (required by WorkManager — must be top-level or static)
// ---------------------------------------------------------------------------

@pragma('vm:entry-point')
void _callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    debugPrint('UsageSyncService: background task "$taskName" starting');

    try {
      // Background isolate needs its own Isar connection
      await IsarService.instance.open();

      switch (taskName) {
        case _TaskNames.syncUsageTask:
          await _runSyncTask();
          break;
        default:
          debugPrint('UsageSyncService: unknown task "$taskName"');
      }

      debugPrint('UsageSyncService: task "$taskName" completed successfully');
      return true;
    } catch (e, st) {
      debugPrint('UsageSyncService: task "$taskName" failed: $e\n$st');
      return false; // WorkManager will retry per backoff policy
    }
  });
}

Future<void> _runSyncTask() async {
  // 1. Sync usage from Android
  final usageRepo = UsageRepository();
  await usageRepo.syncTodayUsage();

  // 2. Recompute and persist today's focus score snapshot
  final useCase = GetFocusScoreUseCase();
  await useCase.execute();
}
