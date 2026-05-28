// ignore_for_file: unused_import
import 'package:isar/isar.dart';
part 'achievement_schema.g.dart'; // Uncomment after build_runner

@collection
class AchievementSchema {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String achievementId;

  late String title;
  late String description;
  late int xpReward;
  late String iconName;
  late bool unlocked;
  DateTime? unlockedAt;
  late int progressCurrent;
  late int progressTarget;
}
