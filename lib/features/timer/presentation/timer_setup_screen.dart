import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/typography.dart';
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
  final _modeIcons = [
    Icons.psychology_rounded,
    Icons.timer_rounded,
    Icons.self_improvement_rounded,
  ];
  final _modeColors = [
    CyberColors.neonGreen,
    CyberColors.electricBlue,
    CyberColors.electricBlueBright,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('Focus Session')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Duration ─────────────────────────────────────────
              Text(
                'Duration',
                style: CyberTypography.titleSmall.copyWith(
                  color: CyberColors.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _durations.map((min) {
                  final isSelected = min == _selectedMinutes;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedMinutes = min),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? CyberColors.neonGreen
                            : CyberColors.surface,
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : Colors.white.withOpacity(0.08),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '$min',
                          style: CyberTypography.labelLarge.copyWith(
                            color: isSelected
                                ? Colors.white
                                : CyberColors.onSurfaceVariant,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  '$_selectedMinutes minutes',
                  style: CyberTypography.bodySmall.copyWith(
                    color: CyberColors.onSurfaceMuted,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ── Mode ─────────────────────────────────────────────
              Text(
                'Focus Mode',
                style: CyberTypography.titleSmall.copyWith(
                  color: CyberColors.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              ...List.generate(_modes.length, (index) {
                final isSelected = index == _selectedModeIndex;
                final color = _modeColors[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedModeIndex = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        // Selected: slightly lighter surface + colored border
                        color: isSelected
                            ? CyberColors.surfaceBright
                            : CyberColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? color.withOpacity(0.25)
                              : Colors.white.withOpacity(0.04),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color.withOpacity(0.10),
                            ),
                            child: Icon(
                              _modeIcons[index],
                              color: isSelected ? color : CyberColors.onSurfaceMuted,
                              size: 19,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              _modes[index],
                              style: CyberTypography.titleSmall.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : CyberColors.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: color.withOpacity(0.12),
                              ),
                              child: Icon(
                                Icons.check_rounded,
                                color: color,
                                size: 13,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              const Spacer(),

              // ── Start ─────────────────────────────────────────────
              CyberGradientButton(
                label: 'Start Focus Session',
                icon: Icons.play_arrow_rounded,
                onPressed: () => context.go(AppRoutes.timer),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
