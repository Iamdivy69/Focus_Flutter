import 'package:equatable/equatable.dart';

/// Domain model representing a single app's usage data for one day.
///
/// This is a clean, Isar-free object used throughout the feature layer.
/// Mapped to/from [UsageLogSchema] at the data boundary.
class UsageLog extends Equatable {
  final String packageName;
  final String appName;
  final DateTime date;
  final int totalMinutes;
  final int openCount;

  /// Longest uninterrupted session in minutes.
  final int longestSessionMinutes;

  /// Minutes of usage between 22:00 and 06:00 (night penalty input).
  final int nightUsageMinutes;

  /// Minutes of usage between 05:00 and 09:00 (morning productivity window).
  final int morningUsageMinutes;

  final DateTime recordedAt;

  const UsageLog({
    required this.packageName,
    required this.appName,
    required this.date,
    required this.totalMinutes,
    required this.openCount,
    required this.longestSessionMinutes,
    required this.nightUsageMinutes,
    required this.morningUsageMinutes,
    required this.recordedAt,
  });

  @override
  List<Object?> get props => [
        packageName,
        date,
        totalMinutes,
        openCount,
        longestSessionMinutes,
        nightUsageMinutes,
        morningUsageMinutes,
      ];

  UsageLog copyWith({
    String? packageName,
    String? appName,
    DateTime? date,
    int? totalMinutes,
    int? openCount,
    int? longestSessionMinutes,
    int? nightUsageMinutes,
    int? morningUsageMinutes,
    DateTime? recordedAt,
  }) {
    return UsageLog(
      packageName: packageName ?? this.packageName,
      appName: appName ?? this.appName,
      date: date ?? this.date,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      openCount: openCount ?? this.openCount,
      longestSessionMinutes: longestSessionMinutes ?? this.longestSessionMinutes,
      nightUsageMinutes: nightUsageMinutes ?? this.nightUsageMinutes,
      morningUsageMinutes: morningUsageMinutes ?? this.morningUsageMinutes,
      recordedAt: recordedAt ?? this.recordedAt,
    );
  }

  @override
  String toString() =>
      'UsageLog($packageName, ${totalMinutes}min, opens=$openCount, date=$date)';
}
