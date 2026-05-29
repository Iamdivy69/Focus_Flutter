import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../usage/usage_providers.dart';
import 'domain/focus_score_calculator.dart';
import 'domain/focus_score_result.dart';
import 'domain/get_focus_score_use_case.dart';

// ---------------------------------------------------------------------------
// Calculator — singleton, pure function
// ---------------------------------------------------------------------------

final focusScoreCalculatorProvider = Provider<FocusScoreCalculator>((ref) {
  return const FocusScoreCalculator();
});

// ---------------------------------------------------------------------------
// Use case — singleton, reads from DAOs directly
// ---------------------------------------------------------------------------

final focusScoreUseCaseProvider = Provider<GetFocusScoreUseCase>((ref) {
  return GetFocusScoreUseCase();
});

// ---------------------------------------------------------------------------
// Score provider — recomputes whenever today's usage stream updates
// ---------------------------------------------------------------------------

/// Provides the real [FocusScoreResult] derived from actual usage data.
///
/// This provider:
/// 1. Listens to [todayUsageProvider] (Isar stream) so it auto-updates
/// 2. Calls [GetFocusScoreUseCase.execute()] to produce the result
/// 3. Persists the daily snapshot as a side effect
final focusScoreProvider = FutureProvider<FocusScoreResult>((ref) async {
  // Watch today's usage stream — rebuild when data changes
  ref.watch(todayUsageProvider);

  final useCase = ref.watch(focusScoreUseCaseProvider);
  return useCase.execute();
});

// ---------------------------------------------------------------------------
// Score history — last 30 days for trend charts
// ---------------------------------------------------------------------------

/// Provides the focus score for yesterday (for trend comparison in the UI).
/// The trend is already computed inside FocusScoreResult.trend.
final yesterdayScoreProvider = Provider<int?>((ref) => null);

