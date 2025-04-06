import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wishing_vpn/controllers/vpn_ctrl.dart';
import 'package:wishing_vpn/ext/ext.dart';
import 'package:wishing_vpn/resource/assets.dart';

class VpnButton extends StatelessWidget {
  const VpnButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VpnCtrl>(builder: (ctrl) {
      var state = ctrl.vpnState;
      var isConnected = state == VpnState.connected;
      return GestureDetector(
        onTap: () {
          if (state == VpnState.connecting || state == VpnState.disconnecting) {
            return;
          }
          ctrl.toggleVpn();
        },
        child: Container(
          width: Get.width,
          height: 91,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                isConnected ? Assets.vpnBtnConnectPNG : Assets.vpnBtnStoppedPNG,
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 4, // 40%
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 23),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        ctrl.remainingSeconds.formatDuration(),
                        style: TextStyle(
                          fontSize: 20,
                          color: isConnected
                              ? Color(0xffFFCE3E)
                              : Color(0xffA3A1E0),
                        ),
                      ),
                      Text(
                        'Duration',
                        style:
                            TextStyle(fontSize: 14, color: Color(0xffA3A1E0)),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 6, // 60%
                  child: Container(
                    padding: EdgeInsets.only(top: 23),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(state.icon, width: 20, height: 20),
                        Gap(12),
                        Text(
                          state.btnText,
                          style: TextStyle(
                            fontSize: 24,
                            color: isConnected
                                ? Color(0xffA3A1E0)
                                : Color(0xffFFCE3E),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      );
    });
  }
}
