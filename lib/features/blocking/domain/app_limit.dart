import 'package:equatable/equatable.dart';

/// Domain model for a per-app usage limit configuration.
///
/// Mapped from [AppLimitSchema] at the data boundary.
class AppLimit extends Equatable {
  final String packageName;
  final String appName;

  /// Original baseline daily limit before gradual reduction (minutes).
  final int baselineDailyMinutes;

  /// Current active daily limit (may be lower than baseline via reduction).
  final int currentDailyLimit;

  /// Floor — the app can never be reduced below this (minutes).
  final int minimumLimitMinutes;

  /// Whether this app is actively monitored and counted toward the score.
  final bool isMonitoringEnabled;

  /// Whitelisted apps are never blocked regardless of usage.
  final bool isWhitelisted;

  final DateTime updatedAt;

  const AppLimit({
    required this.packageName,
    required this.appName,
    required this.baselineDailyMinutes,
    required this.currentDailyLimit,
    required this.minimumLimitMinutes,
    required this.isMonitoringEnabled,
    required this.isWhitelisted,
    required this.updatedAt,
  });

  AppLimit copyWith({
    String? packageName,
    String? appName,
    int? baselineDailyMinutes,
    int? currentDailyLimit,
    int? minimumLimitMinutes,
    bool? isMonitoringEnabled,
    bool? isWhitelisted,
    DateTime? updatedAt,
  }) {
    return AppLimit(
      packageName: packageName ?? this.packageName,
      appName: appName ?? this.appName,
      baselineDailyMinutes: baselineDailyMinutes ?? this.baselineDailyMinutes,
      currentDailyLimit: currentDailyLimit ?? this.currentDailyLimit,
      minimumLimitMinutes: minimumLimitMinutes ?? this.minimumLimitMinutes,
      isMonitoringEnabled: isMonitoringEnabled ?? this.isMonitoringEnabled,
      isWhitelisted: isWhitelisted ?? this.isWhitelisted,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        packageName,
        appName,
        baselineDailyMinutes,
        currentDailyLimit,
        minimumLimitMinutes,
        isMonitoringEnabled,
        isWhitelisted,
        updatedAt,
      ];

  @override
  String toString() =>
      'AppLimit($packageName, limit=${currentDailyLimit}min, monitoring=$isMonitoringEnabled)';
}
