import 'package:flutter/material.dart';

/// Placeholder — full implementation in Phase 7, Prompt 18.
class SessionCompletedScreen extends StatelessWidget {
  final int xpEarned;
  final int durationMinutes;
  final bool streakUpdated;

  const SessionCompletedScreen({
    super.key,
    required this.xpEarned,
    required this.durationMinutes,
    required this.streakUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.celebration_rounded, size: 64, color: Colors.amber),
            const SizedBox(height: 16),
            Text('Session Complete!', style: Theme.of(context).textTheme.headlineMedium),
            Text('+$xpEarned XP earned'),
            Text('Duration: $durationMinutes min'),
            if (streakUpdated) const Text('🔥 Streak updated!'),
          ],
        ),
      ),
    );
  }
}
