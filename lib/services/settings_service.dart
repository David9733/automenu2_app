import 'shared_prefs_service.dart';

/// 설정 관리 서비스
class SettingsService {
  static const String _breakfastTimeKey = 'breakfast_time';
  static const String _lunchTimeKey = 'lunch_time';
  static const String _dinnerTimeKey = 'dinner_time';
  static const String _breakfastNotificationEnabledKey = 'breakfast_notification_enabled';
  static const String _lunchNotificationEnabledKey = 'lunch_notification_enabled';
  static const String _dinnerNotificationEnabledKey = 'dinner_notification_enabled';
  
  // 기본 시간 (HH:mm 형식)
  static const String _defaultBreakfastTime = '08:00';
  static const String _defaultLunchTime = '12:00';
  static const String _defaultDinnerTime = '18:00';
  
  // 기본 알림 설정 (기본값: 모두 활성화)
  static const bool _defaultNotificationEnabled = true;
  
  /// 아침 시간 저장
  static Future<void> saveBreakfastTime(String time) async {
    try {
      final prefs = await SharedPrefsService.instance;
      await prefs.setString(_breakfastTimeKey, time);
    } catch (e) {
      // 에러 발생 시 무시
    }
  }
  
  /// 점심 시간 저장
  static Future<void> saveLunchTime(String time) async {
    try {
      final prefs = await SharedPrefsService.instance;
      await prefs.setString(_lunchTimeKey, time);
    } catch (e) {
      // 에러 발생 시 무시
    }
  }
  
  /// 저녁 시간 저장
  static Future<void> saveDinnerTime(String time) async {
    try {
      final prefs = await SharedPrefsService.instance;
      await prefs.setString(_dinnerTimeKey, time);
    } catch (e) {
      // 에러 발생 시 무시
    }
  }
  
  /// 아침 시간 불러오기
  static Future<String> getBreakfastTime() async {
    try {
      final prefs = await SharedPrefsService.instance;
      return prefs.getString(_breakfastTimeKey) ?? _defaultBreakfastTime;
    } catch (e) {
      return _defaultBreakfastTime;
    }
  }
  
  /// 점심 시간 불러오기
  static Future<String> getLunchTime() async {
    try {
      final prefs = await SharedPrefsService.instance;
      return prefs.getString(_lunchTimeKey) ?? _defaultLunchTime;
    } catch (e) {
      return _defaultLunchTime;
    }
  }
  
  /// 저녁 시간 불러오기
  static Future<String> getDinnerTime() async {
    try {
      final prefs = await SharedPrefsService.instance;
      return prefs.getString(_dinnerTimeKey) ?? _defaultDinnerTime;
    } catch (e) {
      return _defaultDinnerTime;
    }
  }
  
  /// 모든 시간 불러오기
  static Future<Map<String, String>> getAllMealTimes() async {
    return {
      'breakfast': await getBreakfastTime(),
      'lunch': await getLunchTime(),
      'dinner': await getDinnerTime(),
    };
  }
  
  /// 아침 알림 활성화 상태 저장
  static Future<void> saveBreakfastNotificationEnabled(bool enabled) async {
    try {
      final prefs = await SharedPrefsService.instance;
      await prefs.setBool(_breakfastNotificationEnabledKey, enabled);
    } catch (e) {
      // 에러 발생 시 무시
    }
  }
  
  /// 점심 알림 활성화 상태 저장
  static Future<void> saveLunchNotificationEnabled(bool enabled) async {
    try {
      final prefs = await SharedPrefsService.instance;
      await prefs.setBool(_lunchNotificationEnabledKey, enabled);
    } catch (e) {
      // 에러 발생 시 무시
    }
  }
  
  /// 저녁 알림 활성화 상태 저장
  static Future<void> saveDinnerNotificationEnabled(bool enabled) async {
    try {
      final prefs = await SharedPrefsService.instance;
      await prefs.setBool(_dinnerNotificationEnabledKey, enabled);
    } catch (e) {
      // 에러 발생 시 무시
    }
  }
  
  /// 아침 알림 활성화 상태 불러오기
  static Future<bool> getBreakfastNotificationEnabled() async {
    try {
      final prefs = await SharedPrefsService.instance;
      return prefs.getBool(_breakfastNotificationEnabledKey) ?? _defaultNotificationEnabled;
    } catch (e) {
      return _defaultNotificationEnabled;
    }
  }
  
  /// 점심 알림 활성화 상태 불러오기
  static Future<bool> getLunchNotificationEnabled() async {
    try {
      final prefs = await SharedPrefsService.instance;
      return prefs.getBool(_lunchNotificationEnabledKey) ?? _defaultNotificationEnabled;
    } catch (e) {
      return _defaultNotificationEnabled;
    }
  }
  
  /// 저녁 알림 활성화 상태 불러오기
  static Future<bool> getDinnerNotificationEnabled() async {
    try {
      final prefs = await SharedPrefsService.instance;
      return prefs.getBool(_dinnerNotificationEnabledKey) ?? _defaultNotificationEnabled;
    } catch (e) {
      return _defaultNotificationEnabled;
    }
  }
  
  /// 모든 알림 활성화 상태 불러오기
  static Future<Map<String, bool>> getAllNotificationEnabled() async {
    return {
      'breakfast': await getBreakfastNotificationEnabled(),
      'lunch': await getLunchNotificationEnabled(),
      'dinner': await getDinnerNotificationEnabled(),
    };
  }
}

