import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wishing_vpn/controllers/vpn_ctrl.dart';
import 'package:wishing_vpn/pages/dialog/add_success_dialog.dart';
import 'package:wishing_vpn/pages/pages.dart';
import 'package:wishing_vpn/pages/splash/auto_progress_bar.dart';

bool isNeedShowAddDialog = false;
bool isNeedShowSpeedDialog = false;

class LoadingDialog extends StatefulWidget {
  const LoadingDialog({
    super.key,
    required this.mins,
    required this.onEnd,
  });
  final int mins;
  final VoidCallback onEnd;

  static void show(int mins) {
    if (Get.isDialogOpen == true) {
      return;
    }
    Get.until((r) => Get.currentRoute == RoutePaths.home);
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: LoadingDialog(
          mins: mins,
          onEnd: () async {
            Get.until((r) => r.settings.name == RoutePaths.home);
            VpnCtrl.ins.extendDuration(mins);
            await Future.delayed(const Duration(milliseconds: 200));
            AddSuccessDialog.show(mins);
          },
        ),
      ),
      barrierDismissible: false,
      name: 'loading_add',
    );
    isNeedShowAddDialog = false;
  }

  // static void status() {
  //   if (!VpnCtrl.ins.isPermissionAllow || Get.isDialogOpen == true) {
  //     return;
  //   }
  //   Get.until((r) => Get.currentRoute == screenHome);
  //   Get.dialog(
  //     Dialog(
  //       backgroundColor: Colors.transparent,
  //       insetPadding: EdgeInsets.zero,
  //       child: LoadingDialog(
  //         isAdd: false,
  //         onEnd: () async {
  //           Get.until((r) => r.settings.name == screenHome);
  //           await Future.delayed(const Duration(milliseconds: 200));
  //           Get.toNamed(screenStatus);
  //         },
  //       ),
  //     ),
  //     barrierDismissible: false,
  //     name: 'loading_status',
  //   );
  //   isNeedShowSpeedDialog = false;
  // }

  @override
  State<StatefulWidget> createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  late DateTime startTime;
  late int mins;
  @override
  void initState() {
    super.initState();
    mins = widget.mins;
    startTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        constraints: const BoxConstraints.expand(
          width: 255,
          height: 255,
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
                    maxWaitTime: Duration(seconds: 1),
                    onComplete: () => widget.onEnd(),
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
