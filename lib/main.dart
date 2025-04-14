import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wishing_vpn/controllers/vpn_ctrl.dart';
import 'package:wishing_vpn/fb/ad_ctrl.dart';
import 'package:wishing_vpn/fb/remote_config_ctrl.dart';
import 'package:wishing_vpn/fb/user_refer_ctrl.dart';
import 'package:wishing_vpn/pages/pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

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
