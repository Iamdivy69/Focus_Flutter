import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../domain/usage_log.dart';

/// Wraps the Android [MethodChannel] `com.focusshield/usage_stats`.
///
/// All public methods return strongly-typed domain objects or throw on error.
class UsageChannel {
  static const _channel = MethodChannel('com.focusshield/usage_stats');

  UsageChannel._();
  static final UsageChannel instance = UsageChannel._();

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Returns usage stats for all user-facing apps used today (since midnight).
  /// Returns an empty list if usage access permission is not granted.
  Future<List<UsageLog>> getTodayUsage() async {
    try {
      final raw = await _channel.invokeListMethod<Map<Object?, Object?>>('getTodayUsage');
      return _mapRawList(raw ?? []);
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint('UsageChannel: permission denied — returning empty list');
        return [];
      }
      debugPrint('UsageChannel.getTodayUsage error: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('UsageChannel.getTodayUsage unexpected error: $e');
      return [];
    }
  }

  /// Returns aggregated usage for the last 7 days.
  Future<List<UsageLog>> getWeeklyUsage() async {
    try {
      final raw = await _channel.invokeListMethod<Map<Object?, Object?>>('getWeeklyUsage');
      return _mapRawList(raw ?? []);
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') return [];
      debugPrint('UsageChannel.getWeeklyUsage error: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('UsageChannel.getWeeklyUsage unexpected error: $e');
      return [];
    }
  }

  /// Returns list of installed user-facing apps: {packageName, appName}.
  Future<List<Map<String, String>>> getInstalledApps() async {
    try {
      final raw = await _channel.invokeListMethod<Map<Object?, Object?>>('getInstalledApps');
      return (raw ?? []).map((m) {
        final safe = m.map((k, v) => MapEntry(k.toString(), v.toString()));
        return {'packageName': safe['packageName'] ?? '', 'appName': safe['appName'] ?? ''};
      }).toList();
    } catch (e) {
      debugPrint('UsageChannel.getInstalledApps error: $e');
      return [];
    }
  }

  // ---------------------------------------------------------------------------
  // Mapping helpers
  // ---------------------------------------------------------------------------

  List<UsageLog> _mapRawList(List<Map<Object?, Object?>> raw) {
    final today = _startOfDay(DateTime.now());
    final now = DateTime.now();

    return raw.map((m) {
      final safe = m.map((k, v) => MapEntry(k.toString(), v));
      final packageName = safe['packageName']?.toString() ?? '';
      final appName     = safe['appName']?.toString() ?? packageName;
      final totalMinutes = _parseInt(safe['totalMinutes']);
      final openCount    = _parseInt(safe['openCount']);

      return UsageLog(
        packageName:           packageName,
        appName:               appName,
        date:                  today,
        totalMinutes:          totalMinutes,
        openCount:             openCount,
        longestSessionMinutes: 0,    // not available from UsageStatsManager aggregate
        nightUsageMinutes:     0,    // computed by a future detailed query
        morningUsageMinutes:   0,
        recordedAt:            now,
      );
    }).where((log) => log.packageName.isNotEmpty).toList();
  }

  DateTime _startOfDay(DateTime d) => DateTime(d.year, d.month, d.day);

  int _parseInt(Object? value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}

