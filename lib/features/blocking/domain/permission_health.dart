import 'package:equatable/equatable.dart';

/// Holds the status of all permissions required for FocusShield's core features.
class PermissionHealth extends Equatable {
  final bool isUsageAccessGranted;
  final bool isAccessibilityEnabled;
  final bool isNotificationsGranted;

  const PermissionHealth({
    required this.isUsageAccessGranted,
    required this.isAccessibilityEnabled,
    required this.isNotificationsGranted,
  });

  /// Returns true if all three essential permissions are granted.
  bool get allGranted =>
      isUsageAccessGranted && isAccessibilityEnabled && isNotificationsGranted;

  @override
  List<Object?> get props => [
        isUsageAccessGranted,
        isAccessibilityEnabled,
        isNotificationsGranted,
      ];
}
