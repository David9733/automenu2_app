import 'package:flutter/foundation.dart';

/// 프로덕션 빌드에서 로그를 제거하는 로거 유틸리티
/// 
/// 디버그 모드에서만 로그를 출력하며, 프로덕션 빌드에서는
/// 로그 관련 코드가 컴파일 타임에 제거되어 성능 최적화를 제공합니다.
class AppLogger {
  /// 디버그 로그 출력
  /// 
  /// [kDebugMode]가 true일 때만 로그를 출력합니다.
  /// 프로덕션 빌드에서는 이 메서드 호출이 완전히 제거됩니다.
  static void debug(String message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }
  
  /// 에러 로그 출력
  /// 
  /// 에러 정보와 스택 트레이스를 포함한 로그를 출력합니다.
  /// 프로덕션 빌드에서는 이 메서드 호출이 완전히 제거됩니다.
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('ERROR: $message');
      if (error != null) {
        debugPrint('Error: $error');
      }
      if (stackTrace != null) {
        debugPrint('StackTrace: $stackTrace');
      }
    }
  }
}

