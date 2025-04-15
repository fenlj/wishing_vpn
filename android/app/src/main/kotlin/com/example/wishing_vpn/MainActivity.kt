package com.example.wishing_vpn

import io.flutter.embedding.android.FlutterActivity
import top.oneconnect.oneconnect_flutter.OpenVPNFlutterPlugin
import android.content.Intent
import com.example.wishing_vpn.msg.AppMessageSender
import com.example.wishing_vpn.msg.RouteEvent
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        AppMessageSender.init(flutterEngine.dartExecutor)
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
}
