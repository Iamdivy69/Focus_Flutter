import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/theme/widgets/cyber_glass_card.dart';
import '../data/blocking_channel.dart';

/// Developer dev tools section visible only in [kDebugMode].
/// Allows testing and triggering simulated app blocks.
class DevToolsSection extends ConsumerWidget {
  const DevToolsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!kDebugMode) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Developer DevTools',
            style: CyberTypography.titleMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          CyberGlassCard(
            borderColor: CyberColors.electricBlue,
            borderOpacity: 0.15,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bug_report_rounded, color: CyberColors.electricBlue),
                    const SizedBox(width: 8),
                    Text(
                      'Simulate Blocking Engine',
                      style: CyberTypography.titleSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Instantly simulate a limit check on a package. Setting a limit threshold of 0 minutes will force the Accessibility blocking engine to kick in when the package is next opened.',
                  style: CyberTypography.bodySmall.copyWith(
                    color: CyberColors.onSurfaceMuted,
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  children: [
                    _buildSimulationButton(
                      context,
                      label: 'Simulate Instagram Block (limit: 0m)',
                      packageName: 'com.instagram.android',
                    ),
                    const SizedBox(height: 10),
                    _buildSimulationButton(
                      context,
                      label: 'Simulate YouTube Block (limit: 0m)',
                      packageName: 'com.google.android.youtube',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimulationButton(
    BuildContext context, {
    required String label,
    required String packageName,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.flash_on_rounded, size: 16, color: Colors.white),
        label: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        style: ElevatedButton.styleFrom(
          backgroundColor: CyberColors.electricBlue.withOpacity(0.12),
          foregroundColor: CyberColors.electricBlue,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: CyberColors.electricBlue.withOpacity(0.3)),
          ),
        ),
        onPressed: () async {
          final exceeded = await BlockingChannel.instance.checkUsageLimit(packageName, 0);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(exceeded
                    ? 'Simulated Block: $packageName limit exceeded!'
                    : 'Block simulation sent to background service.'),
                backgroundColor: exceeded ? CyberColors.scoreCritical : CyberColors.neonGreen,
              ),
            );
          }
        },
      ),
    );
  }
}
