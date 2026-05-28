import 'package:flutter/material.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/theme/widgets/animated_gradient_background.dart';
import '../../../core/theme/widgets/cyber_gradient_button.dart';
import '../../../core/theme/widgets/cyber_progress_ring.dart';

/// Friends Screen — Leaderboard and social features.
class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  static const _friends = [
    _FriendData('Maya Patel', '@maya_zen', 94, CyberColors.scoreExcellent),
    _FriendData('Rahul K.', '@rahul_dev', 87, CyberColors.scoreExcellent),
    _FriendData('Sara Ahmed', '@sara_focus', 72, CyberColors.scoreHealthy),
    _FriendData('Vikram S.', '@vik_s', 58, CyberColors.scoreModerate),
    _FriendData('Priya R.', '@priya_r', 45, CyberColors.scoreAtRisk),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('Friends')),
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Add friend button
                CyberGradientButton(
                  label: 'Add Friend',
                  icon: Icons.person_add_rounded,
                  onPressed: () {},
                  height: 48,
                ),

                const SizedBox(height: 28),

                Text(
                  'Leaderboard',
                  style: CyberTypography.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),

                // Friend cards — flat matte, top rank slightly differentiated
                ...List.generate(_friends.length, (index) {
                  final friend = _friends[index];
                  final rank = index + 1;
                  final isTopRank = index == 0;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: CyberColors.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          // Top rank: slightly brighter border — no glow
                          color: isTopRank
                              ? CyberColors.neonGreen.withOpacity(0.15)
                              : Colors.white.withOpacity(0.06),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Rank number
                          SizedBox(
                            width: 28,
                            child: Text(
                              '#$rank',
                              style: CyberTypography.labelLarge.copyWith(
                                color: isTopRank
                                    ? CyberColors.neonGreen
                                    : CyberColors.onSurfaceMuted,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Avatar
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: friend.color.withOpacity(0.10),
                              border: Border.all(
                                color: friend.color.withOpacity(0.20),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                friend.name[0],
                                style: CyberTypography.titleMedium.copyWith(
                                  color: friend.color,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          // Name & username
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  friend.name,
                                  style: CyberTypography.titleSmall.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  friend.username,
                                  style: CyberTypography.bodySmall.copyWith(
                                    color: CyberColors.onSurfaceMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Score mini ring — glow intentionally kept (it's a ring)
                          CyberProgressRing(
                            value: friend.score.toDouble(),
                            size: 42,
                            strokeWidth: 3.5,
                            center: Text(
                              '${friend.score}',
                              style: CyberTypography.labelSmall.copyWith(
                                color: friend.color,
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FriendData {
  final String name;
  final String username;
  final int score;
  final Color color;
  const _FriendData(this.name, this.username, this.score, this.color);
}
