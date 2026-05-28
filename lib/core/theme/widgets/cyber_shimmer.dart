import 'package:flutter/material.dart';
import '../color_palette.dart';

/// Neutral shimmer loading placeholder.
///
/// Uses a subtle light-sweep on dark surfaces — no neon tint.
class CyberShimmer extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final ShimmerShape shape;

  const CyberShimmer({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = 8,
    this.shape = ShimmerShape.rectangle,
  });

  const CyberShimmer.circle({
    super.key,
    required double size,
  })  : width = size,
        height = size,
        borderRadius = 1000,
        shape = ShimmerShape.circle;

  const CyberShimmer.card({
    super.key,
    this.width = double.infinity,
    this.height = 120,
  })  : borderRadius = 20,
        shape = ShimmerShape.rectangle;

  @override
  State<CyberShimmer> createState() => _CyberShimmerState();
}

class _CyberShimmerState extends State<CyberShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.shape == ShimmerShape.circle
                ? null
                : BorderRadius.circular(widget.borderRadius),
            shape: widget.shape == ShimmerShape.circle
                ? BoxShape.circle
                : BoxShape.rectangle,
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2.0 * _controller.value, 0),
              end: Alignment(-0.5 + 2.0 * _controller.value, 0),
              colors: [
                CyberColors.surfaceContainerHigh,
                CyberColors.surfaceContainerHighest,
                // Neutral highlight — no green tint
                Colors.white.withOpacity(0.04),
                CyberColors.surfaceContainerHighest,
                CyberColors.surfaceContainerHigh,
              ],
              stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
            ),
          ),
        );
      },
    );
  }
}

enum ShimmerShape { rectangle, circle }
