import 'package:equatable/equatable.dart';

/// Input value object for the focus score formula.
///
/// All fields have safe defaults so the calculator never throws on missing data.
class FocusScoreInput extends Equatable {
  /// Total minutes spent on distracting apps today.
  final int totalDistractingMinutes;

  /// User's configured daily budget in minutes (default 120 = 2 hours).
  final int dailyBudgetMinutes;

  /// Total number of times distracting apps were opened today.
  final int totalOpens;

  /// Minutes used on distracting apps between 22:00 and 06:00.
  final int nightUsageMinutes;

  /// Current consecutive "good day" streak (days within all limits).
  final int currentStreak;

  /// The original baseline daily limit before gradual reduction started.
  /// Used to compute the reduction bonus.
  final int baselineLimit;

  /// The current active daily limit (may be lower than baseline).
  final int currentLimit;

  const FocusScoreInput({
    required this.totalDistractingMinutes,
    required this.dailyBudgetMinutes,
    required this.totalOpens,
    required this.nightUsageMinutes,
    required this.currentStreak,
    required this.baselineLimit,
    required this.currentLimit,
  });

  /// Safe default used when no usage data is available yet.
  factory FocusScoreInput.empty() {
    return const FocusScoreInput(
      totalDistractingMinutes: 0,
      dailyBudgetMinutes: 120,
      totalOpens: 0,
      nightUsageMinutes: 0,
      currentStreak: 0,
      baselineLimit: 120,
      currentLimit: 120,
    );
  }

  @override
  List<Object?> get props => [
        totalDistractingMinutes,
        dailyBudgetMinutes,
        totalOpens,
        nightUsageMinutes,
        currentStreak,
        baselineLimit,
        currentLimit,
      ];

  @override
  String toString() => 'FocusScoreInput('
      'distracting=${totalDistractingMinutes}min, '
      'budget=${dailyBudgetMinutes}min, '
      'opens=$totalOpens, '
      'night=${nightUsageMinutes}min, '
      'streak=$currentStreak)';
}
