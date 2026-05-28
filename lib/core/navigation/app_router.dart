import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Placeholder screen imports — will be replaced as features are built
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/auth/presentation/onboarding_screen.dart';
import '../../features/auth/presentation/registration_screen.dart';
import '../../features/auth/presentation/privacy_consent_screen.dart';
import '../../features/auth/presentation/otp_verification_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/dashboard/presentation/permissions/permission_setup_screen.dart';
import '../../features/blocking/presentation/block_screen.dart';
import '../../features/timer/presentation/timer_setup_screen.dart';
import '../../features/timer/presentation/timer_screen.dart';
import '../../features/timer/presentation/session_completed_screen.dart';
import '../../features/stats/presentation/stats_screen.dart';
import '../../features/stats/presentation/progress_screen.dart';
import '../../features/friends/presentation/friends_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/notifications/presentation/arjuna_chat_screen.dart';

/// Named route constants
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String registration = '/registration';
  static const String privacyConsent = '/privacy-consent';
  static const String otpVerification = '/otp-verification';
  static const String permissionSetup = '/permission-setup';
  static const String dashboard = '/dashboard';
  static const String blockScreen = '/block-screen';
  static const String timerSetup = '/timer-setup';
  static const String timer = '/timer';
  static const String sessionCompleted = '/session-completed';
  static const String stats = '/stats';
  static const String progress = '/progress';
  static const String friends = '/friends';
  static const String profile = '/profile';
  static const String arjunaChat = '/arjuna-chat';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.registration,
      name: 'registration',
      builder: (context, state) => const RegistrationScreen(),
    ),
    GoRoute(
      path: AppRoutes.privacyConsent,
      name: 'privacyConsent',
      builder: (context, state) => const PrivacyConsentScreen(),
    ),
    GoRoute(
      path: AppRoutes.otpVerification,
      name: 'otpVerification',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return OtpVerificationScreen(
          verificationId: extra?['verificationId'] as String? ?? '',
          phoneNumber: extra?['phoneNumber'] as String? ?? '',
        );
      },
    ),
    GoRoute(
      path: AppRoutes.permissionSetup,
      name: 'permissionSetup',
      builder: (context, state) => const PermissionSetupScreen(),
    ),
    GoRoute(
      path: AppRoutes.dashboard,
      name: 'dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: AppRoutes.blockScreen,
      name: 'blockScreen',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return BlockScreen(
          packageName: extra?['packageName'] as String? ?? '',
          blockReason: extra?['blockReason'] as String? ?? '',
          usageMinutes: extra?['usageMinutes'] as int? ?? 0,
          limitMinutes: extra?['limitMinutes'] as int? ?? 0,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.timerSetup,
      name: 'timerSetup',
      builder: (context, state) => const TimerSetupScreen(),
    ),
    GoRoute(
      path: AppRoutes.timer,
      name: 'timer',
      builder: (context, state) => const TimerScreen(),
    ),
    GoRoute(
      path: AppRoutes.sessionCompleted,
      name: 'sessionCompleted',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return SessionCompletedScreen(
          xpEarned: extra?['xpEarned'] as int? ?? 0,
          durationMinutes: extra?['durationMinutes'] as int? ?? 0,
          streakUpdated: extra?['streakUpdated'] as bool? ?? false,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.stats,
      name: 'stats',
      builder: (context, state) => const StatsScreen(),
    ),
    GoRoute(
      path: AppRoutes.progress,
      name: 'progress',
      builder: (context, state) => const ProgressScreen(),
    ),
    GoRoute(
      path: AppRoutes.friends,
      name: 'friends',
      builder: (context, state) => const FriendsScreen(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.arjunaChat,
      name: 'arjunaChat',
      builder: (context, state) => const ArjunaChatScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text(
        'Page not found: ${state.uri}',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    ),
  ),
);
