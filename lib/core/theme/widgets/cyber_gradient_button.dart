import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../color_palette.dart';
import '../typography.dart';

/// Premium solid CTA button with subtle press animation.
///
/// Default: solid green background, white text, no gradient, no glow.
/// Disabled: muted dark surface.
///
/// Usage:
/// ```dart
/// CyberGradientButton(
///   label: 'Get Started',
///   onPressed: () {},
/// )
/// ```
class CyberGradientButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final Gradient? gradient; // kept for API compat, ignored by default
  final double height;
  final bool fullWidth;

  const CyberGradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.gradient,
    this.height = 48,
    this.fullWidth = true,
  });

  @override
  State<CyberGradientButton> createState() => _CyberGradientButtonState();
}

class _CyberGradientButtonState extends State<CyberGradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _scaleController.forward();
      HapticFeedback.lightImpact();
    }
  }

  void _onTapUp(TapUpDetails details) {
    _scaleController.reverse();
  }

  void _onTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: isDisabled ? null : widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: widget.height,
          width: widget.fullWidth ? double.infinity : null,
          padding: widget.fullWidth
              ? null
              : const EdgeInsets.symmetric(horizontal: 28),
          decoration: BoxDecoration(
            // Flat solid green — no shadow, no gradient.
            color: isDisabled
                ? CyberColors.surfaceContainerHigh
                : CyberColors.neonGreen,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: widget.isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(
                          widget.icon,
                          color: isDisabled
                              ? CyberColors.onSurfaceMuted
                              : Colors.white,
                          size: 19,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        widget.label,
                        style: CyberTypography.labelLarge.copyWith(
                          color: isDisabled
                              ? CyberColors.onSurfaceMuted
                              : Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
