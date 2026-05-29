package com.focusshield.focusshield

import android.app.AppOpsManager
import android.app.usage.UsageStatsManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.os.Build
import android.os.Process
import android.provider.Settings
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject
import java.util.Calendar

class MainActivity : FlutterActivity() {

    companion object {
        private const val TAG = "FocusShield.MainActivity"

        // MethodChannel names — must match constants in Dart
        private const val PERMISSIONS_CHANNEL    = "com.focusshield/permissions"
        private const val USAGE_STATS_CHANNEL    = "com.focusshield/usage_stats"
        private const val BLOCKING_CHANNEL       = "com.focusshield/blocking"
        private const val APP_INFO_CHANNEL       = "com.focusshield/app_info"
        private const val HARDCORE_OVERLAY_CHANNEL = "com.focusshield/hardcore_overlay"

        // SharedPreferences — shared with AppBlockService
        const val PREFS_NAME                = "focusshield_block_config"
        const val PREF_BLOCKING_ENABLED     = "blocking_enabled"
        const val PREF_HARDCORE_ENABLED     = "hardcore_enabled"
        const val PREF_FOCUS_MODE_ENABLED   = "focus_mode_enabled"
        const val PREF_BLOCKED_PACKAGES     = "blocked_packages"        // JSON array string
        const val PREF_USAGE_LIMITS         = "usage_limits"            // JSON object: pkg -> limitMinutes
        const val PREF_FOCUS_PACKAGES       = "focus_packages"          // JSON array — allowed during focus

        // Packages to always ignore when building usage lists
        val IGNORE_PACKAGES = setOf(
            "com.android.systemui",
            "com.android.launcher",
            "com.android.launcher2",
            "com.android.launcher3",
            "com.google.android.apps.nexuslauncher",
            "com.sec.android.app.launcher",
            "com.miui.home",
            "com.focusshield.focusshield",
        )
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        setupPermissionsChannel(flutterEngine)
        setupUsageStatsChannel(flutterEngine)
        setupBlockingChannel(flutterEngine)
        setupAppInfoChannel(flutterEngine)
        setupHardcoreOverlayChannel(flutterEngine)
    }

    // ─── Permissions channel ──────────────────────────────────────────────────

    private fun setupPermissionsChannel(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PERMISSIONS_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "checkUsageAccessGranted"  -> result.success(isUsageAccessGranted())
                    "checkAccessibilityEnabled" -> result.success(isAccessibilityEnabled())
                    "openUsageAccessSettings"  -> {
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
    }

    // ─── Usage stats channel ──────────────────────────────────────────────────

    private fun setupUsageStatsChannel(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, USAGE_STATS_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (!isUsageAccessGranted()) {
                    result.error("PERMISSION_DENIED", "Usage access not granted", null)
                    return@setMethodCallHandler
                }
                try {
                    when (call.method) {
                        "getTodayUsage"  -> result.success(getTodayUsageData())
                        "getWeeklyUsage" -> result.success(getWeeklyUsageData())
                        "getInstalledApps" -> result.success(getInstalledAppsData())
                        else -> result.notImplemented()
                    }
                } catch (e: Exception) {
                    Log.e(TAG, "Usage stats error: ${e.message}", e)
                    result.error("USAGE_STATS_ERROR", e.message, null)
                }
            }
    }

    /**
     * Returns a list of maps, one per app that had usage today.
     * Each map: packageName, appName, totalMinutes, openCount, lastUsedTimestamp
     */
    private fun getTodayUsageData(): List<Map<String, Any>> {
        val usm = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val calendar = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, 0)
            set(Calendar.MINUTE, 0)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }
        val startTime = calendar.timeInMillis
        val endTime   = System.currentTimeMillis()

        return queryAndMapUsage(usm, startTime, endTime)
    }

    /**
     * Returns usage stats for the last 7 days.
     */
    private fun getWeeklyUsageData(): List<Map<String, Any>> {
        val usm = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val endTime   = System.currentTimeMillis()
        val startTime = endTime - 7L * 24 * 60 * 60 * 1000
        return queryAndMapUsage(usm, startTime, endTime)
    }

    private fun queryAndMapUsage(
        usm: UsageStatsManager,
        startTime: Long,
        endTime: Long
    ): List<Map<String, Any>> {
        val statsMap = usm.queryAndAggregateUsageStats(startTime, endTime)
        val pm = packageManager
        val result = mutableListOf<Map<String, Any>>()

        for ((packageName, stats) in statsMap) {
            if (packageName in IGNORE_PACKAGES) continue
            val totalMs = stats.totalTimeInForeground
            if (totalMs <= 0L) continue

            // Resolve human-readable app name; skip pure system services
            val appName = try {
                val info = pm.getApplicationInfo(packageName, 0)
                // Skip apps that are system apps with no label
                if (info.flags and ApplicationInfo.FLAG_SYSTEM != 0) {
                    val label = pm.getApplicationLabel(info).toString()
                    if (label == packageName) continue  // no user-visible name
                    label
                } else {
                    pm.getApplicationLabel(info).toString()
                }
            } catch (_: PackageManager.NameNotFoundException) {
                continue  // package removed; skip
            }

            val totalMinutes = (totalMs / 60_000L).toInt()

            result.add(
                mapOf(
                    "packageName"       to packageName,
                    "appName"           to appName,
                    "totalMinutes"      to totalMinutes,
                    "openCount"         to (stats.describeContents()),  // placeholder; real count below
                    "lastUsedTimestamp" to stats.lastTimeUsed,
                )
            )
        }

        // Sort by usage descending
        return result.sortedByDescending { it["totalMinutes"] as Int }
    }

    /**
     * Returns all installed user-facing apps (non-system, or system with a launcher icon).
     */
    private fun getInstalledAppsData(): List<Map<String, Any>> {
        val pm = packageManager
        val intent = Intent(Intent.ACTION_MAIN, null).apply { addCategory(Intent.CATEGORY_LAUNCHER) }
        val resolveInfoList = pm.queryIntentActivities(intent, 0)
        return resolveInfoList
            .mapNotNull { resolveInfo ->
                val pkg = resolveInfo.activityInfo.packageName
                if (pkg in IGNORE_PACKAGES) return@mapNotNull null
                val appName = resolveInfo.loadLabel(pm).toString()
                mapOf<String, Any>("packageName" to pkg, "appName" to appName)
            }
            .distinctBy { it["packageName"] }
            .sortedBy { it["appName"] as String }
    }

    // ─── Blocking channel ─────────────────────────────────────────────────────

    private fun setupBlockingChannel(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, BLOCKING_CHANNEL)
            .setMethodCallHandler { call, result ->
                try {
                    when (call.method) {
                        "enableBlocking" -> {
                            // args: blockedPackages (List<String>), usageLimits (Map<String,Int>)
                            @Suppress("UNCHECKED_CAST")
                            val blocked = call.argument<List<String>>("blockedPackages") ?: emptyList()
                            @Suppress("UNCHECKED_CAST")
                            val limits  = call.argument<Map<String, Int>>("usageLimits") ?: emptyMap()
                            saveBlockingConfig(enabled = true, blockedPackages = blocked, usageLimits = limits)
                            result.success(null)
                        }
                        "disableBlocking" -> {
                            saveBlockingConfig(enabled = false, blockedPackages = emptyList(), usageLimits = emptyMap())
                            result.success(null)
                        }
                        "setHardcoreMode" -> {
                            val enabled = call.argument<Boolean>("enabled") ?: false
                            getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                                .edit().putBoolean(PREF_HARDCORE_ENABLED, enabled).apply()
                            result.success(null)
                        }
                        "setFocusMode" -> {
                            val enabled  = call.argument<Boolean>("enabled") ?: false
                            @Suppress("UNCHECKED_CAST")
                            val packages = call.argument<List<String>>("allowedPackages") ?: emptyList()
                            val prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE).edit()
                            prefs.putBoolean(PREF_FOCUS_MODE_ENABLED, enabled)
                            prefs.putString(PREF_FOCUS_PACKAGES, packages.joinToString(","))
                            prefs.apply()
                            result.success(null)
                        }
                        "checkUsageLimit" -> {
                            // args: packageName (String), limitMinutes (Int)
                            val packageName  = call.argument<String>("packageName") ?: ""
                            val limitMinutes = call.argument<Int>("limitMinutes") ?: Int.MAX_VALUE
                            val exceeded     = isUsageLimitExceeded(packageName, limitMinutes)
                            result.success(exceeded)
                        }
                        "goHome" -> {
                            // Called from block screen "Go Home" button — no accessibility needed here
                            val homeIntent = Intent(Intent.ACTION_MAIN).apply {
                                addCategory(Intent.CATEGORY_HOME)
                                flags = Intent.FLAG_ACTIVITY_NEW_TASK
                            }
                            startActivity(homeIntent)
                            result.success(null)
                        }
                        else -> result.notImplemented()
                    }
                } catch (e: Exception) {
                    Log.e(TAG, "Blocking channel error: ${e.message}", e)
                    result.error("BLOCKING_ERROR", e.message, null)
                }
            }
    }

    private fun saveBlockingConfig(
        enabled: Boolean,
        blockedPackages: List<String>,
        usageLimits: Map<String, Int>
    ) {
        val prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE).edit()
        prefs.putBoolean(PREF_BLOCKING_ENABLED, enabled)

        // Encode blocked packages as comma-separated string
        prefs.putString(PREF_BLOCKED_PACKAGES, blockedPackages.joinToString(","))

        // Encode limits as JSON object string: {"com.example.app": 60, ...}
        val limitsJson = StringBuilder("{")
        usageLimits.entries.forEachIndexed { i, (pkg, mins) ->
            if (i > 0) limitsJson.append(",")
            limitsJson.append("\"$pkg\":$mins")
        }
        limitsJson.append("}")
        prefs.putString(PREF_USAGE_LIMITS, limitsJson.toString())
        prefs.apply()

        Log.d(TAG, "Blocking config saved: enabled=$enabled, packages=${blockedPackages.size}, limits=${usageLimits.size}")
    }

    private fun isUsageLimitExceeded(packageName: String, limitMinutes: Int): Boolean {
        if (!isUsageAccessGranted()) return false
        val usm = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val calendar = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, 0); set(Calendar.MINUTE, 0)
            set(Calendar.SECOND, 0);       set(Calendar.MILLISECOND, 0)
        }
        val stats = usm.queryAndAggregateUsageStats(
            calendar.timeInMillis, System.currentTimeMillis()
        )
        val totalMinutes = ((stats[packageName]?.totalTimeInForeground ?: 0L) / 60_000L).toInt()
        return totalMinutes >= limitMinutes
    }

    // ─── App info channel ─────────────────────────────────────────────────────

    private fun setupAppInfoChannel(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, APP_INFO_CHANNEL)
            .setMethodCallHandler { call, result ->
                try {
                    when (call.method) {
                        "getAppName" -> {
                            val packageName = call.argument<String>("packageName") ?: ""
                            result.success(getAppName(packageName))
                        }
                        "getInstalledApps" -> result.success(getInstalledAppsData())
                        else -> result.notImplemented()
                    }
                } catch (e: Exception) {
                    result.error("APP_INFO_ERROR", e.message, null)
                }
            }
    }

    // ─── Hardcore overlay channel ─────────────────────────────────────────────

    private fun setupHardcoreOverlayChannel(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, HARDCORE_OVERLAY_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startHardcoreOverlay"   -> result.success(null)  // Phase 7
                    "dismissHardcoreOverlay" -> result.success(null)  // Phase 7
                    else -> result.notImplemented()
                }
            }
    }

    // ─── Helpers ─────────────────────────────────────────────────────────────

    private fun isUsageAccessGranted(): Boolean {
        return try {
            val appOps = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
            val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                appOps.unsafeCheckOpNoThrow(
                    AppOpsManager.OPSTR_GET_USAGE_STATS,
                    Process.myUid(),
                    packageName
                )
            } else {
                @Suppress("DEPRECATION")
                appOps.checkOpNoThrow(
                    AppOpsManager.OPSTR_GET_USAGE_STATS,
                    Process.myUid(),
                    packageName
                )
            }
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
