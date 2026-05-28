import 'package:flutter/material.dart';

/// Placeholder — full implementation in Phase 4, Prompt 12.
class BlockScreen extends StatelessWidget {
  final String packageName;
  final String blockReason;
  final int usageMinutes;
  final int limitMinutes;

  const BlockScreen({
    super.key,
    required this.packageName,
    required this.blockReason,
    required this.usageMinutes,
    required this.limitMinutes,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.block_rounded, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('App Blocked', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(packageName),
              Text('Reason: $blockReason'),
              Text('Usage: $usageMinutes / $limitMinutes min'),
              const SizedBox(height: 24),
              const Text('Block Screen — Phase 4'),
            ],
          ),
        ),
      ),
    );
  }
}
