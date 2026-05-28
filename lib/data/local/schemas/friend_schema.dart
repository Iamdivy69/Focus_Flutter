// ignore_for_file: unused_import
import 'package:isar/isar.dart';
part 'friend_schema.g.dart'; // Uncomment after build_runner

@collection
class FriendSchema {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uid;

  late String username;
  late String displayName;
  String? profilePhotoUrl;
  late int currentStreak;
  late int focusLevel;
  late int xpPoints;

  /// PENDING / ACCEPTED / BLOCKED
  late String friendshipStatus;

  late DateTime addedAt;
}
