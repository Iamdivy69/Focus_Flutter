# FocusShield 2.0

> AI-driven digital wellbeing app — Flutter + Firebase  
> Parul University Final Year Project

---

## Architecture

FocusShield follows **Clean Architecture** with a strict separation of concerns across three layers:

```
lib/
├── core/                        # App-wide infrastructure
│   ├── background/              # WorkManager task registration
│   ├── channels/                # Flutter ↔ Android MethodChannel wrappers
│   ├── constants/               # AppConstants (routes, keys, thresholds)
│   ├── di/                      # Riverpod providers (DI)
│   ├── errors/                  # Failure types + Result<T> sealed class
│   ├── navigation/              # GoRouter configuration + route names
│   ├── notifications/           # FCM + local notification service
│   ├── permissions/             # PermissionService (usage access, accessibility)
│   ├── session/                 # SessionService (FlutterSecureStorage)
│   ├── theme/                   # AppTheme + AppColors (Material 3, navy/blue)
│   └── utils/                   # DateUtils, Validators, Extensions
│
├── data/
│   ├── local/
│   │   ├── schemas/             # Isar collection classes (generated)
│   │   ├── dao/                 # Data Access Objects per schema
│   │   └── isar_service.dart    # Singleton Isar opener with encryption
│   ├── remote/
│   │   └── firebase_service.dart # Firestore CRUD wrapper
│   └── repositories/            # Repository implementations
│
├── domain/
│   ├── models/                  # Freezed domain models
│   └── usecases/                # Use case classes (one action each)
│
└── features/                    # Feature modules (vertical slices)
    ├── auth/                    # Registration, login, OTP, consent
    ├── dashboard/               # Home screen, permissions flow
    ├── blocking/                # Block screen UI
    ├── timer/                   # Focus timer, hardcore mode
    ├── stats/                   # Statistics & progress screens
    ├── friends/                 # Social layer, leaderboard
    ├── profile/                 # Profile, achievements, XP
    ├── notifications/           # Arjuna AI coach chat
    └── ml/                      # TFLite model, focus score engine
```

Each feature follows the same internal structure:
```
features/<name>/
├── domain/      # Models + repository interfaces + use cases
├── data/        # Repository implementations + data sources
└── presentation/ # Screens + Notifiers (Riverpod)
```

---

## Tech Stack

| Layer | Technology |
|---|---|
| UI | Flutter 3.x + Material 3 |
| State management | Riverpod 2 (AsyncNotifier / StateNotifier) |
| Navigation | GoRouter |
| Local DB | Isar (encrypted) |
| Remote DB | Firebase Firestore |
| Auth | Firebase Auth (email + phone OTP) |
| Storage | Firebase Storage |
| Push | Firebase Cloud Messaging |
| ML | TensorFlow Lite (tflite_flutter) |
| Background | WorkManager (workmanager package) |
| Security | FlutterSecureStorage + Firebase App Check |
| Charts | fl_chart |

---

## Build Phases

| Phase | Feature | Prompts |
|---|---|---|
| 0 | Scaffold & Architecture | 1–3 |
| 1 | Auth & User Profile | 4–6 |
| 2 | Dashboard & Permissions | 7–8 |
| 3 | ML Engine & Focus Score | 9–10 |
| 4 | Adaptive Blocking Engine | 11–12 |
| 5 | Progress Tracking & Stats | 13–14 |
| 6 | Friends & Social Layer | 15–16 |
| 7 | Focus Timer & Hardcore Mode | 17–18 |
| 8 | Gamification & Profile | 19–20 |
| 9 | Cloud Functions & Gemini | 21–22 |
| 10 | Background Tasks & Notifications | 23–24 |
| 11 | Security Hardening & Play Store | 25–26 |
| 12 | Testing Strategy | 27–28 |

---

## Getting Started

### Prerequisites
- Flutter 3.24+ (`flutter --version`)
- Android Studio / VS Code with Flutter extension
- Firebase project (see below)
- Java 17 (for Gradle compatibility)

### 1. Clone & install dependencies
```bash
git clone <repo-url>
cd focusshield
flutter pub get
```

### 2. Configure Firebase
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure (creates lib/firebase_options.dart)
flutterfire configure
```
Then uncomment the Firebase init lines in `lib/main.dart`.

### 3. Generate Isar code
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Run
```bash
flutter run
```

> **Note:** minSdk is 26 (Android 8.0+). UsageStatsManager and AccessibilityService  
> require a real device — emulators have limited support.

---

## Android Permissions

| Permission | Purpose |
|---|---|
| `PACKAGE_USAGE_STATS` | Read per-app screen time via UsageStatsManager |
| `BIND_ACCESSIBILITY_SERVICE` | Detect foreground app changes to trigger blocking |
| `POST_NOTIFICATIONS` | Achievement unlocks, streak warnings, nudges |
| `SYSTEM_ALERT_WINDOW` | Hardcore mode overlay |
| `FOREGROUND_SERVICE` | Keep hardcore overlay alive |
| `SCHEDULE_EXACT_ALARM` | Midnight WorkManager tasks |

---

## Key MethodChannels

| Channel | Direction | Purpose |
|---|---|---|
| `com.focusshield/blocking` | Flutter → Android | Start/stop block service, set modes |
| `com.focusshield/usage_stats` | Flutter → Android | Read UsageStatsManager data |
| `com.focusshield/permissions` | Flutter → Android | Check usage access & accessibility |
| `com.focusshield/app_info` | Flutter → Android | Get app name & icon |
| `com.focusshield/hardcore_overlay` | Flutter → Android | Launch/dismiss overlay |
| `com.focusshield/session_state` | Android → Flutter | Notify when app blocked/unblocked |

---

## Security Notes

- All local data encrypted via Isar encryption key stored in Keystore/Keychain
- `google-services.json` and `GoogleService-Info.plist` are in `.gitignore`
- Gemini API key is **never** in the Flutter app — proxied via Firebase Cloud Functions
- Firebase App Check enforced on all Cloud Functions
- `canRetrieveWindowContent="false"` in accessibility config (Play Store requirement)

---

## Release Keystore

```bash
keytool -genkey -v -keystore focusshield-release.jks \
  -alias focusshield -keyalg RSA -keysize 2048 -validity 10000
```
Store the keystore outside the repo. Reference it in `android/key.properties`.
