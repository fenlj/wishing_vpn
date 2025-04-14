import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wishing_vpn/ext/log.dart';
import 'package:wishing_vpn/fb/ad_ctrl.dart';
import 'package:wishing_vpn/fb/user_refer_ctrl.dart';
import 'package:wishing_vpn/pages/pages.dart';
import 'package:wishing_vpn/pages/splash/auto_progress_bar.dart';
import 'package:wishing_vpn/resource/assets.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Worker? _worker;
  final _pbKey = GlobalKey<AutoProgressBarState>();
  @override
  void initState() {
    super.initState();
    Log.i("splash initState ${UserReferCtrl.ins.isReferInitialized.value}",
        tag: "splash");
    _worker = ever(
      UserReferCtrl.ins.isReferInitialized,
      (c) => _openAd(),
    );
    if (UserReferCtrl.ins.isReferInitialized.value) {
      _openAd();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _worker?.dispose();
  }

  void _openAd() {
    if (UserReferCtrl.ins.canShowAd()) {
      AdCtrl.instance.loadAd(
        AdPosition.interOne,
        onSuccess: () {
          _pbKey.currentState?.completeProgress();
        },
        onFailed: (e) {},
      );
    } else {
      _pbKey.currentState?.completeProgress();
    }
  }

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
                  key: _pbKey,
                  maxWaitTime: const Duration(seconds: 18),
                  onFirstStageComplete: () {},
                  onComplete: () {
                    AdCtrl.instance.showAd(AdPosition.interOne);
                    Get.offAllNamed(RoutePaths.home);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
