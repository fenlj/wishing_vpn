import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wishing_vpn/controllers/vpn_ctrl.dart';
import 'package:wishing_vpn/fb/ad_ctrl.dart';
import 'package:wishing_vpn/pages/pages.dart';
import 'package:wishing_vpn/pages/splash/auto_progress_bar.dart';

var isLastToConnected = false;

class ExecutingDialog extends StatefulWidget {
  const ExecutingDialog({
    super.key,
    required this.isToConnected,
    required this.onEnd,
    this.onFirstStageEnd,
  });
  final bool isToConnected;
  final VoidCallback onEnd;
  final VoidCallback? onFirstStageEnd;

  static void show(bool isToConnected, {VoidCallback? onEnd}) {
    if (Get.isDialogOpen == true) return;
    Get.until((r) => Get.currentRoute == RoutePaths.home);
    isLastToConnected = isToConnected;
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: ExecutingDialog(
          isToConnected: isToConnected,
          onEnd: () {
            onEnd?.call();
            if (Get.isDialogOpen == true) {
              Get.back();
            }
            if (!isToConnected) {
              VpnCtrl.ins.stopVpn();
            }
            Get.toNamed(
              RoutePaths.result,
              arguments: isToConnected ? 'connected' : 'disconnected',
            );
          },
        ),
      ),
      barrierDismissible: false,
      name: 'dialog_execute',
    );
  }

  @override
  State<StatefulWidget> createState() => _ExecutingDialogState();
}

class _ExecutingDialogState extends State<ExecutingDialog> {
  late DateTime startTime;
  late bool isConnected;
  late bool isAdEnable;
  late bool isAdRequested;
  final _pbKey = GlobalKey<AutoProgressBarState>();

  @override
  void initState() {
    super.initState();
    isConnected = widget.isToConnected;
    startTime = DateTime.now();
    isAdEnable = AdCtrl.instance.canShowAd(AdPosition.interTwo);
    if (isAdEnable) {
      if (isConnected) {
        ever(
          VpnCtrl.ins.vpnStateObs,
          (state) {
            if (state == VpnState.connected && !isAdRequested) {
              _requestAd();
            }
          },
        );
      } else {
        _requestAd();
      }
    } else {
      _pbKey.currentState?.completeProgress();
    }
  }

  void _requestAd() {
    if (isAdRequested) return;
    isAdRequested = true;
    AdCtrl.instance.loadAd(
      AdPosition.interTwo,
      onSuccess: () {
        _pbKey.currentState?.completeProgress();
      },
      onFailed: (e) {
        _pbKey.currentState?.completeProgress();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        constraints: BoxConstraints.expand(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 254,
        ),
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: const BoxDecoration(color: Colors.transparent),
              alignment: Alignment.center,
              child: Stack(
                children: [
                  AutoProgressBar(
                    key: _pbKey,
                    maxWaitTime: Duration(seconds: 18),
                    onComplete: () {
                      if (isAdEnable) {
                        AdCtrl.instance.showAd(AdPosition.interTwo);
                      }
                      widget.onEnd();
                    },
                    isEnableShow: false,
                  ),
                  LoadingAnimationWidget.waveDots(color: Colors.white, size: 44)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
