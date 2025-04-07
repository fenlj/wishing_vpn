import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wishing_vpn/controllers/vpn_ctrl.dart';
import 'package:wishing_vpn/resource/assets.dart';

final List<String> _signalStrengthAssets = [
  Assets.iconP1,
  Assets.iconP2,
  Assets.iconP3,
  Assets.iconP4,
];

class ServersPage extends GetView<VpnCtrl> {
  const ServersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.appBackPNG),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                title: const Text(
                  'Select Region',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                centerTitle: true,
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: Colors.transparent,
              ),
              Expanded(
                child: GetBuilder<VpnCtrl>(
                  builder: (ctrl) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.separated(
                      itemCount: ctrl.vpnServerList.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) => _buildServerItem(
                        ctrl.vpnServerList[index].serverName,
                        flagAsset: Assets.iconLocationPNG,
                        isSelected: ctrl.selectedVpnServer?.serverName ==
                            ctrl.vpnServerList[index].serverName,
                        signalStrength: 2,
                        onTap: () {
                          Get.back();
                          ctrl.startVpn(ctrl.vpnServerList[index]);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServerItem(
    String title, {
    String? flagAsset,
    Icon? icon,
    bool isSelected = false,
    int signalStrength = 0,
    VoidCallback? onTap,
  }) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (flagAsset != null)
                  Image.asset(
                    flagAsset,
                    width: 24,
                    height: 24,
                  )
                else if (icon != null)
                  icon,
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                Image.asset(
                  _signalStrengthAssets[signalStrength],
                  width: 18,
                  height: 18,
                ),
                const SizedBox(width: 8),
                if (isSelected)
                  const Icon(
                    Icons.check,
                    color: Color(0xffFDCC40),
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
