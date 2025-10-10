package com.example.champion_car_wash_app

import android.content.Intent
import android.nfc.NfcAdapter
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
    }

    override fun onResume() {
        super.onResume()
        // Enable NFC foreground dispatch if NFC is available
        try {
            val nfcAdapter = NfcAdapter.getDefaultAdapter(this)
            nfcAdapter?.enableForegroundDispatch(
                this,
                null,
                null,
                null
            )
        } catch (e: Exception) {
            // NFC not available on this device, ignore
        }
    }

    override fun onPause() {
        super.onPause()
        // Disable NFC foreground dispatch
        try {
            val nfcAdapter = NfcAdapter.getDefaultAdapter(this)
            nfcAdapter?.disableForegroundDispatch(this)
        } catch (e: Exception) {
            // NFC not available on this device, ignore
        }
    }
}
