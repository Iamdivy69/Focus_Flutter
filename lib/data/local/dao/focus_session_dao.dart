import 'package:isar/isar.dart';
import '../isar_service.dart';
import '../schemas/focus_session_schema.dart';

class FocusSessionDao {
  Isar get _db => IsarService.instance.db;

  Future<List<FocusSessionSchema>> getForDateRange(DateTime start, DateTime end) async {
    return await _db.focusSessionSchemas.filter()
        .startedAtBetween(start, end)
        .findAll();
  }

  Future<void> add(FocusSessionSchema session) async {
    await _db.writeTxn(() async { await _db.focusSessionSchemas.put(session); });
  }
  
  Stream<List<FocusSessionSchema>> watchRecent() {
    return _db.focusSessionSchemas.where()
        .sortByStartedAtDesc()
        .limit(20)
        .watch(fireImmediately: true);
  }
}
