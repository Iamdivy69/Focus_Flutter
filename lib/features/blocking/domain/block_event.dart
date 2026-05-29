import 'package:equatable/equatable.dart';

/// Domain model for a block event — logged each time an app is blocked.
///
/// Mapped from [BlockEventSchema] at the data boundary.
class BlockEvent extends Equatable {
  final String packageName;

  /// One of: HARDCORE, FOCUS_MODE, SCHEDULE, USAGE_LIMIT
  final String reason;

  final DateTime blockedAt;

  /// Minutes over the limit when blocked (0 for non-limit block reasons).
  final int durationOverLimit;

  const BlockEvent({
    required this.packageName,
    required this.reason,
    required this.blockedAt,
    required this.durationOverLimit,
  });

  String get readableReason {
    switch (reason) {
      case 'HARDCORE':    return 'Hardcore Mode Active';
      case 'FOCUS_MODE':  return 'Focus Session Active';
      case 'SCHEDULE':    return 'Scheduled Block';
      case 'USAGE_LIMIT': return 'Daily Limit Reached';
      default:            return reason;
    }
  }

  @override
  List<Object?> get props => [packageName, reason, blockedAt];

  @override
  String toString() => 'BlockEvent($packageName, $reason, $blockedAt)';
}
