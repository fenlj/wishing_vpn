import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wishing_vpn/pages/pages.dart';
import 'package:wishing_vpn/resource/assets.dart';

class AddSuccessDialog extends StatefulWidget {
  const AddSuccessDialog({super.key, required this.mins});
  final int mins;

  static void show(int mins) {
    if (Get.isDialogOpen == true) return;
    Get.until((r) => Get.currentRoute == RoutePaths.home);
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: AddSuccessDialog(
          mins: mins,
        ),
      ),
      barrierDismissible: false,
      name: 'loading_add',
    );
  }

  @override
  State<AddSuccessDialog> createState() => _AddSuccessDialogState();
}

class _AddSuccessDialogState extends State<AddSuccessDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(color: Colors.transparent),
      child: Center(
        child: SizedBox(
          width: Get.width * 0.88,
          height: 242,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                bottom: 0,
                child: Container(
                  constraints: BoxConstraints.expand(
                    height: 210,
                    width: Get.width * 0.88,
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Assets.dialogBg),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Image.asset(Assets.imgAddSuccess, width: 72, height: 72),
              Column(
                children: [
                  Gap(90),
                  Text(
                    '+ ${widget.mins} mins',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gap(16),
                  Text(
                    'Great! You have free time: ${widget.mins} mins',
                    style: TextStyle(
                      color: Color(0xffA3A1E0),
                    ),
                  ),
                  Gap(16),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 220,
                      height: 56,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(Assets.btnGetBg),
                          fit: BoxFit.fill,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Got it',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
