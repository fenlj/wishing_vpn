import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wishing_vpn/controllers/vpn_ctrl.dart';
import 'package:wishing_vpn/pages/home/widgets/app_toolbar.dart';
import 'package:wishing_vpn/pages/home/widgets/vpn_button.dart';
import 'package:wishing_vpn/pages/home/widgets/vpn_location.dart';
import 'package:wishing_vpn/resource/assets.dart';

class ToolbarLocationVpnButton extends StatelessWidget {
  const ToolbarLocationVpnButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VpnCtrl>(
      builder: (ctrl) {
        var isConnected = ctrl.vpnState == VpnState.connected;
        return Container(
          width: Get.width,
          height: Get.height * 0.62,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                isConnected ? Assets.vpnConnectedBgPNG : Assets.vpnStoppBgPNG,
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              AppToolbar(),
              Gap(10),
              VpnLocation(),
              Spacer(),
              VpnButton(),
            ],
          ),
        );
      },
    );
  }
}
