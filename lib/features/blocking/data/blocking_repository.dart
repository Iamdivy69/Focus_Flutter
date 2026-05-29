import 'package:flutter/foundation.dart';
import '../../../data/local/dao/app_limit_dao.dart';
import '../../../data/local/dao/block_event_dao.dart';
import '../../../data/local/schemas/app_limit_schema.dart';
import '../../../data/local/schemas/block_event_schema.dart';
import '../domain/app_limit.dart';
import '../domain/block_event.dart';
import 'blocking_channel.dart';

/// Repository for blocking configuration and block event logging.
///
/// Data flow:
///   [AppLimitDao] (Isar) ↔ [BlockingRepository] ↔ [BlockingChannel] (Android)
///   [BlockEventDao] (Isar) ← [BlockingRepository.logBlockEvent]
class BlockingRepository {
  final AppLimitDao _appLimitDao;
  final BlockEventDao _blockEventDao;
  final BlockingChannel _channel;

  BlockingRepository({
    AppLimitDao? appLimitDao,
    BlockEventDao? blockEventDao,
    BlockingChannel? channel,
  })  : _appLimitDao    = appLimitDao ?? AppLimitDao(),
        _blockEventDao  = blockEventDao ?? BlockEventDao(),
        _channel        = channel ?? BlockingChannel.instance;

  // ---------------------------------------------------------------------------
  // App Limits — read
  // ---------------------------------------------------------------------------

  /// Reactive stream of all app limits, auto-updates when Isar changes.
  Stream<List<AppLimit>> watchAppLimits() {
    return _appLimitDao.watchAll().map(
      (schemas) => schemas.map(_limitFromSchema).toList(),
    );
  }

  Future<List<AppLimit>> getAllLimits() async {
    final schemas = await _appLimitDao.getAll();
    return schemas.map(_limitFromSchema).toList();
  }

  Future<AppLimit?> getLimitForPackage(String packageName) async {
    final schema = await _appLimitDao.getByPackage(packageName);
    return schema != null ? _limitFromSchema(schema) : null;
  }

  // ---------------------------------------------------------------------------
  // App Limits — write
  // ---------------------------------------------------------------------------

  /// Creates or updates a limit for an app and pushes updated config to native.
  Future<void> upsertLimit(AppLimit limit) async {
    final schema = _limitToSchema(limit);
    await _appLimitDao.upsert(schema);
    await _pushConfigToNative();
    debugPrint('BlockingRepository: upserted limit for ${limit.packageName}');
  }

  /// Removes a limit for an app.
  Future<void> removeLimit(String packageName) async {
    await _appLimitDao.delete(packageName);
    await _pushConfigToNative();
  }

  // ---------------------------------------------------------------------------
  // Block Events — write
  // ---------------------------------------------------------------------------

  /// Logs a block event to Isar. Called from the block screen on appearance.
  Future<void> logBlockEvent(BlockEvent event) async {
    final schema = BlockEventSchema()
      ..packageName      = event.packageName
      ..reason           = event.reason
      ..blockedAt        = event.blockedAt
      ..durationOverLimit = event.durationOverLimit;
    await _blockEventDao.add(schema);
    debugPrint('BlockingRepository: logged block for ${event.packageName}');
  }

  // ---------------------------------------------------------------------------
  // Block Events — read
  // ---------------------------------------------------------------------------

  Future<List<BlockEvent>> getBlockEvents({int days = 7}) async {
    final now   = DateTime.now();
    final start = now.subtract(Duration(days: days));
    final schemas = await _blockEventDao.getForDateRange(start, now);
    return schemas.map(_eventFromSchema).toList();
  }

  // ---------------------------------------------------------------------------
  // Native config sync
  // ---------------------------------------------------------------------------

  /// Pushes the current Isar limits to Android SharedPreferences so
  /// [AppBlockService] picks them up on the next window event.
  Future<void> _pushConfigToNative() async {
    final limits = await getAllLimits();
    if (limits.isEmpty) {
      await _channel.disableBlocking();
    } else {
      await _channel.enableBlocking(limits);
    }
  }

  /// Explicitly enable/disable full blocking (used by toggle switches in UI).
  Future<void> setBlockingEnabled(bool enabled) async {
    if (enabled) {
      await _pushConfigToNative();
    } else {
      await _channel.disableBlocking();
    }
  }

  Future<void> setHardcoreMode({required bool enabled}) async {
    await _channel.setHardcoreMode(enabled: enabled);
  }

  Future<void> setFocusMode({required bool enabled, List<String> allowedPackages = const <String>[]}) async {
    await _channel.setFocusMode(enabled: enabled, allowedPackages: allowedPackages);
  }

  // ---------------------------------------------------------------------------
  // Schema ↔ domain mappers
  // ---------------------------------------------------------------------------

  AppLimit _limitFromSchema(AppLimitSchema s) {
    return AppLimit(
      packageName:          s.packageName,
      appName:              s.appName,
      baselineDailyMinutes: s.baselineDailyMinutes,
      currentDailyLimit:    s.currentDailyLimit,
      minimumLimitMinutes:  s.minimumLimitMinutes,
      isMonitoringEnabled:  s.isMonitoringEnabled,
      isWhitelisted:        s.isWhitelisted,
      updatedAt:            s.updatedAt,
    );
  }

  AppLimitSchema _limitToSchema(AppLimit l) {
    final schema = AppLimitSchema()
      ..packageName          = l.packageName
      ..appName              = l.appName
      ..baselineDailyMinutes = l.baselineDailyMinutes
      ..currentDailyLimit    = l.currentDailyLimit
      ..minimumLimitMinutes  = l.minimumLimitMinutes
      ..isMonitoringEnabled  = l.isMonitoringEnabled
      ..isWhitelisted        = l.isWhitelisted
      ..reductionStepMinutes = 10    // default step
      ..scheduleStartHour    = 0
      ..scheduleEndHour      = 24
      ..reductionPaused      = false
      ..updatedAt            = l.updatedAt;
    return schema;
  }

  BlockEvent _eventFromSchema(BlockEventSchema s) {
    return BlockEvent(
      packageName:      s.packageName,
      reason:           s.reason,
      blockedAt:        s.blockedAt,
      durationOverLimit: s.durationOverLimit,
    );
  }
}
