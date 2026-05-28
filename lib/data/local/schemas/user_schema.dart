// ignore_for_file: unused_import
// Run build_runner to generate user_schema.g.dart:
//   flutter pub add dev:isar_generator:^3.1.0+1
//   flutter pub run build_runner build --delete-conflicting-outputs

import 'package:isar/isar.dart';

part 'user_schema.g.dart'; // Uncomment after build_runner

@collection
class UserSchema {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uid;

  @Index(unique: true)
  late String username;

  late String displayName;
  late int age;
  late int xpPoints;
  late int focusLevel;
  late int currentStreak;
  late int longestStreak;
  late int totalFocusMinutes;
  late int totalSessions;
  late int totalTimeSaved;
  late DateTime createdAt;
  late DateTime lastActive;
  late bool isMinor;
  String? email;
  String? phone;
  String? profilePhotoUrl;
}
