// ignore_for_file: unused_import
import 'package:isar/isar.dart';
part 'block_event_schema.g.dart'; // Uncomment after build_runner

@collection
class BlockEventSchema {
  Id id = Isar.autoIncrement;

  @Index()
  late String packageName;

  late String reason;

  @Index()
  late DateTime blockedAt;

  late int durationOverLimit;
}
