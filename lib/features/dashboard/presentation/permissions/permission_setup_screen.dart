import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/color_palette.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/theme/widgets/animated_gradient_background.dart';
import '../../../../core/theme/widgets/cyber_glass_card.dart';
import '../../../../core/theme/widgets/cyber_gradient_button.dart';
import '../../../../core/theme/widgets/neon_icon_badge.dart';

class PermissionSetupScreen extends StatefulWidget {
  const PermissionSetupScreen({super.key});

  @override
  State<PermissionSetupScreen> createState() => _PermissionSetupScreenState();
}

class _PermissionSetupScreenState extends State<PermissionSetupScreen> {
  bool _usageStatsGranted = false;
  bool _overlayGranted = false;
  bool _notificationGranted = false;

  bool _allPermissionsGranted() {
    return _usageStatsGranted && _overlayGranted && _notificationGranted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Setup Permissions'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.go(AppRoutes.otpVerification, extra: {
            'phoneNumber': '+91 98765 43210',
            'verificationId': 'dummy_id'
          }),
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
                        icon: Icons.security_rounded,
                        color: CyberColors.neonGreen,
                        size: 88,
                        iconSize: 40,
                      ),
                      const SizedBox(height: 20),

                      Text(
                        'Enable FocusShield Security',
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
                          'To protect your screen time, block addicting apps locally, and alert you of notifications, FocusShield requires three core system permissions.',
                          style: CyberTypography.bodyMedium.copyWith(
                            color: CyberColors.onSurfaceVariant,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 28),

                      _buildPermissionTile(
                        icon: Icons.bar_chart_rounded,
                        iconColor: CyberColors.neonGreen,
                        title: 'App Usage Statistics',
                        description:
                            'Required to read other apps\' usage durations and compute your focus score locally.',
                        isGranted: _usageStatsGranted,
                        onToggle: () =>
                            setState(() => _usageStatsGranted = !_usageStatsGranted),
                      ),
                      const SizedBox(height: 10),

                      _buildPermissionTile(
                        icon: Icons.picture_in_picture_alt_rounded,
                        iconColor: CyberColors.electricBlue,
                        title: 'Display Over Other Apps',
                        description:
                            'Required to display the locking screen block overlay when a restricted app is accessed.',
                        isGranted: _overlayGranted,
                        onToggle: () =>
                            setState(() => _overlayGranted = !_overlayGranted),
                      ),
                      const SizedBox(height: 10),

                      _buildPermissionTile(
                        icon: Icons.notifications_active_rounded,
                        iconColor: CyberColors.electricBlue,
                        title: 'Notification Listener',
                        description:
                            'Required to let your focus coach Arjuna send you timely reminders, streak status, and tips.',
                        isGranted: _notificationGranted,
                        onToggle: () =>
                            setState(() => _notificationGranted = !_notificationGranted),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom action
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: CyberGradientButton(
                  label: _allPermissionsGranted()
                      ? 'Go to Dashboard'
                      : 'Skip & Go to Dashboard',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () => context.go(AppRoutes.dashboard),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required bool isGranted,
    required VoidCallback onToggle,
  }) {
    return CyberGlassCard(
      // Granted: slightly brighter border, no glow
      borderColor: isGranted ? CyberColors.neonGreen : Colors.white,
      borderOpacity: isGranted ? 0.20 : 0.06,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NeonIconBadge(
            icon: icon,
            color: isGranted ? CyberColors.neonGreen : iconColor,
            size: 48,
            iconSize: 24,
          ),
          const SizedBox(width: 14),
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
          _EnableButton(
            isGranted: isGranted,
            onToggle: onToggle,
          ),
        ],
      ),
    );
  }
}

class _EnableButton extends StatefulWidget {
  final bool isGranted;
  final VoidCallback onToggle;

  const _EnableButton({required this.isGranted, required this.onToggle});

  @override
  State<_EnableButton> createState() => _EnableButtonState();
}

class _EnableButtonState extends State<_EnableButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onToggle();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            // Granted: flat green tint; Not granted: solid green CTA
            color: widget.isGranted
                ? CyberColors.neonGreen.withOpacity(0.12)
                : CyberColors.neonGreen,
            borderRadius: BorderRadius.circular(10),
            border: widget.isGranted
                ? Border.all(
                    color: CyberColors.neonGreen.withOpacity(0.25),
                  )
                : null,
          ),
          child: Text(
            widget.isGranted ? '✓ Enabled' : 'Enable',
            style: CyberTypography.labelMedium.copyWith(
              color: widget.isGranted
                  ? CyberColors.neonGreen
                  : Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
