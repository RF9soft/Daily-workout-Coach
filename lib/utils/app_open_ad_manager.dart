import 'package:google_mobile_ads/google_mobile_ads.dart';

class OpenAdManager {
  AppOpenAd? _appOpenAd;
  bool _isAdAvailable = false;

  void loadAd() {
    AppOpenAd.load(
      adUnitId: 'ca-app-pub-3254074284549678/3751659006',
      request: AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _isAdAvailable = true;
        },
        onAdFailedToLoad: (error) {
          _isAdAvailable = false;
        },
      ),
    );
  }

  void showAdIfAvailable() {
    if (_isAdAvailable) {
      _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          _appOpenAd = null;
          _isAdAvailable = false;
          loadAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          _appOpenAd = null;
          _isAdAvailable = false;
          loadAd();
        },
      );
      _appOpenAd!.show();
    } else {
      loadAd();
    }
  }
}
