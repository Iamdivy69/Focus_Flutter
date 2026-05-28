import 'package:isar/isar.dart';
import '../isar_service.dart';
import '../schemas/daily_streak_schema.dart';

class DailyStreakDao {
  Isar get _db => IsarService.instance.db;

  Future<DailyStreakSchema?> getByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    return await _db.dailyStreakSchemas.filter().dateEqualTo(startOfDay).findFirst();
  }

  Future<void> upsert(DailyStreakSchema streak) async {
    await _db.writeTxn(() async { await _db.dailyStreakSchemas.put(streak); });
  }

  Stream<DailyStreakSchema?> watchByDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    return _db.dailyStreakSchemas.filter().dateEqualTo(startOfDay)
        .watch(fireImmediately: true)
        .map((list) => list.isEmpty ? null : list.first);
  }
}
