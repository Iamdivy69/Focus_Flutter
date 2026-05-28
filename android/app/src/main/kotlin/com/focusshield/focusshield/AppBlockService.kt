package com.focusshield.focusshield

import android.accessibilityservice.AccessibilityService
import android.view.accessibility.AccessibilityEvent

/**
 * AppBlockService — AccessibilityService that detects foreground app changes
 * and triggers the block flow when a restricted app is opened.
 *
 * Full implementation in Phase 4, Prompt 11.
 *
 * IMPORTANT: canRetrieveWindowContent is false in accessibility_service_config.xml.
 * This service ONLY reads the package name from TYPE_WINDOW_STATE_CHANGED events.
 * It does NOT read screen content, passwords, or any personal text.
 */
class AppBlockService : AccessibilityService() {

    companion object {
        // Cooldown map: packageName -> last block timestamp (ms)
        private val blockCooldowns = mutableMapOf<String, Long>()
        private const val COOLDOWN_MS = 3_000L

        // Launchers to skip
        private val LAUNCHER_PACKAGES = setOf(
            "com.android.launcher",
            "com.android.launcher2",
            "com.android.launcher3",
            "com.google.android.apps.nexuslauncher",
            "com.sec.android.app.launcher",
            "com.miui.home",
        )
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event?.eventType != AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) return
        val packageName = event.packageName?.toString() ?: return

        // Skip own package, launchers, and system UI
        if (packageName == this.packageName) return
        if (packageName == "com.android.systemui") return
        if (LAUNCHER_PACKAGES.any { packageName.startsWith(it) }) return

        // Cooldown check
        val now = System.currentTimeMillis()
        val lastBlock = blockCooldowns[packageName] ?: 0L
        if (now - lastBlock < COOLDOWN_MS) return

        // TODO Phase 4: evaluateBlockConditions(packageName)
        // If block needed: applyBlock(packageName, reason)
    }

    override fun onInterrupt() {
        // Required override — no-op
    }

    // TODO Phase 4: implement evaluateBlockConditions and applyBlock
}
