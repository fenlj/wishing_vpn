import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wishing_vpn/pages/home/widgets/more_op_group.dart';
import 'package:wishing_vpn/pages/home/widgets/toolbar_location_vpn_button.dart';
import 'package:wishing_vpn/pages/home/widgets/vpn_status_info.dart';
import 'package:wishing_vpn/resource/assets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0b0f26),
      endDrawer: _buildDrawer(),
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

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xff1C2257),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Gap(90),
              Image.asset(Assets.appLogoPNG, width: 80, height: 80),
              Gap(26),
              Image.asset(Assets.appTextPNG, width: 122, height: 22),
              Gap(16),
              Text(
                'version : 1.0.1',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xffA5A3E1),
                ),
              ),
              Gap(46),
              _buildMenuItem(
                path: Assets.iconRate,
                title: 'Rate Us',
                onTap: () {
                  launchUrl(Uri.parse(
                      'https://play.google.com/store/apps/developer?id=com.wishvpn.wishing'));
                },
              ),
              Gap(26),
              _buildMenuItem(
                path: Assets.iconMsg,
                title: 'Share us',
                onTap: () {
                  launchUrl(Uri.parse(
                      'https://play.google.com/store/apps/developer?id=com.wishvpn.wishing'));
                },
              ),
              Gap(26),
              _buildMenuItem(
                path: Assets.iconPp,
                title: 'Privacy Policy',
                onTap: () {
                  launchUrl(
                      Uri.parse('https://sites.google.com/view/wishing-vpn'));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String path,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0x662B3378),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Color(0xff2B3378), width: 1),
        ),
        child: Row(
          children: [
            Image.asset(
              path,
              width: 20,
              height: 20,
            ),
            Gap(8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Spacer(),
            Image.asset(
              Assets.iconArrowNext1PNG,
              width: 18,
              height: 18,
            )
          ],
        ),
      ),
    );
  }
}
