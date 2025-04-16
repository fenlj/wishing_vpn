const bool isDev = false;

const String devConfig = """
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
        "ads_type": "reward",
        "ad_ids": ["ca-app-pub-3940256099942544/5224354917"],
        "showlimit": 500,
        "clicklimit": 50
      },
      {
        "position": "inter_three",
        "ads_type": "reward",
        "ad_ids": ["ca-app-pub-3940256099942544/5224354917"],
        "showlimit": 500,
        "clicklimit": 50
      }
    ]
  }""";

const String prodConfig = """
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
        "ad_ids": ["ca-app-pub-4442975717313005/3772216286"],
        "showlimit": 500,
        "clicklimit": 50
      },
      {
        "position": "inter_two",
        "ads_type": "reward",
        "ad_ids": ["ca-app-pub-4442975717313005/1066161892"],
        "showlimit": 500,
        "clicklimit": 50
      },
      {
        "position": "inter_three",
        "ads_type": "reward",
        "ad_ids": ["ca-app-pub-4442975717313005/1066161892"],
        "showlimit": 500,
        "clicklimit": 50
      }
    ]
  }""";
