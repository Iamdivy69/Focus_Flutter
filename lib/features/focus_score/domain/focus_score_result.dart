import 'package:equatable/equatable.dart';
import 'focus_score_label.dart';

/// Result of the focus score calculation.
///
/// Includes the final clamped score, semantic label, trend delta vs yesterday,
/// and all intermediate penalty/bonus components for transparency.
class FocusScoreResult extends Equatable {
  /// Final focus score: 0–100 (clamped).
  final int score;

  /// Semantic band label derived from the score.
  final FocusScoreLabel label;

  /// Score delta vs yesterday (positive = improvement).
  final int trend;

  // ─── Component values (for debugging / insights UI) ────────────────────────

  /// Screen time penalty component (0–100, raw before weighting).
  final double screenTimePenalty;

  /// Frequency/open-count penalty component (0–40, raw before weighting).
  final double frequencyPenalty;

  /// Night usage penalty component (0–30, raw before weighting).
  final double nightPenalty;

  /// Streak bonus component (0–10, raw before weighting).
  final double streakBonus;

  /// Usage reduction bonus component (0–10, raw before weighting).
  final double reductionBonus;

  const FocusScoreResult({
    required this.score,
    required this.label,
    required this.trend,
    required this.screenTimePenalty,
    required this.frequencyPenalty,
    required this.nightPenalty,
    required this.streakBonus,
    required this.reductionBonus,
  });

  /// A clean 100-score result used as the initial/empty state.
  factory FocusScoreResult.perfect() {
    return const FocusScoreResult(
      score: 100,
      label: FocusScoreLabel.excellent,
      trend: 0,
      screenTimePenalty: 0,
      frequencyPenalty: 0,
      nightPenalty: 0,
      streakBonus: 0,
      reductionBonus: 0,
    );
  }

  @override
  List<Object?> get props => [score, label, trend];

  @override
  String toString() => 'FocusScoreResult(score=$score, label=$label, trend=$trend)';
}
