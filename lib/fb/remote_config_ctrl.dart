import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';
import 'package:wishing_vpn/ext/log.dart';
import 'package:wishing_vpn/fb/user_refer_ctrl.dart';

class RemoteConfigCtrl extends GetxController {
  static RemoteConfigCtrl get ins => Get.find();
  final _remoteConfig = FirebaseRemoteConfig.instance;

  static const String _defaultConfig = '''
  {
    "fbid": "blank",
    "fbtoken": "blank",
    "showlimit_all": 80,
    "clicklimit_all": 20,
    "one_sdkkey": "blank",
    "refer": {
      "refer_control": true,
      "utm_campaign": [
        "fb4a",
        "gclid",
        "youtubeads",
        "apps.facebook.com",
        "apps.instagram.com"
      ]
    },
    "interstitial_info": [
      {
        "position": "inter_one",
        "ads_type": "open",
        "ad_ids": ["ca-app-pub-3940256099942544/9257395921"],
        "showlimit": 500,
        "clicklimit": 50
      },
      {
        "position": "inter_two",
        "ads_type": "inter",
        "ad_ids": ["ca-app-pub-3940256099942544/5224354917"],
        "showlimit": 500,
        "clicklimit": 50
      },
      {
        "position": "inter_three",
        "ads_type": "inter",
        "ad_ids": ["ca-app-pub-3940256099942544/5224354917"],
        "showlimit": 500,
        "clicklimit": 50
      }
    ]
  }
  ''';

  Map<String, dynamic>? _cachedConfig;

  Map<String, dynamic> get _config {
    if (_cachedConfig != null) return _cachedConfig!;

    try {
      _cachedConfig = jsonDecode(_remoteConfig.getString('config'));
    } catch (e) {
      _cachedConfig = jsonDecode(_defaultConfig);
    }
    return _cachedConfig!;
  }

  Future<void> initialize() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));

    await _remoteConfig.setDefaults({
      'config': _defaultConfig,
    });

    try {
      await _remoteConfig.fetchAndActivate();
      _cachedConfig = null; // 清除缓存，确保获取最新配置
    } catch (e) {
      Log.conf('Error fetching remote config: $e');
    } finally {
      Log.conf('Remote config initialized, $_config');
      UserReferCtrl.ins.initialize();
    }
  }

  String get fbid => _config['fbid'] ?? 'blank';
  String get fbtoken => _config['fbtoken'] ?? 'blank';
  int get showlimitAll => _config['showlimit_all'] ?? 80;
  int get clicklimitAll => _config['clicklimit_all'] ?? 20;
  String get oneSdkkey => _config['one_sdkkey'] ?? 'blank';

  bool get referControl => _config['refer']?['refer_control'] ?? true;
  List<String> get utmCampaign =>
      List<String>.from(_config['refer']?['utm_campaign'] ?? []);

  List<Map<String, dynamic>> get interstitialInfo =>
      List<Map<String, dynamic>>.from(_config['interstitial_info'] ?? []);

  Map<String, dynamic>? getInterstitialConfig(String position) {
    try {
      return interstitialInfo
          .firstWhere((info) => info['position'] == position);
    } catch (e) {
      return null;
    }
  }
}
