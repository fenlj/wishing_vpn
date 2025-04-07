import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wishing_vpn/pages/home/widgets/more_op_group.dart';
import 'package:wishing_vpn/pages/home/widgets/vpn_status_info.dart';
import 'package:wishing_vpn/pages/result/widgets/connect_info.dart';
import 'package:wishing_vpn/resource/assets.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late bool isToConnected;

  @override
  void initState() {
    super.initState();
    isToConnected = Get.arguments == 'connected';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.appBackPNG),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppBar(
                title: Text(
                  isToConnected ? 'Connected' : 'Disconnected',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                centerTitle: true,
                iconTheme: IconThemeData(color: Colors.white),
                backgroundColor: Colors.transparent,
              ),
              Gap(26),
              Image.asset(
                isToConnected
                    ? Assets.resultConnect
                    : Assets.resultDisconnected,
                width: 276,
                height: 136,
              ),
              Gap(26),
              Text(
                isToConnected ? 'VPN Connected!' : 'VPN Disconnected!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isToConnected ? Color(0xffFFCE3F) : Colors.white,
                ),
              ),
              Gap(36),
              if (isToConnected) ...[
                VpnStatusInfo(),
                MoreOpGroup(isShowFixNetwork: false),
              ],
              if (!isToConnected) ...[
                Gap(24),
                ConnectInfo(),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
