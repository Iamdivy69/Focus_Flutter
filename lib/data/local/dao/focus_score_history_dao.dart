import 'package:isar/isar.dart';
import '../isar_service.dart';
import '../schemas/focus_score_history_schema.dart';

class FocusScoreHistoryDao {
  Isar get _db => IsarService.instance.db;

  Future<List<FocusScoreHistorySchema>> getForDateRange(DateTime start, DateTime end) async {
    return await _db.focusScoreHistorySchemas.filter()
        .dateBetween(start, end)
        .findAll();
  }

  Future<void> upsert(FocusScoreHistorySchema history) async {
    await _db.writeTxn(() async { await _db.focusScoreHistorySchemas.put(history); });
  }

  Stream<List<FocusScoreHistorySchema>> watchRecent() {
    return _db.focusScoreHistorySchemas.where()
        .sortByDateDesc()
        .limit(30)
        .watch(fireImmediately: true);
  }
}
