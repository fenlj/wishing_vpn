package com.example.wishing_vpn

import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import top.oneconnect.oneconnect_flutter.OpenVPNFlutterPlugin
import android.content.Intent
import com.example.wishing_vpn.msg.AppMessageSender
import com.example.wishing_vpn.msg.RouteEvent
import com.facebook.FacebookSdk
import io.flutter.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        AppMessageSender.init(flutterEngine.dartExecutor)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, "wishing.native.method"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "initFb" -> {
                    initFacebook(
                        this,
                        call.argument<String>("fbId") ?: "",
                        call.argument<String>("fbToken") ?: ""
                    )
                }
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        OpenVPNFlutterPlugin.connectWhileGranted(requestCode == 24 && resultCode == RESULT_OK)
        super.onActivityResult(requestCode, resultCode, data)
    }

    override fun onResume() {
        super.onResume()
        AppMessageSender.send(RouteEvent.restart())
    }

    override fun onDestroy() {
        super.onDestroy()
        AppMessageSender.dipsose()
    }

    private fun initFacebook(context: Context, fbId: String, fbToken: String) {
        Log.d("Facebook","init $fbId $fbToken")
        if (fbId == "blank" || fbToken == "blank") return
        if (fbId.isNotEmpty() && fbToken.isNotEmpty()) {
            FacebookSdk.setApplicationId(fbId)
            FacebookSdk.setClientToken(fbToken)
            FacebookSdk.setAutoInitEnabled(true)
            FacebookSdk.fullyInitialize()
            FacebookSdk.sdkInitialize(context) {
                FacebookSdk.setAutoLogAppEventsEnabled(true)
            }
            FacebookSdk.setAutoLogAppEventsEnabled(true)
        }
    }
}
