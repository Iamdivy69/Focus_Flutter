import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/theme/widgets/animated_gradient_background.dart';
import '../../../core/theme/widgets/cyber_glass_card.dart';
import '../../../core/theme/widgets/cyber_gradient_button.dart';
import '../../../core/theme/widgets/neon_icon_badge.dart';

class PrivacyConsentScreen extends StatefulWidget {
  const PrivacyConsentScreen({super.key});

  @override
  State<PrivacyConsentScreen> createState() => _PrivacyConsentScreenState();
}

class _PrivacyConsentScreenState extends State<PrivacyConsentScreen> {
  bool _localMlConsent = true;
  bool _usageStatsConsent = true;
  bool _notificationConsent = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Privacy & Consent'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.go(AppRoutes.registration),
        ),
      ),
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const NeonIconBadge(
                        icon: Icons.verified_user_rounded,
                        color: CyberColors.neonGreen,
                        size: 68,
                        iconSize: 32,
                      ),
                      const SizedBox(height: 18),

                      Text(
                        'Your Data Stays Yours',
                        style: CyberTypography.headlineSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'FocusShield is built ground-up to protect your privacy. All app tracking, analytics, and focus score computations are performed locally on-device.',
                          style: CyberTypography.bodyMedium.copyWith(
                            color: CyberColors.onSurfaceVariant,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Consent tiles — flat matte, no glow on toggle
                      _buildConsentTile(
                        icon: Icons.psychology_rounded,
                        iconColor: CyberColors.neonGreen,
                        title: 'On-Device AI Engine',
                        description:
                            'Run our offline ML model to understand app usage patterns and automatically adjust your limits.',
                        value: _localMlConsent,
                        onChanged: (val) =>
                            setState(() => _localMlConsent = val),
                      ),
                      const SizedBox(height: 10),

                      _buildConsentTile(
                        icon: Icons.history_rounded,
                        iconColor: CyberColors.electricBlue,
                        title: 'Focus Stats & Logs',
                        description:
                            'Save local logs to show you analytics, score progress, and daily achievements.',
                        value: _usageStatsConsent,
                        onChanged: (val) =>
                            setState(() => _usageStatsConsent = val),
                      ),
                      const SizedBox(height: 10),

                      _buildConsentTile(
                        icon: Icons.chat_bubble_outline_rounded,
                        iconColor: CyberColors.electricBlue,
                        title: 'Arjuna AI Reminders',
                        description:
                            'Allow localized alerts and notifications from your focus coach to keep you accountable.',
                        value: _notificationConsent,
                        onChanged: (val) =>
                            setState(() => _notificationConsent = val),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom action
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  children: [
                    Text(
                      'By tapping Agree & Continue, you acknowledge the terms of the privacy policy and consent to local-only data processing.',
                      style: CyberTypography.bodySmall.copyWith(
                        color: CyberColors.onSurfaceMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 14),
                    CyberGradientButton(
                      label: 'Agree & Continue',
                      icon: Icons.check_circle_outline_rounded,
                      onPressed: () {
                        context.go(
                          AppRoutes.otpVerification,
                          extra: {
                            'phoneNumber': '+91 98765 43210',
                            'verificationId': 'dummy_id_123'
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConsentTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return CyberGlassCard(
      // Toggled: slightly brighter border — no glow
      borderColor: value ? iconColor : Colors.white,
      borderOpacity: value ? 0.18 : 0.06,
      padding: const EdgeInsets.all(16),
      // No glow passed — clean surface
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NeonIconBadge(
                            icon: icon,
                            color: value ? iconColor : CyberColors.onSurfaceMuted,
                            size: 40,
                            iconSize: 20,
                          ),const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: CyberTypography.titleSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: CyberTypography.bodySmall.copyWith(
                    color: CyberColors.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
