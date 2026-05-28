import 'package:isar/isar.dart';
import '../isar_service.dart';
import '../schemas/achievement_schema.dart';

class AchievementDao {
  Isar get _db => IsarService.instance.db;

  Future<List<AchievementSchema>> getAll() async {
    return await _db.achievementSchemas.where().findAll();
  }

  Future<AchievementSchema?> getById(String achievementId) async {
    return await _db.achievementSchemas.filter().achievementIdEqualTo(achievementId).findFirst();
  }

  Future<void> upsert(AchievementSchema achievement) async {
    await _db.writeTxn(() async { await _db.achievementSchemas.put(achievement); });
  }
  
  Future<void> upsertAll(List<AchievementSchema> achievements) async {
    await _db.writeTxn(() async { await _db.achievementSchemas.putAll(achievements); });
  }

  Stream<List<AchievementSchema>> watchAll() {
    return _db.achievementSchemas.where().watch(fireImmediately: true);
  }
}
