/// Semantic label for a focus score value.
enum FocusScoreLabel {
  /// 90–100: Outstanding digital discipline.
  excellent,

  /// 70–89: Good habits, minor distractions.
  healthy,

  /// 50–69: Noticeable distraction impact.
  moderate,

  /// 30–49: Significant usage affecting productivity.
  atRisk,

  /// 0–29: Heavy usage with serious productivity impact.
  critical;

  /// Human-readable display string.
  String get displayName {
    switch (this) {
      case FocusScoreLabel.excellent: return 'Excellent';
      case FocusScoreLabel.healthy:   return 'Healthy';
      case FocusScoreLabel.moderate:  return 'Moderate';
      case FocusScoreLabel.atRisk:    return 'At Risk';
      case FocusScoreLabel.critical:  return 'Critical';
    }
  }

  /// Emoji prefix used in status chips.
  String get emoji {
    switch (this) {
      case FocusScoreLabel.excellent: return '🎯';
      case FocusScoreLabel.healthy:   return '✅';
      case FocusScoreLabel.moderate:  return '⚠️';
      case FocusScoreLabel.atRisk:    return '🔥';
      case FocusScoreLabel.critical:  return '🚨';
    }
  }

  /// Derives a label from a raw 0–100 score.
  static FocusScoreLabel fromScore(int score) {
    if (score >= 90) return FocusScoreLabel.excellent;
    if (score >= 70) return FocusScoreLabel.healthy;
    if (score >= 50) return FocusScoreLabel.moderate;
    if (score >= 30) return FocusScoreLabel.atRisk;
    return FocusScoreLabel.critical;
  }
}
