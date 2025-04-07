import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wishing_vpn/controllers/vpn_ctrl.dart';
import 'package:wishing_vpn/pages/dialog/loading_dialog.dart';
import 'package:wishing_vpn/resource/assets.dart';

class MoreOpGroup extends StatelessWidget {
  const MoreOpGroup({super.key, this.isShowFixNetwork = false});
  final bool isShowFixNetwork;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VpnCtrl>(builder: (ctrl) {
      var isConnected = ctrl.vpnState == VpnState.connected;
      return isConnected
          ? Container(
              constraints: BoxConstraints.expand(height: 108),
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        LoadingDialog.show(10);
                      },
                      child: Container(
                        height: 108,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(Assets.moreBg1),
                            fit: BoxFit.fill,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 8,
                          children: [
                            Text(
                              '+10',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              'Mins',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            Image.asset(
                              Assets.iconArrowNext1PNG,
                              width: 18,
                              height: 18,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        LoadingDialog.show(15);
                      },
                      child: Container(
                        height: 108,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(Assets.moreBg2),
                            fit: BoxFit.fill,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 8,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 8,
                              children: [
                                Image.asset(
                                  Assets.iconAdd15PNG,
                                  width: 24,
                                  height: 24,
                                ),
                                Text(
                                  '+15',
                                  style: TextStyle(
                                    color: Color(0xffFDCC40),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Mins',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            Image.asset(
                              Assets.iconArrowNext1PNG,
                              width: 18,
                              height: 18,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (isShowFixNetwork)
                    Expanded(
                      child: Container(
                        height: 108,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(Assets.moreBg2),
                            fit: BoxFit.fill,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 8,
                          children: [
                            Image.asset(
                              Assets.iconFixPNG,
                              width: 24,
                              height: 24,
                            ),
                            Text(
                              'Fix network',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            Image.asset(
                              Assets.iconArrowNext1PNG,
                              width: 18,
                              height: 18,
                            )
                          ],
                        ),
                      ),
                    )
                ],
              ),
            )
          : SizedBox.shrink();
    });
  }
}
