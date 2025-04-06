package com.example.wishing_vpn

import io.flutter.embedding.android.FlutterActivity
import top.oneconnect.oneconnect_flutter.OpenVPNFlutterPlugin
import android.content.Intent;

class MainActivity : FlutterActivity(){

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
    OpenVPNFlutterPlugin.connectWhileGranted(requestCode == 24 && resultCode == RESULT_OK)
    super.onActivityResult(requestCode, resultCode, data)
}
}
