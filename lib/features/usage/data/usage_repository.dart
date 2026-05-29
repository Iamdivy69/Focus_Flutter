import 'package:flutter/foundation.dart';
import '../../../data/local/dao/usage_log_dao.dart';
import '../../../data/local/schemas/usage_log_schema.dart';
import '../domain/usage_log.dart';
import 'usage_channel.dart';

/// Repository that coordinates between the Android MethodChannel and the
/// local Isar database for app usage data.
///
/// Data flow:
///   Android (UsageStatsManager)
///     → [UsageChannel]
///     → [UsageRepository.syncTodayUsage]
///     → [UsageLogDao] (Isar)
///     → [watchTodayUsage] stream
class UsageRepository {
  final UsageChannel _channel;
  final UsageLogDao _dao;

  UsageRepository({
    UsageChannel? channel,
    UsageLogDao? dao,
  })  : _channel = channel ?? UsageChannel.instance,
        _dao = dao ?? UsageLogDao();

  // ---------------------------------------------------------------------------
  // Sync — pull from Android, store in Isar
  // ---------------------------------------------------------------------------

  /// Syncs today's usage from Android UsageStatsManager into Isar.
  /// Only writes changed records (upsert by packageName + date).
  Future<void> syncTodayUsage() async {
    try {
      final usageLogs = await _channel.getTodayUsage();
      if (usageLogs.isEmpty) {
        debugPrint('UsageRepository: no usage data returned (permission missing?)');
        return;
      }

      final schemas = usageLogs.map(_toSchema).toList();
      await _dao.upsertAll(schemas);
      debugPrint('UsageRepository: synced ${schemas.length} usage records for today');
    } catch (e) {
      debugPrint('UsageRepository.syncTodayUsage error: $e');
    }
  }

  /// Syncs weekly usage (last 7 days) from Android into Isar.
  Future<void> syncWeeklyUsage() async {
    try {
      final usageLogs = await _channel.getWeeklyUsage();
      if (usageLogs.isEmpty) return;

      final schemas = usageLogs.map(_toSchema).toList();
      await _dao.upsertAll(schemas);
      debugPrint('UsageRepository: synced ${schemas.length} weekly usage records');
    } catch (e) {
      debugPrint('UsageRepository.syncWeeklyUsage error: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Watch — reactive Isar streams
  // ---------------------------------------------------------------------------

  /// Reactive stream of today's usage logs, sorted by usage descending.
  Stream<List<UsageLog>> watchTodayUsage() {
    return _dao.watchToday().map(
      (schemas) => schemas
          .map(_fromSchema)
          .toList()
            ..sort((a, b) => b.totalMinutes.compareTo(a.totalMinutes)),
    );
  }

  /// Returns a stream of usage logs for the last [days] days.
  Stream<List<UsageLog>> watchWeeklyUsage({int days = 7}) {
    final now   = DateTime.now();
    final start = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: days - 1));
    final end   = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return _dao.getForDateRange(start, end).asStream().asyncExpand(
      (_) => Stream.periodic(const Duration(seconds: 30)).asyncMap(
        (_) async => (await _dao.getForDateRange(start, end))
            .map(_fromSchema)
            .toList(),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // One-shot reads
  // ---------------------------------------------------------------------------

  Future<List<UsageLog>> getTodayUsage() async {
    final schemas = await _dao.getTodayLogs();
    return schemas.map(_fromSchema).toList()
      ..sort((a, b) => b.totalMinutes.compareTo(a.totalMinutes));
  }

  Future<List<Map<String, String>>> getInstalledApps() async {
    return _channel.getInstalledApps();
  }

  // ---------------------------------------------------------------------------
  // Schema ↔ domain mappers
  // ---------------------------------------------------------------------------

  UsageLogSchema _toSchema(UsageLog log) {
    final existing = UsageLogSchema()
      ..packageName           = log.packageName
      ..appName               = log.appName
      ..date                  = DateTime(log.date.year, log.date.month, log.date.day)
      ..totalMinutes          = log.totalMinutes
      ..openCount             = log.openCount
      ..longestSessionMinutes = log.longestSessionMinutes
      ..nightUsageMinutes     = log.nightUsageMinutes
      ..morningUsageMinutes   = log.morningUsageMinutes
      ..recordedAt            = log.recordedAt;
    return existing;
  }

  UsageLog _fromSchema(UsageLogSchema s) {
    return UsageLog(
      packageName:           s.packageName,
      appName:               s.appName,
      date:                  s.date,
      totalMinutes:          s.totalMinutes,
      openCount:             s.openCount,
      longestSessionMinutes: s.longestSessionMinutes,
      nightUsageMinutes:     s.nightUsageMinutes,
      morningUsageMinutes:   s.morningUsageMinutes,
      recordedAt:            s.recordedAt,
    );
  }
}
