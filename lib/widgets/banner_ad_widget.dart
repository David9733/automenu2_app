import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../utils/logger.dart';

/// 배너 광고 위젯
class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  // Android와 iOS 광고 단위 ID
  final String _androidAdUnitId = 'ca-app-pub-1380120956106792/9736325491';
  final String _iosAdUnitId = 'ca-app-pub-1380120956106792/6730888201';

  @override
  void initState() {
    super.initState();
    // 릴리스 모드에서만 광고 로드
    if (!kDebugMode) {
      _loadBannerAd();
    }
  }

  /// 배너 광고 로드
  void _loadBannerAd() {
    final adUnitId = Platform.isAndroid ? _androidAdUnitId : _iosAdUnitId;

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) {
            setState(() {
              _isAdLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          AppLogger.error('배너 광고 로드 실패', error);
          ad.dispose();
        },
        onAdOpened: (_) {
          AppLogger.debug('배너 광고 열림');
        },
        onAdClosed: (_) {
          AppLogger.debug('배너 광고 닫힘');
          // 광고가 닫힌 후 다시 로드
          _loadBannerAd();
        },
      ),
    );

    _bannerAd?.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 디버그 모드에서는 광고를 표시하지 않음
    if (kDebugMode) {
      return const SizedBox.shrink();
    }

    // 실제 광고가 로드되었을 때만 표시
    if (_isAdLoaded && _bannerAd != null) {
      return Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: _bannerAd!.size.height.toDouble(),
        color: Colors.transparent,
        child: AdWidget(ad: _bannerAd!),
      );
    }

    // 광고가 로드되지 않았으면 아무것도 표시하지 않음
    return const SizedBox.shrink();
  }
}

