import os

base_dir = r"d:\PROJECTS\FS_Flutter\focusshield\lib\data\local\dao"

daos = {
    "user_dao.dart": """import 'package:isar/isar.dart';
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
""",
    "friend_dao.dart": """import 'package:isar/isar.dart';
import '../isar_service.dart';
import '../schemas/friend_schema.dart';

class FriendDao {
  Isar get _db => IsarService.instance.db;

  Future<List<FriendSchema>> getAccepted() async {
    return await _db.friendSchemas.filter().friendshipStatusEqualTo('accepted').findAll();
  }

  Future<List<FriendSchema>> getPending() async {
    return await _db.friendSchemas.filter().friendshipStatusEqualTo('pending').findAll();
  }

  Future<FriendSchema?> getByUid(String uid) async {
    return await _db.friendSchemas.filter().friendUidEqualTo(uid).findFirst();
  }

  Future<void> upsert(FriendSchema friend) async {
    await _db.writeTxn(() async { await _db.friendSchemas.put(friend); });
  }

  Future<void> upsertAll(List<FriendSchema> friends) async {
    await _db.writeTxn(() async { await _db.friendSchemas.putAll(friends); });
  }

  Future<void> delete(String uid) async {
    await _db.writeTxn(() async {
      await _db.friendSchemas.filter().friendUidEqualTo(uid).deleteAll();
    });
  }

  Future<void> updateStatus(String uid, String status) async {
    final friend = await getByUid(uid);
    if (friend == null) return;
    friend.friendshipStatus = status;
    await upsert(friend);
  }

  Stream<List<FriendSchema>> watchAccepted() {
    return _db.friendSchemas.filter().friendshipStatusEqualTo('accepted')
        .watch(fireImmediately: true);
  }
}
""",
    "usage_log_dao.dart": """import 'package:isar/isar.dart';
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
""",
    "app_limit_dao.dart": """import 'package:isar/isar.dart';
import '../isar_service.dart';
import '../schemas/app_limit_schema.dart';

class AppLimitDao {
  Isar get _db => IsarService.instance.db;

  Future<List<AppLimitSchema>> getAll() async {
    return await _db.appLimitSchemas.where().findAll();
  }

  Future<AppLimitSchema?> getByPackage(String packageName) async {
    return await _db.appLimitSchemas.filter().packageNameEqualTo(packageName).findFirst();
  }

  Future<void> upsert(AppLimitSchema limit) async {
    await _db.writeTxn(() async { await _db.appLimitSchemas.put(limit); });
  }

  Future<void> delete(String packageName) async {
    await _db.writeTxn(() async {
      await _db.appLimitSchemas.filter().packageNameEqualTo(packageName).deleteAll();
    });
  }

  Stream<List<AppLimitSchema>> watchAll() {
    return _db.appLimitSchemas.where().watch(fireImmediately: true);
  }
}
""",
    "block_event_dao.dart": """import 'package:isar/isar.dart';
import '../isar_service.dart';
import '../schemas/block_event_schema.dart';

class BlockEventDao {
  Isar get _db => IsarService.instance.db;

  Future<List<BlockEventSchema>> getForDateRange(DateTime start, DateTime end) async {
    return await _db.blockEventSchemas.filter()
        .timestampBetween(start, end)
        .findAll();
  }

  Future<void> add(BlockEventSchema event) async {
    await _db.writeTxn(() async { await _db.blockEventSchemas.put(event); });
  }
}
""",
    "focus_session_dao.dart": """import 'package:isar/isar.dart';
import '../isar_service.dart';
import '../schemas/focus_session_schema.dart';

class FocusSessionDao {
  Isar get _db => IsarService.instance.db;

  Future<List<FocusSessionSchema>> getForDateRange(DateTime start, DateTime end) async {
    return await _db.focusSessionSchemas.filter()
        .startTimeBetween(start, end)
        .findAll();
  }

  Future<void> add(FocusSessionSchema session) async {
    await _db.writeTxn(() async { await _db.focusSessionSchemas.put(session); });
  }
  
  Stream<List<FocusSessionSchema>> watchRecent() {
    return _db.focusSessionSchemas.where()
        .sortByStartTimeDesc()
        .limit(20)
        .watch(fireImmediately: true);
  }
}
""",
    "achievement_dao.dart": """import 'package:isar/isar.dart';
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
""",
    "daily_streak_dao.dart": """import 'package:isar/isar.dart';
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
""",
    "focus_score_history_dao.dart": """import 'package:isar/isar.dart';
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
"""
}

for filename, content in daos.items():
    filepath = os.path.join(base_dir, filename)
    with open(filepath, "w", encoding="utf-8") as f:
        f.write(content)
    print(f"Generated {filename}")
