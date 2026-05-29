import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

/// Wraps the Android [MethodChannel] `com.focusshield/permissions` and standard permissions.
class PermissionsChannel {
  static const _channel = MethodChannel('com.focusshield/permissions');

  PermissionsChannel._();
  static final PermissionsChannel instance = PermissionsChannel._();

  /// Checks if Usage Access permission is granted.
  Future<bool> checkUsageAccessGranted() async {
    try {
      final bool? result = await _channel.invokeMethod<bool>('checkUsageAccessGranted');
      return result ?? false;
    } on PlatformException catch (e) {
      debugPrint('PermissionsChannel.checkUsageAccessGranted error: ${e.message}');
      return false;
    }
  }

  /// Checks if Accessibility Service permission is granted/enabled.
  Future<bool> checkAccessibilityEnabled() async {
    try {
      final bool? result = await _channel.invokeMethod<bool>('checkAccessibilityEnabled');
      return result ?? false;
    } on PlatformException catch (e) {
      debugPrint('PermissionsChannel.checkAccessibilityEnabled error: ${e.message}');
      return false;
    }
  }

  /// Checks if Notification permission is granted.
  Future<bool> checkNotificationsGranted() async {
    try {
      return await Permission.notification.isGranted;
    } catch (e) {
      debugPrint('PermissionsChannel.checkNotificationsGranted error: $e');
      return false;
    }
  }

  /// Opens the system Usage Access settings page.
  Future<void> openUsageAccessSettings() async {
    try {
      await _channel.invokeMethod('openUsageAccessSettings');
    } on PlatformException catch (e) {
      debugPrint('PermissionsChannel.openUsageAccessSettings error: ${e.message}');
    }
  }

  /// Opens the system Accessibility settings page.
  Future<void> openAccessibilitySettings() async {
    try {
      await _channel.invokeMethod('openAccessibilitySettings');
    } on PlatformException catch (e) {
      debugPrint('PermissionsChannel.openAccessibilitySettings error: ${e.message}');
    }
  }

  /// Requests notification permission.
  Future<bool> requestNotificationsPermission() async {
    try {
      final status = await Permission.notification.request();
      return status.isGranted;
    } catch (e) {
      debugPrint('PermissionsChannel.requestNotificationsPermission error: $e');
      return false;
    }
  }
}
