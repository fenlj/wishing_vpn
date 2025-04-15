import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wishing_vpn/ext/log.dart';
import 'package:wishing_vpn/fb/remote_config_ctrl.dart';
import 'package:wishing_vpn/fb/user_refer_ctrl.dart';

enum AdType {
  open, // 开屏广告
  inter, // 插屏广告
  reward; // 激励广告

  String get value {
    switch (this) {
      case AdType.open:
        return 'open';
      case AdType.inter:
        return 'inter';
      case AdType.reward:
        return 'reward';
    }
  }
}

enum AdPosition {
  interOne,
  interTwo,
  interThree;

  String get value {
    switch (this) {
      case AdPosition.interOne:
        return 'inter_one';
      case AdPosition.interTwo:
        return 'inter_two';
      case AdPosition.interThree:
        return 'inter_three';
    }
  }
}

class AdCtrl extends GetxController {
  static AdCtrl get instance => Get.find();

  final _showCounts = <String, int>{}.obs;
  final _clickCounts = <String, int>{}.obs;
  final _totalShowCount = 0.obs;
  final _totalClickCount = 0.obs;
  final _loadingAds = <String, bool>{}.obs;

  final _appOpenAd = Rxn<AppOpenAd>();
  final _interstitialAds = <String, InterstitialAd>{};
  final _rewardedAds = <String, RewardedAd>{};

  bool isAnyAdOnShow = false;

  @override
  void onClose() {
    _disposeAllAds();
    super.onClose();
  }

  void _disposeAllAds() {
    _appOpenAd.value?.dispose();
    for (var ad in _interstitialAds.values) {
      ad.dispose();
    }
    for (var ad in _rewardedAds.values) {
      ad.dispose();
    }
    _interstitialAds.clear();
    _rewardedAds.clear();
  }

  bool canShowAd(AdPosition position) {
    if (!UserReferCtrl.ins.canShowAd()) return false;

    final config = RemoteConfigCtrl.ins;
    final adConfig = config.getInterstitialConfig(position.value);
    if (adConfig == null) return false;

    // 只对插屏广告进行展示和点击限制
    if (adConfig['ads_type'] == AdType.inter.value) {
      // 检查总展示限制
      if (_totalShowCount.value >= config.showlimitAll) {
        Log.d('Ad total imp limit', tag: 'ad');
        return false;
      }
      // 检查总点击限制
      if (_totalClickCount.value >= config.clicklimitAll) {
        Log.d('Ad total click limit', tag: 'ad');
        return false;
      }

      // 检查单个广告位限制
      final showCount = _showCounts[position.value] ?? 0;
      if (showCount >= (adConfig['showlimit'] ?? 0)) {
        Log.d('positon : ${position.value} show limit', tag: 'ad');
        return false;
      }

      final clickCount = _clickCounts[position.value] ?? 0;
      if (clickCount >= (adConfig['clicklimit'] ?? 0)) {
        Log.d('position : ${position.value} click limit', tag: 'ad');
        return false;
      }
    }

    return true;
  }

  Future<void> loadAd(
    AdPosition position, {
    Function()? onSuccess,
    Function(String error)? onFailed,
  }) async {
    if (!canShowAd(position)) {
      onFailed?.call('ad not enable');
      return;
    }
    if (_loadingAds[position.value] == true) {
      onFailed?.call('ad is loading');
      return;
    }

    final config = RemoteConfigCtrl.ins;
    final adConfig = config.getInterstitialConfig(position.value);
    if (adConfig == null) {
      onFailed?.call('ad config is null');
      return;
    }

    final adIds = List<String>.from(adConfig['ad_ids'] ?? []);
    if (adIds.isEmpty) {
      onFailed?.call('ad ids is empty');
      return;
    }

    _loadingAds[position.value] = true;
    await Future.delayed(Duration(milliseconds: 300));
    try {
      switch (adConfig['ads_type']) {
        case 'open':
          await _loadAppOpenAd(position, adIds.first, onSuccess, onFailed);
          break;
        case 'inter':
          await _loadInterstitialAd(position, adIds.first, onSuccess, onFailed);
          break;
        case 'reward':
          await _loadRewardedAd(position, adIds.first, onSuccess, onFailed);
          break;
      }
    } catch (e) {
      _loadingAds[position.value] = false;
      Log.e('ad load failure: ${position.value}, $e', tag: 'ad');
      onFailed?.call(e.toString());
    }
  }

  Future<void> _loadAppOpenAd(
    AdPosition position,
    String adUnitId,
    Function()? onSuccess,
    Function(String)? onFailed,
  ) async {
    Log.d('open ad start load: ${position.value}', tag: 'ad');
    await AppOpenAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _loadingAds[position.value] = false;
          _appOpenAd.value = ad;
          _setupAppOpenAdCallbacks(position, ad);
          Log.d('open ad load success: ${position.value}', tag: 'ad');
          onSuccess?.call();
        },
        onAdFailedToLoad: (error) {
          _loadingAds[position.value] = false;
          Log.e('open ad load failure: ${position.value}, ${error.message}',
              tag: 'ad');
          onFailed?.call(error.message);
        },
      ),
    );
  }

  Future<void> _loadInterstitialAd(
    AdPosition position,
    String adUnitId,
    Function()? onSuccess,
    Function(String)? onFailed,
  ) async {
    Log.d('ins ad start load: ${position.value}', tag: 'ad');
    await InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _loadingAds[position.value] = false;
          _interstitialAds[position.value] = ad;
          _setupInterstitialAdCallbacks(position, ad);
          Log.d('ins ad load success: ${position.value}', tag: 'ad');
          onSuccess?.call();
        },
        onAdFailedToLoad: (error) {
          _loadingAds[position.value] = false;
          Log.e('ins ad load failure: ${position.value}, ${error.message}',
              tag: 'ad');
          onFailed?.call(error.message);
        },
      ),
    );
  }

  Future<void> _loadRewardedAd(
    AdPosition position,
    String adUnitId,
    Function()? onSuccess,
    Function(String)? onFailed,
  ) async {
    Log.d('reward ad start load: ${position.value}', tag: 'ad');
    await RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _loadingAds[position.value] = false;
          _rewardedAds[position.value] = ad;
          _setupRewardedAdCallbacks(position, ad);
          Log.d('reward ad load success: ${position.value}', tag: 'ad');
          onSuccess?.call();
        },
        onAdFailedToLoad: (error) {
          _loadingAds[position.value] = false;
          Log.e('reward ad load failure: ${position.value}, ${error.message}',
              tag: 'ad');
          onFailed?.call(error.message);
        },
      ),
    );
  }

  void _setupAppOpenAdCallbacks(AdPosition position, AppOpenAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _recordShow(position);
        isAnyAdOnShow = true;
      },
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _appOpenAd.value = null;
      },
      onAdClicked: (ad) {
        _recordClick(position);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _appOpenAd.value = null;
      },
    );
  }

  void _setupInterstitialAdCallbacks(AdPosition position, InterstitialAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _recordShow(position);
        isAnyAdOnShow = true;
      },
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAds.remove(position.value);
      },
      onAdClicked: (ad) {
        _recordClick(position);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAds.remove(position.value);
      },
    );
  }

  void _setupRewardedAdCallbacks(AdPosition position, RewardedAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _recordShow(position);
        isAnyAdOnShow = true;
      },
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAds.remove(position.value);
      },
      onAdClicked: (ad) {
        _recordClick(position);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAds.remove(position.value);
      },
    );
  }

  void _recordShow(AdPosition position) {
    _showCounts[position.value] = (_showCounts[position.value] ?? 0) + 1;
    _totalShowCount.value++;
    Log.d('ad show: ${position.value}', tag: 'ad');
  }

  void _recordClick(AdPosition position) {
    _clickCounts[position.value] = (_clickCounts[position.value] ?? 0) + 1;
    _totalClickCount.value++;
    Log.d('ad click: ${position.value}', tag: 'ad');
  }

  Future<bool> showAd(AdPosition position,
      {Function(int amount)? onRewarded}) async {
    if (!canShowAd(position)) return false;

    final config = RemoteConfigCtrl.ins;
    final adConfig = config.getInterstitialConfig(position.value);
    if (adConfig == null) return false;

    try {
      switch (adConfig['ads_type']) {
        case 'open':
          final ad = _appOpenAd.value;
          if (ad == null) {
            await loadAd(position);
            return false;
          }
          await ad.show();
          return true;

        case 'inter':
          final ad = _interstitialAds[position.value];
          if (ad == null) {
            await loadAd(position);
            return false;
          }
          await ad.show();
          return true;

        case 'reward':
          final ad = _rewardedAds[position.value];
          if (ad == null) {
            await loadAd(position);
            return false;
          }
          await ad.show(onUserEarnedReward: (ad, reward) {
            onRewarded?.call(reward.amount.toInt());
          });
          return true;
      }
    } catch (e) {
      Log.e('ad show failure: ${position.value}, $e', tag: 'ad');
    }
    return false;
  }
}
