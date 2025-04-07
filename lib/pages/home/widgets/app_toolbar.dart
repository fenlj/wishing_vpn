import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wishing_vpn/resource/assets.dart';

class AppToolbar extends StatelessWidget {
  const AppToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: 58,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(Assets.appTextPNG, width: 122, height: 22),
          GestureDetector(
            onTap: () => Scaffold.of(context).openEndDrawer(),
            child: Image.asset(Assets.iconMenuPNG, width: 18, height: 18),
          ),
        ],
      ),
    );
  }
}
