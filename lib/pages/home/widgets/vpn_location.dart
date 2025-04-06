import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:wishing_vpn/controllers/vpn_ctrl.dart';
import 'package:wishing_vpn/resource/assets.dart';

class VpnLocation extends StatelessWidget {
  const VpnLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VpnCtrl>(builder: (ctrl) {
      return Container(
        width: 200,
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Color(0xff0b0f26),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Image.asset(Assets.iconLocationPNG, width: 13, height: 16),
            Gap(16),
            Text(
              ctrl.selectedVpnServer?.serverName ?? 'Auto Choose',
              style: TextStyle(color: Color(0xffA3A1E0), fontSize: 14),
            ),
            Spacer(),
            Image.asset(Assets.iconArrowNextPNG, width: 5, height: 8),
          ],
        ),
      );
    });
  }
}
