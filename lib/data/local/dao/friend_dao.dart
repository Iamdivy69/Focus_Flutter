import 'package:isar/isar.dart';
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
    return await _db.friendSchemas.filter().uidEqualTo(uid).findFirst();
  }

  Future<void> upsert(FriendSchema friend) async {
    await _db.writeTxn(() async { await _db.friendSchemas.put(friend); });
  }

  Future<void> upsertAll(List<FriendSchema> friends) async {
    await _db.writeTxn(() async { await _db.friendSchemas.putAll(friends); });
  }

  Future<void> delete(String uid) async {
    await _db.writeTxn(() async {
      await _db.friendSchemas.filter().uidEqualTo(uid).deleteAll();
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
