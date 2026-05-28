// ignore_for_file: unused_import
import 'package:isar/isar.dart';
part 'app_limit_schema.g.dart'; // Uncomment after build_runner

@collection
class AppLimitSchema {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String packageName;

  late String appName;
  late bool isMonitoringEnabled;
  late int baselineDailyMinutes;
  late int currentDailyLimit;
  late int reductionStepMinutes;
  late int minimumLimitMinutes;
  late int scheduleStartHour;
  late int scheduleEndHour;
  late bool isWhitelisted;
  late bool reductionPaused;
  late DateTime updatedAt;
}
