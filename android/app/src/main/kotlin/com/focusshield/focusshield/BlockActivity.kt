package com.focusshield.focusshield

import android.content.Intent
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity

/**
 * Transparent Activity launched by AppBlockService when a blocked app is detected.
 *
 * Extracts packageName, blockReason, usageMinutes, limitMinutes from the intent extras
 * and navigates the Flutter engine to /block-screen via a deep link.
 */
class BlockActivity : FlutterActivity() {

    companion object {
        private const val TAG = "FocusShield.BlockActivity"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val packageName  = intent.getStringExtra("packageName")  ?: ""
        val blockReason  = intent.getStringExtra("blockReason")  ?: ""
        val usageMinutes = intent.getIntExtra("usageMinutes", 0)
        val limitMinutes = intent.getIntExtra("limitMinutes", 0)

        Log.i(TAG, "BlockActivity: pkg=$packageName reason=$blockReason")

        // Navigate to /block-screen inside the running Flutter engine.
        // We pass params as query params on the custom scheme URI so GoRouter
        // can parse them without requiring Dart extras handling.
        val deepLink = "focusshield://block-screen" +
                "?packageName=${encode(packageName)}" +
                "&blockReason=${encode(blockReason)}" +
                "&usageMinutes=$usageMinutes" +
                "&limitMinutes=$limitMinutes"

        // Re-launch MainActivity carrying the block deep link
        val mainIntent = Intent(this, MainActivity::class.java).apply {
            action = Intent.ACTION_VIEW
            data   = android.net.Uri.parse(deepLink)
            addFlags(
                Intent.FLAG_ACTIVITY_SINGLE_TOP or
                Intent.FLAG_ACTIVITY_CLEAR_TOP  or
                Intent.FLAG_ACTIVITY_NEW_TASK
            )
            // Also forward the raw extras so GoRouter extra-based navigation works too
            putExtra("packageName",  packageName)
            putExtra("blockReason",  blockReason)
            putExtra("usageMinutes", usageMinutes)
            putExtra("limitMinutes", limitMinutes)
        }
        startActivity(mainIntent)
        finish()  // This activity has no UI of its own
    }

    private fun encode(value: String): String =
        java.net.URLEncoder.encode(value, "UTF-8")
}
