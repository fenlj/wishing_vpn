package com.example.wishing_vpn

import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import top.oneconnect.oneconnect_flutter.OpenVPNFlutterPlugin
import android.content.Intent
import android.os.Bundle
import com.example.wishing_vpn.msg.AppMessage
import com.example.wishing_vpn.msg.AppMessageSender
import com.example.wishing_vpn.msg.RouteEvent
import com.facebook.FacebookSdk
import com.facebook.appevents.AppEventsLogger
import com.google.android.ump.ConsentInformation
import com.google.android.ump.ConsentRequestParameters
import com.google.android.ump.UserMessagingPlatform
import io.flutter.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.math.BigDecimal
import java.util.Currency

class MainActivity : FlutterActivity() {
    private lateinit var consentInformation: ConsentInformation
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

                "reportAdValue" -> {
                    try {
                        val adValue = call.argument<Double>("adValue") ?: 0.0
                        Log.d("Facebook","report value $adValue")
                        AppEventsLogger.newLogger(this)
                            .logPurchase(BigDecimal(adValue / 1000000), Currency.getInstance("USD"))
                    } catch (e:Exception) {
                        Log.d("Facebook","$e")
                    }
                }
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        initUmp()
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
        Log.d("Facebook", "init $fbId $fbToken")
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

    private fun initUmp(){
        val params = ConsentRequestParameters.Builder().build()
        val startUmpTime = System.currentTimeMillis()
        consentInformation = UserMessagingPlatform.getConsentInformation(activity)
        //consentInformation.reset()
        consentInformation.requestConsentInfoUpdate(activity, params, {
            UserMessagingPlatform.loadAndShowConsentFormIfRequired(
                activity
            ) { loadAndShowError ->
                // Consent gathering failed.
                if (loadAndShowError != null) {
                    Log.d("UMP", "$loadAndShowError")
                }
                // Consent has been gathered.
                if (consentInformation.canRequestAds()) {
                    Log.d("UMP","can request ads")
                    AppMessageSender.send(AppMessage("ad_enable"))
                } else {
                    Log.d("UMP","can not request ads")
                    AppMessageSender.send(AppMessage("ad_lock"))
                }
            }
        }) { requestConsentError ->
            // Consent gathering failed.
            Log.d("UMP","request consent error")
            AppMessageSender.send(AppMessage("ad_enable"))
            // recheckAd(true)
        }
    }
}
