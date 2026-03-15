import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import '../utils/logger.dart';

/// AdMob 광고 관리 서비스
class AdMobService {
  // 전면 광고 단위 ID (플랫폼별)
  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      // Android 전면 광고 단위 ID
      return 'ca-app-pub-1380120956106792/9736325491';
    } else if (Platform.isIOS) {
      // iOS 전면 광고 단위 ID
      return 'ca-app-pub-1380120956106792/6730888201';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
  
  // 테스트용 광고 단위 ID (개발 중 사용)
  static String get testInterstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712'; // Android 테스트 ID
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910'; // iOS 테스트 ID
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
  
  static InterstitialAd? _interstitialAd;
  static bool _isInterstitialAdReady = false;
  static bool _isLoadingAd = false;

  /// AdMob 초기화
  static Future<void> initialize() async {
    try {
      await MobileAds.instance.initialize();
      AppLogger.debug('✅ AdMob 초기화 완료');
      
      // 전면 광고 미리 로드
      loadInterstitialAd();
    } catch (e) {
      AppLogger.error('❌ AdMob 초기화 실패', e);
    }
  }

  /// 전면 광고 로드
  static void loadInterstitialAd() {
    if (_isLoadingAd || _isInterstitialAdReady) {
      return;
    }

    _isLoadingAd = true;
    final adUnitId = kDebugMode ? testInterstitialAdUnitId : interstitialAdUnitId;

    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          AppLogger.debug('✅ 전면 광고 로드 완료');
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
          _isLoadingAd = false;

          // 광고 이벤트 리스너 설정
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              AppLogger.debug('전면 광고 닫힘');
              _disposeInterstitialAd();
              // 광고가 닫힌 후 새로운 광고 로드
              loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
              AppLogger.error('전면 광고 표시 실패', error);
              _disposeInterstitialAd();
              // 실패 후 새로운 광고 로드
              loadInterstitialAd();
            },
            onAdShowedFullScreenContent: (InterstitialAd ad) {
              AppLogger.debug('전면 광고 표시됨');
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          AppLogger.error('❌ 전면 광고 로드 실패', error);
          _isLoadingAd = false;
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  /// 전면 광고 표시
  static Future<bool> showInterstitialAd() async {
    if (!_isInterstitialAdReady || _interstitialAd == null) {
      AppLogger.debug('⚠️ 전면 광고가 준비되지 않았습니다. 로드 중...');
      // 광고가 없으면 로드 시도
      loadInterstitialAd();
      return false;
    }

    try {
      _interstitialAd?.show();
      _isInterstitialAdReady = false;
      return true;
    } catch (e) {
      AppLogger.error('❌ 전면 광고 표시 실패', e);
      return false;
    }
  }

  /// 전면 광고 메모리 해제
  static void _disposeInterstitialAd() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isInterstitialAdReady = false;
  }

  /// 전면 광고 준비 상태 확인
  static bool get isInterstitialAdReady => _isInterstitialAdReady;
}

