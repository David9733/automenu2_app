import 'package:flutter/material.dart';
import 'shared_prefs_service.dart';
import '../utils/logger.dart';

/// 테마 관리 서비스
class ThemeService {
  static const String _themeKey = 'theme_mode';
  
  /// 저장된 테마 모드 불러오기
  static Future<ThemeMode> getThemeMode() async {
    try {
      final prefs = await SharedPrefsService.instance;
      final themeString = prefs.getString(_themeKey);
      
      if (themeString == null) {
        return ThemeMode.light; // 기본값은 라이트 모드
      }
      
      switch (themeString) {
        case 'light':
          return ThemeMode.light;
        case 'dark':
          return ThemeMode.dark;
        case 'system':
          return ThemeMode.system;
        default:
          return ThemeMode.light;
      }
    } catch (e) {
      return ThemeMode.light; // 에러 발생 시 기본값 반환
    }
  }
  
  /// 테마 모드 저장하기
  static Future<void> saveThemeMode(ThemeMode themeMode) async {
    try {
      final prefs = await SharedPrefsService.instance;
      String themeString;
      
      switch (themeMode) {
        case ThemeMode.light:
          themeString = 'light';
          break;
        case ThemeMode.dark:
          themeString = 'dark';
          break;
        case ThemeMode.system:
          themeString = 'system';
          break;
      }
      
      await prefs.setString(_themeKey, themeString);
    } catch (e) {
      // 에러 발생 시 무시 (로그만 출력 가능)
      AppLogger.error('테마 저장 실패', e);
    }
  }
}

