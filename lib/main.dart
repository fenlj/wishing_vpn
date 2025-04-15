import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wishing_vpn/controllers/vpn_ctrl.dart';
import 'package:wishing_vpn/ext/log.dart';
import 'package:wishing_vpn/fb/ad_ctrl.dart';
import 'package:wishing_vpn/fb/remote_config_ctrl.dart';
import 'package:wishing_vpn/fb/user_refer_ctrl.dart';
import 'package:wishing_vpn/pages/pages.dart';

const messageChannel = EventChannel('wishing.event');
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late StreamSubscription _messageSub;
  @override
  void initState() {
    super.initState();
    _messageSub = messageChannel.receiveBroadcastStream().listen((event) {
      Log.d(event, tag: "NATIVE_EVENT");
      var ej = jsonDecode(event);
      var eventName = ej['name'];
      if (eventName == 'route_event') {
        var op = ej['op'];
        var currentRoute = Get.currentRoute;
        if (op == 'restart' &&
            currentRoute != RoutePaths.splash &&
            Get.isDialogOpen == false &&
            !AdCtrl.instance.isAnyAdOnShow) {
          Get.offAllNamed(RoutePaths.splash);
        }
        AdCtrl.instance.isAnyAdOnShow = false;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _messageSub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Wishing VPN',
      initialBinding: BindingsBuilder(() {
        Get.put(VpnCtrl());
        Get.put(RemoteConfigCtrl()..initialize());
        Get.put(UserReferCtrl());
        Get.put(AdCtrl());
      }),
      initialRoute: RoutePaths.splash,
      getPages: AppPages.pages,
    );
  }
}
