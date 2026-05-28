import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/typography.dart';
import '../../../core/theme/widgets/animated_gradient_background.dart';
import '../../../core/theme/widgets/cyber_glass_card.dart';
import '../../../core/theme/widgets/cyber_gradient_button.dart';

/// Timer Setup Screen — Configure focus session.
class TimerSetupScreen extends StatefulWidget {
  const TimerSetupScreen({super.key});

  @override
  State<TimerSetupScreen> createState() => _TimerSetupScreenState();
}

class _TimerSetupScreenState extends State<TimerSetupScreen> {
  int _selectedMinutes = 25;
  int _selectedModeIndex = 0;

  final _durations = [15, 25, 45, 60, 90];
  final _modes = ['Deep Focus', 'Pomodoro', 'Zen Mode'];
  final _modeIcons = [Icons.psychology_rounded, Icons.timer_rounded, Icons.self_improvement_rounded];
  final _modeColors = [CyberColors.neonGreen, CyberColors.electricBlueBright, CyberColors.cyan];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('Start Focus Session')),
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Duration selector
                Text('Duration', style: CyberTypography.titleMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _durations.map((min) {
                    final isSelected = min == _selectedMinutes;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedMinutes = min),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: isSelected ? CyberColors.buttonGradient : null,
                          color: isSelected ? null : CyberColors.surfaceContainerHigh.withOpacity(0.5),
                          border: Border.all(
                            color: isSelected ? Colors.transparent : CyberColors.outlineVariant,
                          ),
                          boxShadow: isSelected ? [BoxShadow(color: CyberColors.neonGreen.withOpacity(0.3), blurRadius: 16)] : null,
                        ),
                        child: Center(
                          child: Text(
                            '$min',
                            style: CyberTypography.labelLarge.copyWith(
                              color: isSelected ? CyberColors.onNeonGreen : CyberColors.onSurfaceVariant,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    '$_selectedMinutes minutes',
                    style: CyberTypography.bodySmall.copyWith(color: CyberColors.onSurfaceVariant),
                  ),
                ),

                const SizedBox(height: 32),

                // Mode selector
                Text('Focus Mode', style: CyberTypography.titleMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),
                ...List.generate(_modes.length, (index) {
                  final isSelected = index == _selectedModeIndex;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedModeIndex = index),
                      child: CyberGlassCard(
                        borderColor: isSelected ? _modeColors[index] : CyberColors.outlineVariant,
                        borderOpacity: isSelected ? 0.3 : 0.08,
                        backgroundOpacity: isSelected ? 0.5 : 0.3,
                        padding: const EdgeInsets.all(16),
                        glow: isSelected ? [BoxShadow(color: _modeColors[index].withOpacity(0.1), blurRadius: 20)] : null,
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _modeColors[index].withOpacity(0.12),
                              ),
                              child: Icon(_modeIcons[index], color: _modeColors[index], size: 22),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                _modes[index],
                                style: CyberTypography.titleSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                              ),
                            ),
                            if (isSelected)
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _modeColors[index].withOpacity(0.15),
                                ),
                                child: Icon(Icons.check_rounded, color: _modeColors[index], size: 16),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                const Spacer(),

                // Start button
                CyberGradientButton(
                  label: 'Start Focus Session',
                  icon: Icons.play_arrow_rounded,
                  // Navigate to nested timer route within this branch
                  onPressed: () => context.go(AppRoutes.timer),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
