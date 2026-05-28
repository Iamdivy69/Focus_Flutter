/// App-wide constants for FocusShield 2.0
class AppConstants {
  AppConstants._();

  // App info
  static const String appName = 'FocusShield';
  static const String appVersion = '2.0.0';

  // Firestore collections
  static const String usersCollection = 'users';
  static const String usernamesCollection = 'usernames';
  static const String friendshipsCollection = 'friendships';
  static const String friendStatsCollection = 'friend_stats';
  static const String leaderboardCollection = 'leaderboard';
  static const String usageLimitsCollection = 'usage_limits';

  // Firestore documents
  static const String weeklyLeaderboardDoc = 'weekly';

  // SharedPreferences / SecureStorage keys
  static const String sessionKey = 'session_data';
  static const String isarEncryptionKey = 'isar_encryption_key';
  static const String prominentDisclosureShownKey = 'prominent_disclosure_shown';
  static const String onboardingCompleteKey = 'onboarding_complete';

  // MethodChannel names
  static const String blockingChannel = 'com.focusshield/blocking';
  static const String usageStatsChannel = 'com.focusshield/usage_stats';
  static const String permissionsChannel = 'com.focusshield/permissions';
  static const String appInfoChannel = 'com.focusshield/app_info';
  static const String hardcoreOverlayChannel = 'com.focusshield/hardcore_overlay';
  static const String sessionStateChannel = 'com.focusshield/session_state';

  // Focus Score bands
  static const int scoreExcellentMin = 90;
  static const int scoreHealthyMin = 70;
  static const int scoreModerateMin = 50;
  static const int scoreAtRiskMin = 30;

  // XP thresholds per level (index = level - 1)
  static const List<int> xpThresholds = [
    0, 500, 1500, 3000, 6000, 10000, 16000, 25000, 40000, 60000,
  ];

  // Level titles
  static const List<String> levelTitles = [
    'Digital Novice',
    'Aware User',
    'Mindful Scroller',
    'Focus Seeker',
    'Attention Keeper',
    'Flow Finder',
    'Deep Worker',
    'Focus Warrior',
    'Digital Monk',
    'FocusMaster',
  ];

  // Timer presets (minutes)
  static const List<int> pomodoroPresets = [25, 45, 60, 90];

  // Arjuna AI rate limit
  static const int arjunaDailyLimit = 20;

  // Usage sync interval (minutes)
  static const int usageSyncIntervalMinutes = 60;

  // Dashboard refresh interval (seconds)
  static const int dashboardRefreshSeconds = 60;

  // Username validation
  static const int usernameMinLength = 3;
  static const int usernameMaxLength = 20;
  static const int displayNameMinLength = 2;
  static const int displayNameMaxLength = 40;
  static const int passwordMinLength = 8;
  static const int minAge = 13;
  static const int maxAge = 100;
  static const int minorAge = 18;

  // Debounce durations (ms)
  static const int usernameDebounceMs = 600;
  static const int searchDebounceMs = 500;

  // Block cooldown (seconds)
  static const int blockCooldownSeconds = 3;

  // Night usage window
  static const int nightStartHour = 22;
  static const int nightEndHour = 6;
  static const int morningStartHour = 6;
  static const int morningEndHour = 10;

  // Firebase Storage paths
  static const String avatarsStoragePath = 'avatars';
  static const String mlModelsStoragePath = 'ml_models';

  // ML model
  static const String mlModelAssetPath = 'assets/ml/focus_model.tflite';
  static const String mlModelRemoteConfigKey = 'ml_model_version';

  // Notification channel
  static const String notificationChannelId = 'focusshield_main';
  static const String notificationChannelName = 'FocusShield';

  // Privacy & legal
  static const String privacyPolicyUrl = 'https://focusshield.app/privacy';
  static const String termsOfServiceUrl = 'https://focusshield.app/terms';
}
