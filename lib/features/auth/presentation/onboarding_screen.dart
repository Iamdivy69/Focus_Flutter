import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/theme/widgets/animated_gradient_background.dart';
import '../../../core/theme/widgets/cyber_gradient_button.dart';
import '../../../core/theme/widgets/neon_icon_badge.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Consistent green identity — no multi-color accent chaos
  final List<_OnboardingPage> _pages = const [
    _OnboardingPage(
      icon: Icons.shield_rounded,
      iconColor: CyberColors.neonGreen,
      title: 'Take Back Your Focus',
      description:
          'FocusShield uses AI to understand your digital habits and gently guide you toward healthier screen time — one day at a time.',
    ),
    _OnboardingPage(
      icon: Icons.psychology_rounded,
      iconColor: CyberColors.neonGreen,
      title: 'AI That Learns You',
      description:
          'Our on-device ML model analyses your usage patterns and adapts app limits to your personal rhythm — no data ever leaves your phone.',
    ),
    _OnboardingPage(
      icon: Icons.lock_rounded,
      iconColor: CyberColors.neonGreen,
      title: 'Privacy First',
      description:
          'All processing happens on your device. We never read your messages, passwords, or screen content. Your data is yours.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOutCubic,
      );
    } else {
      context.go(AppRoutes.registration);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberColors.background,
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, top: 8),
                  child: TextButton(
                    onPressed: () => context.go(AppRoutes.registration),
                    child: Text(
                      'Skip',
                      style: CyberTypography.labelLarge.copyWith(
                        color: CyberColors.onSurfaceMuted,
                      ),
                    ),
                  ),
                ),
              ),

              // Pages
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Compact icon badge — no glow
                          NeonIconBadge(
                            icon: page.icon,
                            color: page.iconColor,
                            size: 72,
                            iconSize: 36,
                          ),
                          const SizedBox(height: 32),

                          // Title
                          Text(
                            page.title,
                            style: CyberTypography.headlineMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),

                          Text(
                            page.description,
                            style: CyberTypography.bodyMedium.copyWith(
                              color: CyberColors.onSurfaceVariant,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Page indicators — solid dots, no gradient/glow
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? CyberColors.neonGreen
                          : CyberColors.onSurfaceMuted.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // Next / Get Started button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: CyberGradientButton(
                  label: _currentPage == _pages.length - 1
                      ? 'Get Started'
                      : 'Continue',
                  icon: _currentPage == _pages.length - 1
                      ? Icons.arrow_forward_rounded
                      : Icons.arrow_forward_rounded,
                  onPressed: _onNext,
                ),
              ),

              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;

  const _OnboardingPage({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
  });
}
