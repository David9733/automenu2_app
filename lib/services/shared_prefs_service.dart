import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/logger.dart';

/// SharedPreferences 싱글톤 서비스
/// SharedPreferences 인스턴스를 한 번만 생성하고 재사용합니다.
class SharedPrefsService {
  static SharedPreferences? _instance;
  
  /// SharedPreferences 인스턴스 가져오기 (싱글톤)
  /// 첫 호출 시에만 인스턴스를 생성하고, 이후에는 캐시된 인스턴스를 반환합니다.
  static Future<SharedPreferences> get instance async {
    if (_instance != null) {
      return _instance!;
    }
    
    try {
      AppLogger.debug('💾 SharedPreferences 인스턴스 생성 시작...');
      final startTime = DateTime.now();
      
      _instance = await SharedPreferences.getInstance()
          .timeout(
            const Duration(milliseconds: 500),  // 500ms로 단축
            onTimeout: () {
              AppLogger.error('⚠️ SharedPreferences 타임아웃');
              throw TimeoutException('SharedPreferences 초기화 타임아웃');
            },
          );
      
      final elapsed = DateTime.now().difference(startTime).inMilliseconds;
      AppLogger.debug('✅ SharedPreferences 인스턴스 생성 완료 (${elapsed}ms)');
      
      return _instance!;
    } catch (e, stackTrace) {
      AppLogger.error('❌ SharedPreferences 인스턴스 생성 실패', e, stackTrace);
      rethrow;
    }
  }
  
  /// 캐시된 인스턴스 초기화 (테스트용)
  static void clearCache() {
    _instance = null;
  }
}
