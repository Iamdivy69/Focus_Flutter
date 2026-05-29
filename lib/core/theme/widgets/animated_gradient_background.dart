import 'package:flutter/material.dart';

/// No-op background wrapper — previously rendered aurora blobs.
/// Now a pure transparent passthrough. All screens set their own
/// backgroundColor on Scaffold. This class is kept for API compatibility.
class AnimatedGradientBackground extends StatelessWidget {
  final Widget child;

  /// Ignored — kept for backwards compatibility only.
  final bool showAurora;

  const AnimatedGradientBackground({
    super.key,
    required this.child,
    this.showAurora = false,
  });

  @override
  Widget build(BuildContext context) => child;
}
