import 'package:android_play_install_referrer/android_play_install_referrer.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wishing_vpn/ext/log.dart';
import 'package:wishing_vpn/fb/config.dart';
import 'package:wishing_vpn/fb/remote_config_ctrl.dart';

class UserReferCtrl extends GetxController {
  static UserReferCtrl get ins => Get.find();

  final _isAdUser = false.obs;
  bool get isAdUser => _isAdUser.value;

  final isReferInitialized = false.obs;

  static const String _referKey = 'user_install_refer';
  String? _installRefer;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _installRefer = prefs.getString(_referKey);

    if (_installRefer != null) {
      _checkIsAdUser();
      isReferInitialized.value = true;
      return;
    }

    try {
      final referrerDetails = await AndroidPlayInstallReferrer.installReferrer;
      _installRefer = referrerDetails.installReferrer;

      if (_installRefer != null) {
        await prefs.setString(_referKey, _installRefer!);
      }
    } catch (e) {
      Log.conf('Error getting install referrer: $e');
    } finally {
      _checkIsAdUser();
      Log.conf('Is ad user: $_isAdUser, referrer: $_installRefer');
      isReferInitialized.value = true;
    }
  }

  void _checkIsAdUser() {
    final remoteConfig = RemoteConfigCtrl.ins;
    if (!remoteConfig.referControl) {
      _isAdUser.value = true;
      return;
    }

    if (_installRefer == null) {
      _isAdUser.value = false;
      return;
    }

    final utmCampaigns = remoteConfig.utmCampaign;

    _isAdUser.value = utmCampaigns.any((campaign) =>
        _installRefer!.toLowerCase().contains(campaign.toLowerCase()));
  }

  bool canShowAd() {
    final remoteConfig = RemoteConfigCtrl.ins;
    if (isDev) return false;
    if (!remoteConfig.referControl) return true;
    return isAdUser;
  }
}
