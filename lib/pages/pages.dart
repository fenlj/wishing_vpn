import 'package:get/get.dart';
import 'package:wishing_vpn/pages/home/home_page.dart';
import 'package:wishing_vpn/pages/result/result_page.dart';
import 'package:wishing_vpn/pages/servers/servers_page.dart';
import 'package:wishing_vpn/pages/splash/splash_page.dart';

abstract class RoutePaths {
  static const splash = '/splash';
  static const home = '/home';
  static const result = '/result';
  static const servers = '/servers';
}

abstract class AppPages {
  static final pages = [
    GetPage(
      name: RoutePaths.splash,
      page: () => const SplashPage(),
      binding: BindingsBuilder(() {}),
    ),
    GetPage(name: RoutePaths.home, page: () => const HomePage()),
    GetPage(name: RoutePaths.result, page: () => const ResultPage()),
    GetPage(name: RoutePaths.servers, page: () => const ServersPage()),
  ];
}
