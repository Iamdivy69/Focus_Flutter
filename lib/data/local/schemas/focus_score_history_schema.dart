// ignore_for_file: unused_import
import 'package:isar/isar.dart';
part 'focus_score_history_schema.g.dart'; // Uncomment after build_runner

@collection
class FocusScoreHistorySchema {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late DateTime date;

  late int score;

  /// EXCELLENT / HEALTHY / MODERATE / AT_RISK / CRITICAL
  late String label;

  late double screenTimeFactor;
  late double frequencyFactor;
  late double nightUsageFactor;
  late double reductionProgressFactor;
  late DateTime recordedAt;
}
