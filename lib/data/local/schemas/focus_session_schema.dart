// ignore_for_file: unused_import
import 'package:isar/isar.dart';
part 'focus_session_schema.g.dart'; // Uncomment after build_runner

@collection
class FocusSessionSchema {
  Id id = Isar.autoIncrement;

  late int durationMinutes;

  /// POMODORO / CUSTOM / HARDCORE / STOPWATCH
  late String mode;

  /// IN_PROGRESS / COMPLETED / BROKEN
  @Index()
  late String status;

  @Index()
  late DateTime startedAt;

  DateTime? endedAt;
  late bool penaltyApplied;
  late int xpEarned;

  /// JSON-encoded list of blocked package names
  late String blockedPackagesJson;
}
