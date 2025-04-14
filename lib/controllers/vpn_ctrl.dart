import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oneconnect_flutter/openvpn_flutter.dart';
import 'package:wishing_vpn/pages/dialog/executing_dialog.dart';
import 'package:wishing_vpn/resource/assets.dart';

// const String apiKey = '4.ybL4psDW856z1En0qLR73H3l.9tuImZHmuV0aWu4nr1nvA4k';
const String apiKey = 'QteI0cixbMpTO6PY4LI5mHnRYAL8vThxJc..VdKpigaca06FGt';

enum VpnState { stopped, connecting, connected, disconnecting, error }

extension VpnStateExtension on VpnState {
  String get btnText {
    switch (this) {
      case VpnState.stopped:
        return "Start Now";
      case VpnState.connecting:
        return "Connecting";
      case VpnState.connected:
        return "Tap to Stop";
      case VpnState.disconnecting:
        return "Disconnecting";
      case VpnState.error:
        return "Start Now";
    }
  }

  String get icon {
    switch (this) {
      case VpnState.connected:
        return Assets.vpnBtnToStoppedPNG;
      case VpnState.connecting:
        return Assets.vpnBtnConnectingPNG;
      default:
        return Assets.vpnBtnToConnectPNG;
    }
  }
}

class VpnCtrl extends GetxController {
  late OpenVPN engine;
  List<VpnServer> vpnServerList = [];
  VpnStatus? vpnStatus;
  VPNStage vpnStage = VPNStage.disconnected;
  var vpnState = VpnState.stopped;
  VpnServer? selectedVpnServer;
  var vpnStateObs = VpnState.stopped.obs;

  static VpnCtrl get ins => Get.find<VpnCtrl>();

  // 修改倒计时相关属性
  final _remainingSeconds = 0.obs;
  static const int defaultDurationSeconds = 10 * 60; // 默认10分钟
  int _targetDurationSeconds = 0;

  // 获取剩余时间（秒）
  int get remainingSeconds {
    if (vpnState != VpnState.connected) return 0;
    return _targetDurationSeconds -
        _parseVpnDuration(vpnStatus?.duration ?? "00:00:00");
  }

  // 解析 VPN duration 字符串为秒数
  int _parseVpnDuration(String duration) {
    final parts = duration.split(':');
    if (parts.length != 3) return 0;
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    final seconds = int.parse(parts[2]);
    return hours * 3600 + minutes * 60 + seconds;
  }

  void init(BuildContext context) {
    engine = OpenVPN(
        onVpnStageChanged: onVpnStageChanged,
        onVpnStatusChanged: onVpnStatusChanged);
    engine.initializeOneConnect(context, apiKey);
    engine.initialize(
        lastStatus: onVpnStatusChanged,
        lastStage: (stage) => onVpnStageChanged(stage, stage.name));
    fetchVpnServerList();
  }

  void fetchVpnServerList() async {
    try {
      vpnServerList.addAll(await engine.fetchOneConnect(OneConnect.free));
      // vpnServerList.addAll(await engine.fetchOneConnect(OneConnect.pro));
      update();
      for (var config in vpnServerList) {
        debugPrint("vpn server : ${config.serverName} ${config.isFree}");
      }
    } catch (e) {
      debugPrint("fetchVpnServerList error : $e");
    }
  }

  //VPN status changed
  void onVpnStatusChanged(VpnStatus? status) {
    vpnStatus = status;
    if (status != null && vpnState == VpnState.connected) {
      final currentDuration = _parseVpnDuration(status.duration ?? "00:00:00");
      if (currentDuration >= _targetDurationSeconds) {
        stopVpn();
      }
      _remainingSeconds.value = _targetDurationSeconds - currentDuration;
    }
    debugPrint("vpn status : $status $_remainingSeconds ");
  }

  //VPN stage changed
  void onVpnStageChanged(VPNStage stage, String rawStage) {
    vpnStage = stage;
    debugPrint("vpn stage : $stage $rawStage");
    if (stage == VPNStage.error) {
      Future.delayed(const Duration(seconds: 1)).then((value) {
        vpnStage = VPNStage.disconnected;
      });
    }
    if (stage == VPNStage.disconnected) {
      vpnState = VpnState.stopped;
      vpnStateObs.value = VpnState.stopped;
      _remainingSeconds.value = 0;
      _targetDurationSeconds = defaultDurationSeconds;
    }
    if (stage == VPNStage.connected) {
      vpnState = VpnState.connected;
      vpnStateObs.value = VpnState.connected;
    }
    update();
  }

  void toggleVpn() {
    if (vpnState == VpnState.stopped) {
      startVpn(null);
    } else {
      // stopVpn();
      ExecutingDialog.show(false);
    }
  }

  Future<void> startVpn(VpnServer? vpnSever) async {
    vpnSever ??=
        vpnServerList.where((e) => e.isFree == "1").toList().lastOrNull;
    if (vpnSever == null) {
      vpnState = VpnState.error;
      vpnStateObs.value = VpnState.error;
      update();
      return;
    }
    const bool certificateVerify = true; //Turn it on if you use certificate
    String? config;

    try {
      config = await OpenVPN.filteredConfig(vpnSever.ovpnConfiguration);
    } catch (e) {
      config = vpnSever.ovpnConfiguration;
    }

    if (config == null) {
      vpnState = VpnState.error;
      vpnStateObs.value = VpnState.error;
      update();
      return;
    }
    ExecutingDialog.show(true);
    vpnState = VpnState.connecting;
    vpnStateObs.value = VpnState.connecting;
    engine.connect(
      config,
      vpnSever.serverName,
      certIsRequired: certificateVerify,
      username: vpnSever.vpnUserName,
      password: vpnSever.vpnPassword,
    );
    selectedVpnServer = vpnSever;
    update();

    debugPrint("vpn connect ${vpnSever.serverName}");
  }

  Future<void> stopVpn() async {
    if (vpnState == VpnState.stopped) return;
    vpnState = VpnState.disconnecting;
    vpnStateObs.value = VpnState.disconnecting;
    update();
    await Future.delayed(Duration(seconds: 1));
    engine.disconnect();
    selectedVpnServer = null;
    _targetDurationSeconds = defaultDurationSeconds;
    debugPrint("vpn disconnect");
  }

  // 修改延长时间方法
  void extendDuration(int minutes) {
    if (vpnState != VpnState.connected) return;
    _targetDurationSeconds += minutes * 60;
  }
}
