// ignore_for_file: unused_import
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:math';

import 'package:isar/isar.dart';
import 'schemas/user_schema.dart';
import 'schemas/usage_log_schema.dart';
import 'schemas/app_limit_schema.dart';
import 'schemas/block_event_schema.dart';
import 'schemas/focus_session_schema.dart';
import 'schemas/achievement_schema.dart';
import 'schemas/daily_streak_schema.dart';
import 'schemas/friend_schema.dart';
import 'schemas/focus_score_history_schema.dart';

/// Singleton service that manages the Isar local database.
class IsarService {
  IsarService._();
  static final IsarService instance = IsarService._();

  Isar? _isar;

  Isar get db {
    assert(_isar != null, 'IsarService not initialised. Call open() first.');
    return _isar!;
  }

  static const _encryptionKeyStorageKey = 'isar_encryption_key';
  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  /// Opens (or creates) the Isar database with an encrypted key.
  Future<void> open() async {
    if (_isar != null && _isar!.isOpen) return;
    final dir = await getApplicationDocumentsDirectory();
    // final encryptionKey = await _getOrCreateEncryptionKey();

    _isar = await Isar.open(
      [
        UserSchemaSchema,
        UsageLogSchemaSchema,
        AppLimitSchemaSchema,
        BlockEventSchemaSchema,
        FocusSessionSchemaSchema,
        AchievementSchemaSchema,
        DailyStreakSchemaSchema,
        FriendSchemaSchema,
        FocusScoreHistorySchemaSchema,
      ],
      directory: dir.path,
      // encryptionKey: encryptionKey,
      name: 'focusshield_db',
    );
    debugPrint('IsarService.open() — initialised successfully');
  }

  Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }

  // ---------------------------------------------------------------------------
  // Encryption key management
  // ---------------------------------------------------------------------------

  Future<String> _getOrCreateEncryptionKey() async {
    final existing = await _secureStorage.read(key: _encryptionKeyStorageKey);
    if (existing != null) return existing;

    final random = Random.secure();
    final keyBytes = List<int>.generate(32, (_) => random.nextInt(256));
    final key = base64UrlEncode(keyBytes);
    await _secureStorage.write(key: _encryptionKeyStorageKey, value: key);
    return key;
  }
}
