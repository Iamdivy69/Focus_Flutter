import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/blocking/blocking_providers.dart';
import '../color_palette.dart';
import '../typography.dart';
import 'cyber_glass_card.dart';

/// A card that shows missing permissions and provides deep links to enable them.
/// Auto-dismisses when all permissions are granted.
class PermissionHealthCard extends ConsumerStatefulWidget {
  const PermissionHealthCard({super.key});

  @override
  ConsumerState<PermissionHealthCard> createState() => _PermissionHealthCardState();
}

class _PermissionHealthCardState extends ConsumerState<PermissionHealthCard>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Recheck permissions when user returns to the app
      ref.invalidate(permissionHealthProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final healthAsync = ref.watch(permissionHealthProvider);

    return healthAsync.when(
      data: (health) {
        if (health.allGranted) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: CyberGlassCard(
            borderColor: CyberColors.scoreAtRisk,
            borderOpacity: 0.25,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: CyberColors.scoreAtRisk,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Action Required: Permissions Missing',
                      style: CyberTypography.titleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded, size: 20, color: CyberColors.onSurfaceMuted),
                      onPressed: () => ref.invalidate(permissionHealthProvider),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'FocusShield requires these permissions to enforce limits and track usage locally:',
                  style: CyberTypography.bodySmall.copyWith(
                    color: CyberColors.onSurfaceMuted,
                  ),
                ),
                const SizedBox(height: 14),
                if (!health.isUsageAccessGranted)
                  _buildPermissionRow(
                    context,
                    title: 'Usage Stats Access',
                    description: 'Required to measure application usage.',
                    onTap: () => ref.read(permissionsChannelProvider).openUsageAccessSettings(),
                  ),
                if (!health.isUsageAccessGranted && (!health.isAccessibilityEnabled || !health.isNotificationsGranted))
                  const Divider(color: Colors.white10, height: 16),
                if (!health.isAccessibilityEnabled)
                  _buildPermissionRow(
                    context,
                    title: 'Accessibility Service',
                    description: 'Required to block distracting apps.',
                    onTap: () => ref.read(permissionsChannelProvider).openAccessibilitySettings(),
                  ),
                if (!health.isAccessibilityEnabled && !health.isNotificationsGranted)
                  const Divider(color: Colors.white10, height: 16),
                if (!health.isNotificationsGranted)
                  _buildPermissionRow(
                    context,
                    title: 'Notifications Access',
                    description: 'Required to receive coach reminders.',
                    onTap: () async {
                      await ref.read(permissionsChannelProvider).requestNotificationsPermission();
                      ref.invalidate(permissionHealthProvider);
                    },
                  ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildPermissionRow(
    BuildContext context, {
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: CyberTypography.labelLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: CyberTypography.bodySmall.copyWith(
                  color: CyberColors.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: CyberColors.scoreAtRisk.withOpacity(0.12),
            foregroundColor: CyberColors.scoreAtRisk,
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: CyberColors.scoreAtRisk.withOpacity(0.3),
              ),
            ),
          ),
          child: Text(
            'Enable',
            style: CyberTypography.labelMedium.copyWith(
              color: CyberColors.scoreAtRisk,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
