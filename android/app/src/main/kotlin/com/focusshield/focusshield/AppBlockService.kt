package com.focusshield.focusshield

import android.accessibilityservice.AccessibilityService
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.accessibility.AccessibilityEvent
import org.json.JSONObject
import java.util.Calendar

/**
 * AppBlockService — AccessibilityService that detects foreground app changes
 * and triggers the block flow when a restricted app is opened.
 *
 * This service reads its config exclusively from SharedPreferences written by
 * MainActivity so it is fully decoupled from the Flutter engine at runtime.
 *
 * Privacy note: canRetrieveWindowContent is false in accessibility_service_config.xml.
 * This service ONLY reads the package name from TYPE_WINDOW_STATE_CHANGED events.
 * It does NOT read screen content, passwords, or any personal data.
 *
 * Block priority chain:
 *   HARDCORE → FOCUS_MODE → SCHEDULE → USAGE_LIMIT
 */
class AppBlockService : AccessibilityService() {

    companion object {
        private const val TAG             = "FocusShield.BlockSvc"
        private const val COOLDOWN_MS     = 3_000L   // per-package cooldown between blocks
        private const val BLOCK_DELAY_MS  = 300L     // delay before launching BlockActivity

        // Launchers and system UI to always skip
        private val SKIP_PACKAGES = setOf(
            "com.android.launcher",
            "com.android.launcher2",
            "com.android.launcher3",
            "com.google.android.apps.nexuslauncher",
            "com.sec.android.app.launcher",
            "com.miui.home",
            "com.android.systemui",
        )

        // Cooldown tracking: packageName -> last block timestamp (ms)
        @Volatile private var blockCooldowns = mutableMapOf<String, Long>()
    }

    private val handler = Handler(Looper.getMainLooper())

    // ─── AccessibilityService callbacks ───────────────────────────────────────

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event?.eventType != AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) return
        val packageName = event.packageName?.toString() ?: return

        // Skip own package, launchers, system UI
        if (packageName == this.packageName) return
        if (packageName in SKIP_PACKAGES) return
        if (SKIP_PACKAGES.any { packageName.startsWith(it) }) return

        // Cooldown check — prevent infinite block loops
        val now = System.currentTimeMillis()
        val lastBlock = blockCooldowns[packageName] ?: 0L
        if (now - lastBlock < COOLDOWN_MS) return

        // Evaluate block conditions in priority order
        val blockReason = evaluateBlockConditions(packageName) ?: return

        // Update cooldown immediately to prevent re-entry
        blockCooldowns[packageName] = now

        // Go home first, then launch block screen after a short delay
        applyBlock(packageName, blockReason)
    }

    override fun onInterrupt() {
        // Required override — no-op
    }

    // ─── Block evaluation ─────────────────────────────────────────────────────

    /**
     * Checks all block conditions in priority order.
     * @return the block reason string, or null if the app should not be blocked.
     */
    private fun evaluateBlockConditions(packageName: String): String? {
        val prefs = getSharedPreferences(MainActivity.PREFS_NAME, Context.MODE_PRIVATE)

        // 1. HARDCORE — blocks everything not whitelisted
        if (prefs.getBoolean(MainActivity.PREF_HARDCORE_ENABLED, false)) {
            return "HARDCORE"
        }

        // 2. FOCUS_MODE — blocks apps not in the allowed list
        if (prefs.getBoolean(MainActivity.PREF_FOCUS_MODE_ENABLED, false)) {
            val allowedRaw = prefs.getString(MainActivity.PREF_FOCUS_PACKAGES, "") ?: ""
            val allowed = allowedRaw.split(",").filter { it.isNotBlank() }.toSet()
            if (packageName !in allowed) {
                return "FOCUS_MODE"
            }
        }

        // 3. Blocking not enabled — skip SCHEDULE and LIMIT checks
        if (!prefs.getBoolean(MainActivity.PREF_BLOCKING_ENABLED, false)) return null

        // 4. SCHEDULE — check if app is in manually blocked list
        val blockedRaw = prefs.getString(MainActivity.PREF_BLOCKED_PACKAGES, "") ?: ""
        val blocked = blockedRaw.split(",").filter { it.isNotBlank() }.toSet()
        if (packageName in blocked) {
            return "SCHEDULE"
        }

        // 5. USAGE_LIMIT — check if app has exceeded its daily limit
        val limitsJson = prefs.getString(MainActivity.PREF_USAGE_LIMITS, "{}") ?: "{}"
        val limitMinutes = parseLimitForPackage(limitsJson, packageName)
        if (limitMinutes != null) {
            val usedMinutes = getTodayUsageMinutes(packageName)
            if (usedMinutes >= limitMinutes) {
                return "USAGE_LIMIT:${usedMinutes}:${limitMinutes}"
            }
        }

        return null
    }

    // ─── Block execution ──────────────────────────────────────────────────────

    private fun applyBlock(packageName: String, blockReason: String) {
        Log.i(TAG, "Blocking $packageName — reason: $blockReason")

        // Step 1: navigate away immediately
        performGlobalAction(GLOBAL_ACTION_HOME)

        // Step 2: launch BlockActivity after delay to let the home animation settle
        handler.postDelayed({
            launchBlockActivity(packageName, blockReason)
        }, BLOCK_DELAY_MS)
    }

    private fun launchBlockActivity(packageName: String, blockReason: String) {
        // Parse usage/limit from the reason string if present (USAGE_LIMIT:used:limit)
        var usageMinutes = 0
        var limitMinutes = 0
        val cleanReason: String
        if (blockReason.startsWith("USAGE_LIMIT:")) {
            val parts = blockReason.split(":")
            cleanReason  = parts[0]
            usageMinutes = parts.getOrNull(1)?.toIntOrNull() ?: 0
            limitMinutes = parts.getOrNull(2)?.toIntOrNull() ?: 0
        } else {
            cleanReason = blockReason
        }

        val intent = Intent(this, BlockActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
            putExtra("packageName",   packageName)
            putExtra("blockReason",   cleanReason)
            putExtra("usageMinutes",  usageMinutes)
            putExtra("limitMinutes",  limitMinutes)
        }
        startActivity(intent)
    }

    // ─── Helpers ─────────────────────────────────────────────────────────────

    private fun parseLimitForPackage(limitsJson: String, packageName: String): Int? {
        return try {
            val json = JSONObject(limitsJson)
            if (json.has(packageName)) json.getInt(packageName) else null
        } catch (_: Exception) {
            null
        }
    }

    private fun getTodayUsageMinutes(packageName: String): Int {
        return try {
            val usm = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
            val calendar = Calendar.getInstance().apply {
                set(Calendar.HOUR_OF_DAY, 0); set(Calendar.MINUTE, 0)
                set(Calendar.SECOND, 0);       set(Calendar.MILLISECOND, 0)
            }
            val stats = usm.queryAndAggregateUsageStats(
                calendar.timeInMillis, System.currentTimeMillis()
            )
            ((stats[packageName]?.totalTimeInForeground ?: 0L) / 60_000L).toInt()
        } catch (e: Exception) {
            Log.w(TAG, "Could not query usage for $packageName: ${e.message}")
            0
        }
    }
}
