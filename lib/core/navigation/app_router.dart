import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/splash_screen.dart';
import '../../features/auth/presentation/onboarding_screen.dart';
import '../../features/auth/presentation/registration_screen.dart';
import '../../features/auth/presentation/privacy_consent_screen.dart';
import '../../features/auth/presentation/otp_verification_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/dashboard/presentation/permissions/permission_setup_screen.dart';
import '../../features/blocking/presentation/block_screen.dart';
import '../../features/blocking/presentation/app_limits_screen.dart';
import '../../features/timer/presentation/timer_setup_screen.dart';
import '../../features/timer/presentation/timer_screen.dart';
import '../../features/timer/presentation/session_completed_screen.dart';
import '../../features/stats/presentation/stats_screen.dart';
import '../../features/stats/presentation/progress_screen.dart';
import '../../features/friends/presentation/friends_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/notifications/presentation/arjuna_chat_screen.dart';
import '../theme/widgets/cyber_bottom_nav.dart';

// ─── Transition helper ─────────────────────────────────────────

/// Smooth fade + slide page transition for all routes.
CustomTransitionPage<void> _buildPage(Widget child, GoRouterState state) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 280),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final fade = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: fade,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.04, 0),
            end: Offset.zero,
          ).animate(fade),
          child: child,
        ),
      );
    },
  );
}

// ─── Route name constants ──────────────────────────────────────

class AppRoutes {
  AppRoutes._();

  // Auth flow (no shell)
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String registration = '/registration';
  static const String privacyConsent = '/privacy-consent';
  static const String otpVerification = '/otp-verification';
  static const String permissionSetup = '/permission-setup';

  // Shell root paths — first path of each branch
  static const String dashboard = '/dashboard';
  static const String stats = '/stats';
  static const String timerSetup = '/timer-setup';
  static const String friends = '/friends';
  static const String profile = '/profile';

  // Sub-routes within shell branches
  static const String progress = '/stats/progress';
  static const String timer = '/timer-setup/timer';
  static const String sessionCompleted = '/timer-setup/session-completed';
  static const String arjunaChat = '/dashboard/arjuna-chat';
  static const String appLimits = '/dashboard/app-limits';

  // Full-screen overlays (no shell)
  static const String blockScreen = '/block-screen';
}

// ─── Navigator keys for each shell branch ─────────────────────
final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _dashboardNavKey = GlobalKey<NavigatorState>(debugLabel: 'dashboard');
final _statsNavKey = GlobalKey<NavigatorState>(debugLabel: 'stats');
final _timerNavKey = GlobalKey<NavigatorState>(debugLabel: 'timer');
final _friendsNavKey = GlobalKey<NavigatorState>(debugLabel: 'friends');
final _profileNavKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

// ─── Router ───────────────────────────────────────────────────

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: false,
  routes: [
    // ── Auth Flow (no nav bar) ─────────────────────────────────
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      pageBuilder: (context, state) => _buildPage(const SplashScreen(), state),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      name: 'onboarding',
      pageBuilder: (context, state) =>
          _buildPage(const OnboardingScreen(), state),
    ),
    GoRoute(
      path: AppRoutes.registration,
      name: 'registration',
      pageBuilder: (context, state) =>
          _buildPage(const RegistrationScreen(), state),
    ),
    GoRoute(
      path: AppRoutes.privacyConsent,
      name: 'privacyConsent',
      pageBuilder: (context, state) =>
          _buildPage(const PrivacyConsentScreen(), state),
    ),
    GoRoute(
      path: AppRoutes.otpVerification,
      name: 'otpVerification',
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return _buildPage(
          OtpVerificationScreen(
            verificationId: extra?['verificationId'] as String? ?? '',
            phoneNumber: extra?['phoneNumber'] as String? ?? '',
          ),
          state,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.permissionSetup,
      name: 'permissionSetup',
      pageBuilder: (context, state) =>
          _buildPage(const PermissionSetupScreen(), state),
    ),

    // ── Full-screen overlays (no nav bar) ─────────────────────
    GoRoute(
      path: AppRoutes.blockScreen,
      name: 'blockScreen',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return _buildPage(
          BlockScreen(
            packageName: extra?['packageName'] as String? ?? '',
            blockReason: extra?['blockReason'] as String? ?? '',
            usageMinutes: extra?['usageMinutes'] as int? ?? 0,
            limitMinutes: extra?['limitMinutes'] as int? ?? 0,
          ),
          state,
        );
      },
    ),

    // ── Main Shell with persistent bottom nav ─────────────────
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return _AppShell(navigationShell: navigationShell);
      },
      branches: [
        // Branch 0 — Home / Dashboard
        StatefulShellBranch(
          navigatorKey: _dashboardNavKey,
          routes: [
            GoRoute(
              path: AppRoutes.dashboard,
              name: 'dashboard',
              pageBuilder: (context, state) =>
                  _buildPage(const DashboardScreen(), state),
              routes: [
                // Arjuna AI chat — full screen but stays within dashboard branch
                GoRoute(
                  path: 'arjuna-chat',
                  name: 'arjunaChat',
                  pageBuilder: (context, state) =>
                      _buildPage(const ArjunaChatScreen(), state),
                ),
                GoRoute(
                  path: 'app-limits',
                  name: 'appLimits',
                  pageBuilder: (context, state) =>
                      _buildPage(const AppLimitsScreen(), state),
                ),
              ],
            ),
          ],
        ),

        // Branch 1 — Stats
        StatefulShellBranch(
          navigatorKey: _statsNavKey,
          routes: [
            GoRoute(
              path: AppRoutes.stats,
              name: 'stats',
              pageBuilder: (context, state) =>
                  _buildPage(const StatsScreen(), state),
              routes: [
                GoRoute(
                  path: 'progress',
                  name: 'progress',
                  pageBuilder: (context, state) =>
                      _buildPage(const ProgressScreen(), state),
                ),
              ],
            ),
          ],
        ),

        // Branch 2 — Focus Timer
        StatefulShellBranch(
          navigatorKey: _timerNavKey,
          routes: [
            GoRoute(
              path: AppRoutes.timerSetup,
              name: 'timerSetup',
              pageBuilder: (context, state) =>
                  _buildPage(const TimerSetupScreen(), state),
              routes: [
                GoRoute(
                  path: 'timer',
                  name: 'timer',
                  pageBuilder: (context, state) =>
                      _buildPage(const TimerScreen(), state),
                ),
                GoRoute(
                  path: 'session-completed',
                  name: 'sessionCompleted',
                  pageBuilder: (context, state) {
                    final extra = state.extra as Map<String, dynamic>?;
                    return _buildPage(
                      SessionCompletedScreen(
                        xpEarned: extra?['xpEarned'] as int? ?? 0,
                        durationMinutes:
                            extra?['durationMinutes'] as int? ?? 0,
                        streakUpdated:
                            extra?['streakUpdated'] as bool? ?? false,
                      ),
                      state,
                    );
                  },
                ),
              ],
            ),
          ],
        ),

        // Branch 3 — Friends
        StatefulShellBranch(
          navigatorKey: _friendsNavKey,
          routes: [
            GoRoute(
              path: AppRoutes.friends,
              name: 'friends',
              pageBuilder: (context, state) =>
                  _buildPage(const FriendsScreen(), state),
            ),
          ],
        ),

        // Branch 4 — Profile
        StatefulShellBranch(
          navigatorKey: _profileNavKey,
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              name: 'profile',
              pageBuilder: (context, state) =>
                  _buildPage(const ProfileScreen(), state),
            ),
          ],
        ),
      ],
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

// ─── Shell Widget ─────────────────────────────────────────────

/// Persistent shell that holds the bottom nav bar across all main tabs.
/// Uses [StatefulNavigationShell] so each branch preserves its own stack.
class _AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const _AppShell({required this.navigationShell});

  void _onNavTap(int index) {
    navigationShell.goBranch(
      index,
      // If tapping the current tab, pop to its root
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B14),
      extendBody: true, // content goes under the floating nav
      body: navigationShell,
      bottomNavigationBar: CyberBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
