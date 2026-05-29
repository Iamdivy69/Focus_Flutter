import 'package:flutter/foundation.dart';
import '../../../data/local/dao/app_limit_dao.dart';
import '../../../data/local/dao/daily_streak_dao.dart';
import '../../../data/local/dao/focus_score_history_dao.dart';
import '../../../data/local/dao/usage_log_dao.dart';
import '../../../data/local/schemas/focus_score_history_schema.dart';
import 'focus_score_calculator.dart';
import 'focus_score_input.dart';
import 'focus_score_result.dart';

/// Orchestrates all data sources to produce a real [FocusScoreResult].
///
/// Reads from:
/// - [UsageLogDao]          — today's usage minutes per app
/// - [AppLimitDao]          — per-app daily limits (baseline + current)
/// - [DailyStreakDao]       — current streak count
/// - [FocusScoreHistoryDao] — yesterday's score for trend computation
///
/// Produces:
/// - [FocusScoreResult] with all components
/// - Persists a [FocusScoreHistorySchema] snapshot for today
class GetFocusScoreUseCase {
  final UsageLogDao _usageLogDao;
  final AppLimitDao _appLimitDao;
  final DailyStreakDao _streakDao;
  final FocusScoreHistoryDao _historyDao;
  final FocusScoreCalculator _calculator;

  // Default daily budget if no limits are configured yet.
  static const int _defaultBudgetMinutes = 120;

  GetFocusScoreUseCase({
    UsageLogDao? usageLogDao,
    AppLimitDao? appLimitDao,
    DailyStreakDao? streakDao,
    FocusScoreHistoryDao? historyDao,
    FocusScoreCalculator? calculator,
  })  : _usageLogDao  = usageLogDao ?? UsageLogDao(),
        _appLimitDao  = appLimitDao ?? AppLimitDao(),
        _streakDao    = streakDao ?? DailyStreakDao(),
        _historyDao   = historyDao ?? FocusScoreHistoryDao(),
        _calculator   = calculator ?? const FocusScoreCalculator();

  /// Computes the real focus score and persists the daily snapshot.
  Future<FocusScoreResult> execute() async {
    try {
      final today     = _startOfDay(DateTime.now());
      final yesterday = today.subtract(const Duration(days: 1));

      // ── 1. Load today's usage logs ────────────────────────────────────────
      final todayLogs = await _usageLogDao.getTodayLogs();

      // ── 2. Load app limits to identify distracting apps ───────────────────
      final allLimits = await _appLimitDao.getAll();
      final limitMap = {for (final l in allLimits) l.packageName: l};

      // Packages with monitoring enabled = distracting apps
      int totalDistractingMinutes = 0;
      int totalOpens              = 0;
      int nightUsageMinutes       = 0;
      int totalBaselineMinutes    = 0;
      int totalCurrentLimit       = 0;
      int dailyBudgetMinutes      = _defaultBudgetMinutes;

      // If we have limits, use sum of baselines as the budget
      if (allLimits.isNotEmpty) {
        totalBaselineMinutes = allLimits.fold(0, (sum, l) => sum + l.baselineDailyMinutes);
        totalCurrentLimit    = allLimits.fold(0, (sum, l) => sum + l.currentDailyLimit);
        dailyBudgetMinutes   = totalBaselineMinutes > 0
            ? totalBaselineMinutes
            : _defaultBudgetMinutes;
      }

      for (final log in todayLogs) {
        final limit = limitMap[log.packageName];
        // Count all apps with a limit as distracting
        if (limit != null && limit.isMonitoringEnabled && !limit.isWhitelisted) {
          totalDistractingMinutes += log.totalMinutes;
          totalOpens              += log.openCount;
          nightUsageMinutes       += log.nightUsageMinutes;
        }
      }

      // ── 3. Load streak ─────────────────────────────────────────────────────
      final streak = await _streakDao.getByDate(today);
      final currentStreak = streak?.sessionsCompleted ?? 0;

      // ── 4. Build input and compute score ───────────────────────────────────
      final input = FocusScoreInput(
        totalDistractingMinutes: totalDistractingMinutes,
        dailyBudgetMinutes:      dailyBudgetMinutes,
        totalOpens:              totalOpens,
        nightUsageMinutes:       nightUsageMinutes,
        currentStreak:           currentStreak,
        baselineLimit:           totalBaselineMinutes > 0 ? totalBaselineMinutes : _defaultBudgetMinutes,
        currentLimit:            totalCurrentLimit > 0 ? totalCurrentLimit : _defaultBudgetMinutes,
      );

      FocusScoreResult result = _calculator.compute(input);

      // ── 5. Compute trend vs yesterday ──────────────────────────────────────
      final yesterdayHistory = await _historyDao.getForDateRange(yesterday, yesterday);
      final yesterdayScore = yesterdayHistory.isNotEmpty
          ? yesterdayHistory.first.score
          : result.score;  // no trend if no history yet
      final trend = result.score - yesterdayScore;

      // Rebuild result with trend
      result = FocusScoreResult(
        score: result.score,
        label: result.label,
        trend: trend,
        screenTimePenalty: result.screenTimePenalty,
        frequencyPenalty: result.frequencyPenalty,
        nightPenalty: result.nightPenalty,
        streakBonus: result.streakBonus,
        reductionBonus: result.reductionBonus,
      );

      // ── 6. Persist today's snapshot ────────────────────────────────────────
      await _persistSnapshot(today, result);

      debugPrint('GetFocusScoreUseCase: score=${result.score} label=${result.label.displayName} trend=$trend');
      return result;
    } catch (e, st) {
      debugPrint('GetFocusScoreUseCase.execute error: $e\n$st');
      return FocusScoreResult.perfect();
    }
  }

  Future<void> _persistSnapshot(DateTime date, FocusScoreResult result) async {
    final snapshot = FocusScoreHistorySchema()
      ..date                   = date
      ..score                  = result.score
      ..label                  = result.label.displayName.toUpperCase().replaceAll(' ', '_')
      ..screenTimeFactor       = result.screenTimePenalty
      ..frequencyFactor        = result.frequencyPenalty
      ..nightUsageFactor       = result.nightPenalty
      ..reductionProgressFactor = result.reductionBonus
      ..recordedAt             = DateTime.now();
    await _historyDao.upsert(snapshot);
  }

  DateTime _startOfDay(DateTime d) => DateTime(d.year, d.month, d.day);
}
