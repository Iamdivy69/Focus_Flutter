import 'package:isar/isar.dart';
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
