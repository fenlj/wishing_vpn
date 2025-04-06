import 'package:get/get.dart';
import 'package:wishing_vpn/controllers/vpn_ctrl.dart';
import 'package:wishing_vpn/pages/home/home_page.dart';
import 'package:wishing_vpn/pages/splash/splash_page.dart';

abstract class RoutePaths {
  static const splash = '/splash';
  static const home = '/home';
}

abstract class AppPages {
  static final pages = [
    GetPage(
      name: RoutePaths.splash,
      page: () => const SplashPage(),
      binding: BindingsBuilder(() {
        final vpnCtrl = Get.find<VpnCtrl>();
        vpnCtrl.init(Get.context!);
      }),
    ),
    GetPage(name: RoutePaths.home, page: () => const HomePage()),
  ];
}
