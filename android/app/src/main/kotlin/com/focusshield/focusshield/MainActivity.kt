package com.focusshield.focusshield

import android.app.AppOpsManager
import android.content.Context
import android.content.Intent
import android.os.Process
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    // MethodChannel names — must match AppConstants in Dart
    private val PERMISSIONS_CHANNEL = "com.focusshield/permissions"
    private val USAGE_STATS_CHANNEL = "com.focusshield/usage_stats"
    private val BLOCKING_CHANNEL = "com.focusshield/blocking"
    private val APP_INFO_CHANNEL = "com.focusshield/app_info"
    private val HARDCORE_OVERLAY_CHANNEL = "com.focusshield/hardcore_overlay"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // ── Permissions channel ──────────────────────────────────────────────
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            PERMISSIONS_CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "checkUsageAccessGranted" ->
                    result.success(isUsageAccessGranted())
                "checkAccessibilityEnabled" ->
                    result.success(isAccessibilityEnabled())
                "openUsageAccessSettings" -> {
                    startActivity(Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS))
                    result.success(null)
                }
                "openAccessibilitySettings" -> {
                    startActivity(Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS))
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }

        // ── Usage stats channel ──────────────────────────────────────────────
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            USAGE_STATS_CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getDailyUsage" -> {
                    // TODO: Phase 3 — implement UsageStatsManager query
                    result.success(emptyMap<String, Any>())
                }
                "getHourlyUsage" -> {
                    // TODO: Phase 3 — implement hourly breakdown
                    result.success(emptyMap<String, Any>())
                }
                else -> result.notImplemented()
            }
        }

        // ── Blocking channel ─────────────────────────────────────────────────
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            BLOCKING_CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "startBlockService" -> {
                    // TODO: Phase 4 — start AppBlockService
                    result.success(null)
                }
                "stopBlockService" -> {
                    // TODO: Phase 4 — stop AppBlockService
                    result.success(null)
                }
                "setHardcoreMode" -> {
                    // TODO: Phase 4 — enable/disable hardcore mode
                    result.success(null)
                }
                "setFocusMode" -> {
                    // TODO: Phase 4 — set focus mode with package list
                    result.success(null)
                }
                "checkUsageLimitReached" -> {
                    // TODO: Phase 4 — check if package has hit its limit
                    result.success(false)
                }
                else -> result.notImplemented()
            }
        }

        // ── App info channel ─────────────────────────────────────────────────
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            APP_INFO_CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getAppName" -> {
                    val packageName = call.argument<String>("packageName") ?: ""
                    val appName = getAppName(packageName)
                    result.success(appName)
                }
                "getInstalledApps" -> {
                    // TODO: Phase 2 — return list of installed user apps
                    result.success(emptyList<Map<String, Any>>())
                }
                else -> result.notImplemented()
            }
        }

        // ── Hardcore overlay channel ─────────────────────────────────────────
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            HARDCORE_OVERLAY_CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "startHardcoreOverlay" -> {
                    // TODO: Phase 7 — launch TYPE_APPLICATION_OVERLAY activity
                    result.success(null)
                }
                "dismissHardcoreOverlay" -> {
                    // TODO: Phase 7 — dismiss overlay
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    // ── Helpers ──────────────────────────────────────────────────────────────

    private fun isUsageAccessGranted(): Boolean {
        return try {
            val appOps = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
            val mode = appOps.checkOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                Process.myUid(),
                packageName
            )
            mode == AppOpsManager.MODE_ALLOWED
        } catch (e: Exception) {
            false
        }
    }

    private fun isAccessibilityEnabled(): Boolean {
        return try {
            val enabledServices = Settings.Secure.getString(
                contentResolver,
                Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES
            ) ?: return false
            enabledServices.contains(packageName, ignoreCase = true)
        } catch (e: Exception) {
            false
        }
    }

    private fun getAppName(packageName: String): String {
        return try {
            val pm = applicationContext.packageManager
            val info = pm.getApplicationInfo(packageName, 0)
            pm.getApplicationLabel(info).toString()
        } catch (e: Exception) {
            packageName
        }
    }
}
