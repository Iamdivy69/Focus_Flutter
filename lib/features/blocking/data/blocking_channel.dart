import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../domain/app_limit.dart';

/// Wraps the Android [MethodChannel] `com.focusshield/blocking`.
///
/// Writes SharedPreferences config that [AppBlockService] reads at runtime.
/// Also exposes a goHome() method for the BlockScreen action button.
class BlockingChannel {
  static const _channel = MethodChannel('com.focusshield/blocking');

  BlockingChannel._();
  static final BlockingChannel instance = BlockingChannel._();

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Enables blocking with the given set of limits.
  ///
  /// [limits] — each AppLimit contributes its packageName and currentDailyLimit.
  /// Only monitoring-enabled, non-whitelisted apps are passed as usage limits.
  Future<void> enableBlocking(List<AppLimit> limits) async {
    try {
      final monitoredLimits = limits
          .where((l) => l.isMonitoringEnabled && !l.isWhitelisted);

      final usageLimits = {
        for (final l in monitoredLimits) l.packageName: l.currentDailyLimit
      };

      // Hard-blocked packages (those with limit = 0 or explicitly blocked)
      final hardBlocked = limits
          .where((l) => l.isMonitoringEnabled && !l.isWhitelisted && l.currentDailyLimit == 0)
          .map((l) => l.packageName)
          .toList();

      await _channel.invokeMethod('enableBlocking', {
        'blockedPackages': hardBlocked,
        'usageLimits':     usageLimits,
      });

      debugPrint('BlockingChannel: enabled with ${usageLimits.length} limits');
    } on PlatformException catch (e) {
      debugPrint('BlockingChannel.enableBlocking error: ${e.message}');
    }
  }

  /// Disables all blocking — clears config in SharedPreferences.
  Future<void> disableBlocking() async {
    try {
      await _channel.invokeMethod('disableBlocking');
      debugPrint('BlockingChannel: blocking disabled');
    } on PlatformException catch (e) {
      debugPrint('BlockingChannel.disableBlocking error: ${e.message}');
    }
  }

  /// Enables/disables hardcore mode (blocks all apps regardless of limits).
  Future<void> setHardcoreMode({required bool enabled}) async {
    try {
      await _channel.invokeMethod('setHardcoreMode', {'enabled': enabled});
    } on PlatformException catch (e) {
      debugPrint('BlockingChannel.setHardcoreMode error: ${e.message}');
    }
  }

  /// Enables/disables focus mode with a list of allowed packages.
  Future<void> setFocusMode({
    required bool enabled,
    List<String> allowedPackages = const [],
  }) async {
    try {
      await _channel.invokeMethod('setFocusMode', {
        'enabled':         enabled,
        'allowedPackages': allowedPackages,
      });
    } on PlatformException catch (e) {
      debugPrint('BlockingChannel.setFocusMode error: ${e.message}');
    }
  }

  /// Checks whether the given package has exceeded its daily limit right now.
  Future<bool> checkUsageLimit(String packageName, int limitMinutes) async {
    try {
      final result = await _channel.invokeMethod<bool>('checkUsageLimit', {
        'packageName':  packageName,
        'limitMinutes': limitMinutes,
      });
      return result ?? false;
    } on PlatformException catch (e) {
      debugPrint('BlockingChannel.checkUsageLimit error: ${e.message}');
      return false;
    }
  }

  /// Navigates the device to the home screen.
  /// Used by the BlockScreen "Go Home" action button.
  Future<void> goHome() async {
    try {
      await _channel.invokeMethod('goHome');
    } on PlatformException catch (e) {
      debugPrint('BlockingChannel.goHome error: ${e.message}');
    }
  }
}
