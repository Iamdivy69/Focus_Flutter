package com.focusshield.focusshield

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

/**
 * Transparent Activity launched by AppBlockService when a blocked app is detected.
 * Immediately redirects to the Flutter /block-screen route.
 *
 * Full implementation in Phase 4, Prompt 12.
 */
class BlockActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // TODO Phase 4: extract packageName, blockReason from intent extras
        // and pass them to the Flutter /block-screen route via deep link.
    }
}
