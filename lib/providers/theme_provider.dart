import 'package:flutter/material.dart';
import '../services/theme_service.dart';
import '../utils/logger.dart';

/// 테마 상태를 관리하는 Provider
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _isLoading = true;

  ThemeMode get themeMode => _themeMode;
  bool get isLoading => _isLoading;

  ThemeProvider() {
    _loadTheme();
  }

  /// 저장된 테마 불러오기
  Future<void> _loadTheme() async {
    try {
      AppLogger.debug('🎨 ThemeProvider: 테마 로딩 시작...');
      _isLoading = true;
      notifyListeners();

      // 1초 타임아웃 설정 - 빠른 앱 시작을 위해 짧게 설정
      final themeMode = await ThemeService.getThemeMode()
          .timeout(
            const Duration(seconds: 1),
            onTimeout: () {
              AppLogger.debug('⚠️ ThemeProvider: 테마 로딩 타임아웃 - 기본값 사용');
              return ThemeMode.light;
            },
          );
      
      _themeMode = themeMode;
      _isLoading = false;
      AppLogger.debug('✅ ThemeProvider: 테마 로딩 완료 - $_themeMode');
      notifyListeners();
    } catch (e, stackTrace) {
      AppLogger.error('❌ ThemeProvider: 테마 로딩 실패', e, stackTrace);
      _themeMode = ThemeMode.light;
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 테마 변경 및 저장
  void changeTheme(ThemeMode themeMode) {
    if (_themeMode == themeMode) return;

    _themeMode = themeMode;
    notifyListeners();
    
    // 테마 저장은 백그라운드에서 완전히 비동기로 처리
    ThemeService.saveThemeMode(themeMode).catchError((e) {
      AppLogger.error('테마 저장 실패', e);
    });
  }

  /// 테마 토글 (라이트 ↔ 다크)
  void toggleTheme() {
    final newTheme = _themeMode == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    changeTheme(newTheme);
  }
}

