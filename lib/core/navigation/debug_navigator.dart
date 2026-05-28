import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'app_router.dart';

/// A premium, interactive developer navigator that floats on top of the app,
/// allowing the user to seamlessly jump between all placeholder and feature screens.
/// Self-contained to avoid standard Flutter Overlay/Navigator context lookup issues.
class DebugNavigator extends StatefulWidget {
  final Widget child;

  const DebugNavigator({super.key, required this.child});

  @override
  State<DebugNavigator> createState() => _DebugNavigatorState();
}

class _DebugNavigatorState extends State<DebugNavigator> {
  bool _isMenuOpen = false;

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 12),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppColors.accent,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildScreenTile(
    BuildContext context, {
    required IconData icon,
    required String name,
    required String route,
    required String desc,
    Map<String, dynamic>? extra,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: AppColors.surfaceElevated.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.accent.withOpacity(0.15)),
      ),
      child: ListTile(
        dense: true,
        leading: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.accent, size: 18),
        ),
        title: Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        subtitle: Text(
          desc,
          style: const TextStyle(
            color: AppColors.onSurfaceMuted,
            fontSize: 10,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white30, size: 12),
        onTap: () {
          setState(() => _isMenuOpen = false); // Close the bottom sheet
          appRouter.go(route, extra: extra); // Navigate to target screen
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The active application page
        widget.child,

        // Dimmed overlay background when menu is active
        if (_isMenuOpen) ...[
          GestureDetector(
            onTap: () => setState(() => _isMenuOpen = false),
            child: Container(
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          // Custom Bottom Sheet layout sliding up
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SlideTransition(
              position: AlwaysStoppedAnimation(Offset.zero),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.70,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black87,
                      blurRadius: 25,
                      spreadRadius: 10,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    // Header Drag Handle
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.onSurfaceMuted.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    // Header Title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.explore_rounded, color: AppColors.accent, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'FocusShield Portal',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const Text(
                                  'Tap any screen to visit it instantly',
                                  style: TextStyle(
                                    color: AppColors.onSurfaceMuted,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded, color: Colors.white70, size: 20),
                            onPressed: () => setState(() => _isMenuOpen = false),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: Color(0xFF1E293B), height: 1),
                    // Screens List
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(20),
                        children: [
                          _buildSectionHeader('1. Onboarding & Authentication'),
                          _buildScreenTile(
                            context,
                            icon: Icons.hourglass_empty_rounded,
                            name: 'Splash Screen',
                            route: AppRoutes.splash,
                            desc: 'Initial loading screen & branding animation',
                          ),
                          _buildScreenTile(
                            context,
                            icon: Icons.style_rounded,
                            name: 'Onboarding Screen',
                            route: AppRoutes.onboarding,
                            desc: 'Swipable introduction & ML/privacy overview',
                          ),
                          _buildScreenTile(
                            context,
                            icon: Icons.person_add_rounded,
                            name: 'Registration Screen',
                            route: AppRoutes.registration,
                            desc: 'User creation & profile registration form',
                          ),
                          _buildScreenTile(
                            context,
                            icon: Icons.gavel_rounded,
                            name: 'Privacy & Consent Screen',
                            route: AppRoutes.privacyConsent,
                            desc: 'User agreement, data policy & usage permissions',
                          ),
                          _buildScreenTile(
                            context,
                            icon: Icons.sms_rounded,
                            name: 'OTP Verification Screen',
                            route: AppRoutes.otpVerification,
                            desc: 'Phone verification & code input interface',
                            extra: {'phoneNumber': '+91 98765 43210', 'verificationId': 'dummy_id'},
                          ),

                          _buildSectionHeader('2. Core App Dashboard & Settings'),
                          _buildScreenTile(
                            context,
                            icon: Icons.shield_rounded,
                            name: 'Main Dashboard',
                            route: AppRoutes.dashboard,
                            desc: 'Home base, statistics glance, & active controls',
                          ),
                          _buildScreenTile(
                            context,
                            icon: Icons.admin_panel_settings_rounded,
                            name: 'Permission Setup Screen',
                            route: AppRoutes.permissionSetup,
                            desc: 'OS usage, overlay, & accessibility grants',
                          ),

                          _buildSectionHeader('3. Focus & Blocking System'),
                          _buildScreenTile(
                            context,
                            icon: Icons.timer_outlined,
                            name: 'Focus Session Setup',
                            route: AppRoutes.timerSetup,
                            desc: 'Configure focus duration & select target tasks',
                          ),
                          _buildScreenTile(
                            context,
                            icon: Icons.alarm_on_rounded,
                            name: 'Active Timer Screen',
                            route: AppRoutes.timer,
                            desc: 'Minimalist countdown visualizer & statistics',
                          ),
                          _buildScreenTile(
                            context,
                            icon: Icons.military_tech_rounded,
                            name: 'Session Completed Screen',
                            route: AppRoutes.sessionCompleted,
                            desc: 'XP achievements, focus score updates, & streak milestones',
                            extra: {'xpEarned': 120, 'durationMinutes': 45, 'streakUpdated': true},
                          ),
                          _buildScreenTile(
                            context,
                            icon: Icons.block_flipped,
                            name: 'App Blocking Overlay Screen',
                            route: AppRoutes.blockScreen,
                            desc: 'Lockout overlay shown when blocked app is accessed',
                            extra: {
                              'packageName': 'com.instagram.android',
                              'blockReason': 'Social limit reached (45m/30m today)',
                              'usageMinutes': 45,
                              'limitMinutes': 30
                            },
                          ),

                          _buildSectionHeader('4. Analytics, Social & Profile'),
                          _buildScreenTile(
                            context,
                            icon: Icons.leaderboard_rounded,
                            name: 'Stats & Focus Scores',
                            route: AppRoutes.stats,
                            desc: 'Detailed metrics, app limits, and focus categories',
                          ),
                          _buildScreenTile(
                            context,
                            icon: Icons.trending_up_rounded,
                            name: 'Progress Trends',
                            route: AppRoutes.progress,
                            desc: 'Weekly historical progress curves & milestones',
                          ),
                          _buildScreenTile(
                            context,
                            icon: Icons.diversity_3_rounded,
                            name: 'Friends Hub & Streaks',
                            route: AppRoutes.friends,
                            desc: 'Add friends, review streaks, and check scoreboards',
                          ),
                          _buildScreenTile(
                            context,
                            icon: Icons.account_circle_rounded,
                            name: 'Profile Settings',
                            route: AppRoutes.profile,
                            desc: 'User statistics, goals, age restriction toggles, & preferences',
                          ),
                          _buildScreenTile(
                            context,
                            icon: Icons.forum_rounded,
                            name: 'Arjuna AI Coach Chat',
                            route: AppRoutes.arjunaChat,
                            desc: 'Interactive chat assistant for focus coaching & reminders',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],

        // Floating Action Button Overlay (Only when menu is closed)
        if (!_isMenuOpen)
          Positioned(
            bottom: 16,
            right: 16,
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.accent, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.4),
                      blurRadius: 16,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () => setState(() => _isMenuOpen = true),
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(
                        Icons.explore_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
