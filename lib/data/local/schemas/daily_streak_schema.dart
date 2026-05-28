// ignore_for_file: unused_import
import 'package:isar/isar.dart';
part 'daily_streak_schema.g.dart'; // Uncomment after build_runner

@collection
class DailyStreakSchema {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late DateTime date;

  late int sessionsCompleted;
  late bool withinAllLimits;
  late int focusMinutes;
  late int focusScore;
}
