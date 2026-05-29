import 'focus_score_input.dart';
import 'focus_score_label.dart';
import 'focus_score_result.dart';

/// Pure, stateless calculator that applies the FocusShield scoring formula.
///
/// Formula (as specified):
/// ```
/// screenTimePenalty = min(100, (totalDistractingMinutes / dailyBudgetMinutes) * 60)
/// frequencyPenalty  = min(40,  (totalOpens - 10) * 1.5)
/// nightPenalty      = min(30,  nightUsageMinutes * 1.2)
/// streakBonus       = min(10,  currentStreak * 0.5)
/// reductionBonus    = min(10,  ((baselineLimit - currentLimit) / baselineLimit * 100) * 0.2)
///
/// score = 100 - (
///   0.35 * screenTimePenalty +
///   0.25 * frequencyPenalty  +
///   0.20 * nightPenalty      -
///   0.10 * streakBonus       -
///   0.10 * reductionBonus
/// )
///
/// Clamped to [0, 100]
/// ```
///
/// This class is intentionally side-effect free for testability.
class FocusScoreCalculator {
  const FocusScoreCalculator();

  // Default daily distraction budget when user hasn't configured one.
  static const int defaultDailyBudgetMinutes = 120;

  /// Computes a [FocusScoreResult] from the provided [input].
  FocusScoreResult compute(FocusScoreInput input) {
    // ─── Component calculation ─────────────────────────────────────────────

    final budget = input.dailyBudgetMinutes > 0
        ? input.dailyBudgetMinutes.toDouble()
        : defaultDailyBudgetMinutes.toDouble();

    // screenTimePenalty: min(100, (distracted / budget) * 60)
    final screenTimePenalty = _clamp(
      (input.totalDistractingMinutes / budget) * 60.0,
      0.0,
      100.0,
    );

    // frequencyPenalty: min(40, (opens - 10) * 1.5)
    // Note: negative if < 10 opens → treated as 0 (good behaviour)
    final rawFrequency = (input.totalOpens - 10) * 1.5;
    final frequencyPenalty = _clamp(rawFrequency, 0.0, 40.0);

    // nightPenalty: min(30, nightUsageMinutes * 1.2)
    final nightPenalty = _clamp(input.nightUsageMinutes * 1.2, 0.0, 30.0);

    // streakBonus: min(10, streak * 0.5)
    final streakBonus = _clamp(input.currentStreak * 0.5, 0.0, 10.0);

    // reductionBonus: min(10, ((baseline - current) / baseline * 100) * 0.2)
    final reductionBonus = input.baselineLimit > 0
        ? _clamp(
            ((input.baselineLimit - input.currentLimit) /
                    input.baselineLimit *
                    100.0) *
                0.2,
            0.0,
            10.0,
          )
        : 0.0;

    // ─── Final score ──────────────────────────────────────────────────────

    final rawScore = 100.0 -
        (0.35 * screenTimePenalty +
            0.25 * frequencyPenalty +
            0.20 * nightPenalty -
            0.10 * streakBonus -
            0.10 * reductionBonus);

    final finalScore = _clamp(rawScore, 0.0, 100.0).round();
    final label = FocusScoreLabel.fromScore(finalScore);

    return FocusScoreResult(
      score: finalScore,
      label: label,
      trend: 0, // trend is filled in by GetFocusScoreUseCase after comparing with yesterday
      screenTimePenalty: screenTimePenalty,
      frequencyPenalty: frequencyPenalty,
      nightPenalty: nightPenalty,
      streakBonus: streakBonus,
      reductionBonus: reductionBonus,
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  double _clamp(double value, double min, double max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }
}
