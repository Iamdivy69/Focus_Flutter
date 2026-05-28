import 'package:isar/isar.dart';
import '../isar_service.dart';
import '../schemas/usage_log_schema.dart';

class UsageLogDao {
  Isar get _db => IsarService.instance.db;

  Future<UsageLogSchema?> getForDate(String packageName, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    return await _db.usageLogSchemas.filter()
        .packageNameEqualTo(packageName)
        .and()
        .dateEqualTo(startOfDay)
        .findFirst();
  }

  Future<List<UsageLogSchema>> getForDateRange(DateTime start, DateTime end) async {
    return await _db.usageLogSchemas.filter()
        .dateBetween(start, end)
        .findAll();
  }

  Future<List<UsageLogSchema>> getTodayLogs() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    return await _db.usageLogSchemas.filter()
        .dateEqualTo(startOfDay)
        .findAll();
  }

  Future<void> upsert(UsageLogSchema log) async {
    await _db.writeTxn(() async { await _db.usageLogSchemas.put(log); });
  }

  Future<void> upsertAll(List<UsageLogSchema> logs) async {
    await _db.writeTxn(() async { await _db.usageLogSchemas.putAll(logs); });
  }

  Future<int> getTotalMinutesForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final nextDay = startOfDay.add(const Duration(days: 1));
    final logs = await getForDateRange(startOfDay, nextDay);
    return logs.fold<int>(0, (sum, l) => sum + l.totalMinutes);
  }

  Stream<List<UsageLogSchema>> watchToday() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    return _db.usageLogSchemas.filter()
        .dateEqualTo(startOfDay)
        .watch(fireImmediately: true);
  }
}
