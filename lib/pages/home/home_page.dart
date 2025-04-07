import 'package:flutter/material.dart';
import 'package:wishing_vpn/pages/home/widgets/more_op_group.dart';
import 'package:wishing_vpn/pages/home/widgets/toolbar_location_vpn_button.dart';
import 'package:wishing_vpn/pages/home/widgets/vpn_status_info.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0b0f26),
      body: SafeArea(
        child: Column(
          children: [
            ToolbarLocationVpnButton(),
            VpnStatusInfo(),
            MoreOpGroup(),
          ],
        ),
      ),
    );
  }
}
