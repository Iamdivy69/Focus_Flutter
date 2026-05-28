import 'package:isar/isar.dart';
import '../isar_service.dart';
import '../schemas/user_schema.dart';

class UserDao {
  Isar get _db => IsarService.instance.db;

  Future<UserSchema?> getByUid(String uid) async {
    return await _db.userSchemas.filter().uidEqualTo(uid).findFirst();
  }

  Future<void> upsert(UserSchema user) async {
    await _db.writeTxn(() async { await _db.userSchemas.put(user); });
  }

  Future<void> delete(String uid) async {
    await _db.writeTxn(() async {
      await _db.userSchemas.filter().uidEqualTo(uid).deleteAll();
    });
  }

  Future<void> updateXp(String uid, int xpPoints, int focusLevel) async {
    final user = await getByUid(uid);
    if (user == null) return;
    user.xpPoints = xpPoints;
    user.focusLevel = focusLevel;
    await upsert(user);
  }

  Future<void> updateStreak(String uid, int currentStreak, int longestStreak) async {
    final user = await getByUid(uid);
    if (user == null) return;
    user.currentStreak = currentStreak;
    user.longestStreak = longestStreak;
    await upsert(user);
  }

  Future<void> updateLastActive(String uid) async {
    final user = await getByUid(uid);
    if (user == null) return;
    user.lastActive = DateTime.now();
    await upsert(user);
  }

  Stream<UserSchema?> watchByUid(String uid) {
    return _db.userSchemas.filter().uidEqualTo(uid)
        .watch(fireImmediately: true)
        .map((list) => list.isEmpty ? null : list.first);
  }
}
