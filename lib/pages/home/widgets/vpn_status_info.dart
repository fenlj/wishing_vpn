import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wishing_vpn/controllers/vpn_ctrl.dart';
import 'package:wishing_vpn/ext/ext.dart';

class VpnStatusInfo extends StatelessWidget {
  const VpnStatusInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VpnCtrl>(builder: (ctrl) {
      var isConnected = ctrl.vpnState == VpnState.connected;
      var status = ctrl.vpnStatus;
      return Container(
        width: Get.width,
        height: 60,
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color(0x661c2257),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    isConnected
                        ? status?.byteIn?.formatBytes() ?? "0"
                        : "0kb/s",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  Text(
                    'Download',
                    style: TextStyle(color: Color(0xffA3A1E0), fontSize: 14),
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    isConnected
                        ? status?.byteOut?.formatBytes() ?? "0"
                        : "0kb/s",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  Text(
                    'upload',
                    style: TextStyle(color: Color(0xffA3A1E0), fontSize: 14),
                  )
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
