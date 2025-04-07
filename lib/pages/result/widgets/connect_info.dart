import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wishing_vpn/controllers/vpn_ctrl.dart';
import 'package:wishing_vpn/resource/assets.dart';

class ConnectInfo extends StatelessWidget {
  const ConnectInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: 120,
      margin: EdgeInsets.symmetric(horizontal: 26),
      decoration: BoxDecoration(
        color: Color(0x662b3378),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Color(0xff2b3378), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Gap(16),
                Image.asset(
                  Assets.iconResTime,
                  width: 16,
                  height: 15,
                ),
                Gap(8),
                Text(
                  'Duration:',
                  style: TextStyle(
                    color: Color(0xffA3A1E0),
                    fontSize: 14,
                  ),
                ),
                Spacer(),
                GetBuilder<VpnCtrl>(builder: (ctrl) {
                  return Text(
                    ctrl.vpnStatus?.duration ?? "00:00:00",
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xffFFCE3F),
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
                Gap(16),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Gap(16),
                Image.asset(
                  Assets.iconResLocation,
                  width: 16,
                  height: 15,
                ),
                Gap(8),
                Text(
                  'IP Address:',
                  style: TextStyle(
                    color: Color(0xffA3A1E0),
                    fontSize: 14,
                  ),
                ),
                Spacer(),
                GetBuilder<VpnCtrl>(builder: (ctrl) {
                  return Text(
                    ctrl.selectedVpnServer?.serverName ?? "Smart sever",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xffFFCE3F),
                    ),
                  );
                }),
                Gap(16),
              ],
            ),
          )
        ],
      ),
    );
  }
}
