import 'package:flutter/material.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/theme/widgets/animated_gradient_background.dart';

/// Profile Screen.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('Profile')),
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Clean avatar — flat circle, no glow
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CyberColors.neonGreen.withOpacity(0.10),
                    border: Border.all(
                      color: CyberColors.neonGreen.withOpacity(0.20),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: CyberColors.neonGreen,
                    size: 44,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Arjuna Dev',
                  style: CyberTypography.headlineSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '@arjuna_focus',
                  style: CyberTypography.bodyMedium.copyWith(
                    color: CyberColors.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 24),

                // Stats card — flat matte
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                    color: CyberColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.06)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const _ProfileStat(value: '87', label: 'Score'),
                      Container(width: 1, height: 36, color: Colors.white12),
                      const _ProfileStat(value: '12', label: 'Streak'),
                      Container(width: 1, height: 36, color: Colors.white12),
                      const _ProfileStat(value: '1.2K', label: 'XP'),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Settings list — flat matte items, no CyberGlassCard
                const _SettingsItem(icon: Icons.notifications_outlined, label: 'Notifications', color: CyberColors.neonGreen),
                const _SettingsItem(icon: Icons.shield_outlined, label: 'Privacy Settings', color: CyberColors.electricBlue),
                const _SettingsItem(icon: Icons.palette_outlined, label: 'Appearance', color: CyberColors.electricBlueBright),
                const _SettingsItem(icon: Icons.help_outline_rounded, label: 'Help & Support', color: CyberColors.scoreModerate),
                const _SettingsItem(icon: Icons.info_outline_rounded, label: 'About FocusShield', color: CyberColors.onSurfaceVariant),
                const _SettingsItem(icon: Icons.logout_rounded, label: 'Log Out', color: CyberColors.scoreCritical),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String value;
  final String label;

  const _ProfileStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: CyberTypography.statValue.copyWith(color: Colors.white, fontSize: 24),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: CyberTypography.statLabel.copyWith(color: CyberColors.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _SettingsItem({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: CyberColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: color.withOpacity(0.10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: CyberTypography.titleSmall.copyWith(color: Colors.white),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: CyberColors.onSurfaceMuted, size: 20),
          ],
        ),
      ),
    );
  }
}
