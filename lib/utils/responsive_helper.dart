import 'package:flutter/material.dart';

/// 반응형 디자인을 위한 헬퍼 클래스
class ResponsiveHelper {
  /// 작은 화면인지 확인 (높이 600 미만)
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.height < 600;
  }

  /// 매우 작은 화면인지 확인 (높이 500 미만)
  static bool isVerySmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.height < 500;
  }

  /// 가로 모드인지 확인
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// 화면 높이에 따른 폰트 크기 조정
  static double getResponsiveFontSize(BuildContext context, {
    required double normal,
    required double small,
    double? verySmall,
  }) {
    if (isVerySmallScreen(context)) {
      return verySmall ?? small * 0.9;
    }
    if (isSmallScreen(context)) {
      return small;
    }
    return normal;
  }

  /// 화면 높이에 따른 여백 조정
  static double getResponsiveSpacing(BuildContext context, {
    required double normal,
    required double small,
    double? verySmall,
  }) {
    if (isVerySmallScreen(context)) {
      return verySmall ?? small * 0.8;
    }
    if (isSmallScreen(context)) {
      return small;
    }
    return normal;
  }

  /// 화면 높이에 따른 버튼 높이 조정
  static double getResponsiveButtonHeight(BuildContext context, {
    required double normal,
    required double small,
  }) {
    if (isSmallScreen(context)) {
      return small;
    }
    return normal;
  }
}

