import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wishing_vpn/pages/pages.dart';
import 'package:wishing_vpn/pages/splash/auto_progress_bar.dart';
import 'package:wishing_vpn/resource/assets.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(Assets.appBackPNG), fit: BoxFit.fill)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(Assets.appLogoPNG, width: 100, height: 100),
              const SizedBox(height: 28),
              Image.asset(Assets.appTextPNG, width: 155, height: 28),
              const SizedBox(height: 36),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 112),
                child: AutoProgressBar(
                  maxWaitTime: const Duration(seconds: 4),
                  onFirstStageComplete: () {},
                  onComplete: () => Get.offAllNamed(RoutePaths.home),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
