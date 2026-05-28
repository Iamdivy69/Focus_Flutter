// ignore_for_file: unused_import
import 'package:isar/isar.dart';
part 'usage_log_schema.g.dart'; // Uncomment after build_runner

@collection
class UsageLogSchema {
  Id id = Isar.autoIncrement;

  @Index(composite: [CompositeIndex('date')])
  late String packageName;

  late String appName;

  @Index()
  late DateTime date;

  late int totalMinutes;
  late int openCount;
  late int longestSessionMinutes;
  late int nightUsageMinutes;
  late int morningUsageMinutes;
  late DateTime recordedAt;
}
