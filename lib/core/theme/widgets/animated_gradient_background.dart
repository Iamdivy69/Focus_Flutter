import 'package:flutter/material.dart';
import '../color_palette.dart';

/// Clean matte background widget.
///
/// Provides a deep dark surface. The `showAurora` flag is kept for
/// API compatibility but is now a no-op — decorative blobs removed.
class AnimatedGradientBackground extends StatelessWidget {
  final Widget child;
  // ignore: avoid_field_initializers_in_const_classes
  final bool showAurora; // kept for API compat — no longer does anything

  const AnimatedGradientBackground({
    super.key,
    required this.child,
    this.showAurora = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CyberColors.background,
      child: child,
    );
  }
}
