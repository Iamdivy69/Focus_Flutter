import 'package:isar/isar.dart';
import '../isar_service.dart';
import '../schemas/block_event_schema.dart';

class BlockEventDao {
  Isar get _db => IsarService.instance.db;

  Future<List<BlockEventSchema>> getForDateRange(DateTime start, DateTime end) async {
    return await _db.blockEventSchemas.filter()
        .blockedAtBetween(start, end)
        .findAll();
  }

  Future<void> add(BlockEventSchema event) async {
    await _db.writeTxn(() async { await _db.blockEventSchemas.put(event); });
  }
}
