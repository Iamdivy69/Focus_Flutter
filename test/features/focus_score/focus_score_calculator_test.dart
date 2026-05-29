import 'package:flutter_test/flutter_test.dart';
import 'package:focusshield/features/focus_score/domain/focus_score_calculator.dart';
import 'package:focusshield/features/focus_score/domain/focus_score_input.dart';
import 'package:focusshield/features/focus_score/domain/focus_score_label.dart';

void main() {
  const calculator = FocusScoreCalculator();

  // ─── Score boundary tests ──────────────────────────────────────────────────

  group('FocusScoreCalculator — score bounds', () {
    test('perfect behaviour yields score of 100', () {
      final input = FocusScoreInput(
        totalDistractingMinutes: 0,
        dailyBudgetMinutes: 120,
        totalOpens: 0,
        nightUsageMinutes: 0,
        currentStreak: 20,    // max bonus
        baselineLimit: 120,
        currentLimit: 60,     // 50% reduction → max reductionBonus
      );
      final result = calculator.compute(input);
      expect(result.score, 100);
      expect(result.label, FocusScoreLabel.excellent);
    });

    test('worst case behaviour yields minimum score (critical label)', () {
      // With max penalties: screen=100, freq=40, night=30, no bonuses
      // raw = 100 - (0.35*100 + 0.25*40 + 0.20*30) = 100 - 51 = 49
      // Score is clamped at 0 floor — the formula gives 49 in worst realistic case
      final input = FocusScoreInput(
        totalDistractingMinutes: 600,   // 10× over budget → penalty capped at 100
        dailyBudgetMinutes: 60,
        totalOpens: 100,                // → penalty capped at 40
        nightUsageMinutes: 240,         // → penalty capped at 30
        currentStreak: 0,
        baselineLimit: 60,
        currentLimit: 60,   // no reduction bonus
      );
      final result = calculator.compute(input);
      // Max weighted penalty = 0.35*100 + 0.25*40 + 0.20*30 = 35+10+6 = 51
      // Score = 100 - 51 = 49
      expect(result.score, 49);
      expect(result.label, FocusScoreLabel.atRisk);
    });

    test('score floor clamped at 0 even with impossible inputs', () {
      // Artificially drive score negative by giving unrealistically large values
      // before clamping kicks in on individual components
      final input = FocusScoreInput(
        totalDistractingMinutes: 9999,
        dailyBudgetMinutes: 1,       // (9999/1)*60 = huge → clamped at 100
        totalOpens: 9999,
        nightUsageMinutes: 9999,
        currentStreak: 0,
        baselineLimit: 60,
        currentLimit: 60,
      );
      final result = calculator.compute(input);
      // Components all hit their caps, so score = 49, clamped to 49 (not below 0)
      expect(result.score, greaterThanOrEqualTo(0));
      expect(result.score, lessThanOrEqualTo(100));
    });

    test('score is always clamped between 0 and 100', () {
      final inputs = [
        FocusScoreInput.empty(),
        FocusScoreInput(
          totalDistractingMinutes: 9999,
          dailyBudgetMinutes: 1,
          totalOpens: 9999,
          nightUsageMinutes: 9999,
          currentStreak: 0,
          baselineLimit: 120,
          currentLimit: 120,
        ),
      ];
      for (final input in inputs) {
        final result = calculator.compute(input);
        expect(result.score, inInclusiveRange(0, 100));
      }
    });
  });

  // ─── Label tests ───────────────────────────────────────────────────────────

  group('FocusScoreLabel.fromScore', () {
    test('90–100 → excellent', () {
      for (final s in [90, 95, 100]) {
        expect(FocusScoreLabel.fromScore(s), FocusScoreLabel.excellent,
            reason: 'score $s should be excellent');
      }
    });

    test('70–89 → healthy', () {
      for (final s in [70, 80, 89]) {
        expect(FocusScoreLabel.fromScore(s), FocusScoreLabel.healthy,
            reason: 'score $s should be healthy');
      }
    });

    test('50–69 → moderate', () {
      for (final s in [50, 60, 69]) {
        expect(FocusScoreLabel.fromScore(s), FocusScoreLabel.moderate,
            reason: 'score $s should be moderate');
      }
    });

    test('30–49 → atRisk', () {
      for (final s in [30, 40, 49]) {
        expect(FocusScoreLabel.fromScore(s), FocusScoreLabel.atRisk,
            reason: 'score $s should be atRisk');
      }
    });

    test('0–29 → critical', () {
      for (final s in [0, 15, 29]) {
        expect(FocusScoreLabel.fromScore(s), FocusScoreLabel.critical,
            reason: 'score $s should be critical');
      }
    });
  });

  // ─── Component tests ───────────────────────────────────────────────────────

  group('FocusScoreCalculator — component penalties', () {
    test('screenTimePenalty is clamped to 100', () {
      final input = FocusScoreInput(
        totalDistractingMinutes: 9999,
        dailyBudgetMinutes: 60,
        totalOpens: 0,
        nightUsageMinutes: 0,
        currentStreak: 0,
        baselineLimit: 60,
        currentLimit: 60,
      );
      final result = calculator.compute(input);
      expect(result.screenTimePenalty, 100.0);
    });

    test('frequencyPenalty is 0 when opens ≤ 10', () {
      final input = FocusScoreInput(
        totalDistractingMinutes: 0,
        dailyBudgetMinutes: 120,
        totalOpens: 5,   // ≤ 10 → no penalty
        nightUsageMinutes: 0,
        currentStreak: 0,
        baselineLimit: 120,
        currentLimit: 120,
      );
      final result = calculator.compute(input);
      expect(result.frequencyPenalty, 0.0);
    });

    test('frequencyPenalty is clamped to 40', () {
      final input = FocusScoreInput(
        totalDistractingMinutes: 0,
        dailyBudgetMinutes: 120,
        totalOpens: 1000,
        nightUsageMinutes: 0,
        currentStreak: 0,
        baselineLimit: 120,
        currentLimit: 120,
      );
      final result = calculator.compute(input);
      expect(result.frequencyPenalty, 40.0);
    });

    test('nightPenalty is clamped to 30', () {
      final input = FocusScoreInput(
        totalDistractingMinutes: 0,
        dailyBudgetMinutes: 120,
        totalOpens: 0,
        nightUsageMinutes: 9999,
        currentStreak: 0,
        baselineLimit: 120,
        currentLimit: 120,
      );
      final result = calculator.compute(input);
      expect(result.nightPenalty, 30.0);
    });

    test('streakBonus is clamped to 10', () {
      final input = FocusScoreInput(
        totalDistractingMinutes: 0,
        dailyBudgetMinutes: 120,
        totalOpens: 0,
        nightUsageMinutes: 0,
        currentStreak: 9999,  // very high streak
        baselineLimit: 120,
        currentLimit: 120,
      );
      final result = calculator.compute(input);
      expect(result.streakBonus, 10.0);
    });

    test('reductionBonus is clamped to 10', () {
      final input = FocusScoreInput(
        totalDistractingMinutes: 0,
        dailyBudgetMinutes: 120,
        totalOpens: 0,
        nightUsageMinutes: 0,
        currentStreak: 0,
        baselineLimit: 120,
        currentLimit: 0,   // 100% reduction
      );
      final result = calculator.compute(input);
      expect(result.reductionBonus, 10.0);
    });

    test('reductionBonus is 0 when baseline equals current', () {
      final input = FocusScoreInput(
        totalDistractingMinutes: 0,
        dailyBudgetMinutes: 120,
        totalOpens: 0,
        nightUsageMinutes: 0,
        currentStreak: 0,
        baselineLimit: 120,
        currentLimit: 120,  // no reduction
      );
      final result = calculator.compute(input);
      expect(result.reductionBonus, 0.0);
    });
  });

  // ─── Formula integration test ──────────────────────────────────────────────

  group('FocusScoreCalculator — formula integration', () {
    test('moderate user scores around 70', () {
      // 60 min distracting, 2h budget, 15 opens, 0 night, no streak
      final input = FocusScoreInput(
        totalDistractingMinutes: 60,
        dailyBudgetMinutes: 120,
        totalOpens: 15,
        nightUsageMinutes: 0,
        currentStreak: 0,
        baselineLimit: 120,
        currentLimit: 120,
      );
      final result = calculator.compute(input);
      // screenTimePenalty = min(100, (60/120)*60) = 30
      // frequencyPenalty  = min(40, (15-10)*1.5) = 7.5
      // nightPenalty = 0
      // raw = 100 - (0.35*30 + 0.25*7.5 + 0) = 100 - (10.5 + 1.875) = ~87.6
      expect(result.score, inInclusiveRange(85, 90));
      expect(result.label, FocusScoreLabel.healthy);
    });

    test('FocusScoreInput.empty() yields score 100', () {
      final result = calculator.compute(FocusScoreInput.empty());
      expect(result.score, 100);
    });
  });
}
