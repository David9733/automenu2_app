import 'package:firebase_analytics/firebase_analytics.dart';
import '../utils/logger.dart';
import '../models/meal_time.dart';
import '../models/eating_situation.dart';
import '../models/drinking_status.dart';
import '../models/food_category.dart';

/// Firebase Analytics 서비스
/// 앱 전체의 이벤트 추적을 중앙에서 관리
class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// FirebaseAnalytics 인스턴스 반환
  static FirebaseAnalytics get instance => _analytics;

  /// 화면 조회 추적
  static Future<void> logScreenView(String screenName) async {
    try {
      await _analytics.logScreenView(screenName: screenName);
    } catch (e) {
      // 에러 발생 시에도 앱이 계속 작동하도록
      AppLogger.debug('Analytics logScreenView 실패: $e');
    }
  }

  /// 식사 시간 선택 추적
  static Future<void> logMealTimeSelected(MealTime mealTime) async {
    try {
      await _analytics.logEvent(
        name: 'meal_time_selected',
        parameters: {
          'meal_time': mealTime.name,
        },
      );
    } catch (e) {
      AppLogger.debug('Analytics logMealTimeSelected 실패: $e');
    }
  }

  /// 식사 상황 선택 추적
  static Future<void> logEatingSituationSelected(EatingSituation situation) async {
    try {
      await _analytics.logEvent(
        name: 'eating_situation_selected',
        parameters: {
          'situation': situation.name,
        },
      );
    } catch (e) {
      AppLogger.debug('Analytics logEatingSituationSelected 실패: $e');
    }
  }

  /// 술 여부 선택 추적
  static Future<void> logDrinkingStatusSelected(DrinkingStatus drinkingStatus) async {
    try {
      await _analytics.logEvent(
        name: 'drinking_status_selected',
        parameters: {
          'drinking_status': drinkingStatus.name,
        },
      );
    } catch (e) {
      AppLogger.debug('Analytics logDrinkingStatusSelected 실패: $e');
    }
  }

  /// 음식 종류 선택 추적
  static Future<void> logFoodCategorySelected({
    required Set<FoodCategory>? categories,
    required bool isAnyCategory,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'food_category_selected',
        parameters: {
          'categories': categories?.map((e) => e.name).join(',') ?? 'none',
          'is_any_category': isAnyCategory,
          'category_count': categories?.length ?? 0,
        },
      );
    } catch (e) {
      AppLogger.debug('Analytics logFoodCategorySelected 실패: $e');
    }
  }

  /// 추천 요청 추적
  static Future<void> logRecommendationRequest({
    required MealTime mealTime,
    required EatingSituation situation,
    required DrinkingStatus drinkingStatus,
    Set<FoodCategory>? categories,
    bool isAnyCategory = false,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'recommendation_requested',
        parameters: {
          'meal_time': mealTime.name,
          'situation': situation.name,
          'drinking_status': drinkingStatus.name,
          'categories': categories?.map((e) => e.name).join(',') ?? (isAnyCategory ? 'any' : 'none'),
          'category_count': categories?.length ?? 0,
          'is_any_category': isAnyCategory,
        },
      );
    } catch (e) {
      AppLogger.debug('Analytics logRecommendationRequest 실패: $e');
    }
  }

  /// 추천 결과 조회 추적
  static Future<void> logRecommendationViewed({
    required int recommendationCount,
    String? firstFoodName,
    String? firstFoodCategory,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'recommendation_viewed',
        parameters: {
          'recommendation_count': recommendationCount,
          if (firstFoodName != null) 'first_food_name': firstFoodName,
          if (firstFoodCategory != null) 'first_food_category': firstFoodCategory,
        },
      );
    } catch (e) {
      AppLogger.debug('Analytics logRecommendationViewed 실패: $e');
    }
  }

  /// 다른 옵션 보기 추적
  static Future<void> logViewAnotherOption({
    required int currentIndex,
    required int totalCount,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'view_another_option',
        parameters: {
          'current_index': currentIndex,
          'total_count': totalCount,
        },
      );
    } catch (e) {
      AppLogger.debug('Analytics logViewAnotherOption 실패: $e');
    }
  }

  /// 음식 결정 추적 (이거 먹을래)
  static Future<void> logFoodSelected({
    required String foodName,
    required String category,
    required int selectedIndex,
    required int totalOptionsViewed,
    required int totalRecommendations,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'food_selected',
        parameters: {
          'food_name': foodName,
          'food_category': category,
          'selected_index': selectedIndex,
          'total_options_viewed': totalOptionsViewed,
          'total_recommendations': totalRecommendations,
        },
      );
    } catch (e) {
      AppLogger.debug('Analytics logFoodSelected 실패: $e');
    }
  }

  /// 다시 추천받기 추적
  static Future<void> logRecommendationRefreshed({
    String? previousFoodName,
    required int viewedBeforeRefresh,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'recommendation_refreshed',
        parameters: {
          if (previousFoodName != null) 'previous_food_name': previousFoodName,
          'viewed_before_refresh': viewedBeforeRefresh,
        },
      );
    } catch (e) {
      AppLogger.debug('Analytics logRecommendationRefreshed 실패: $e');
    }
  }

  /// 처음으로 돌아가기 추적
  static Future<void> logReturnedToStart({
    int? sessionDuration,
    int? recommendationsRequested,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'returned_to_start',
        parameters: {
          if (sessionDuration != null) 'session_duration': sessionDuration,
          if (recommendationsRequested != null) 'recommendations_requested': recommendationsRequested,
        },
      );
    } catch (e) {
      AppLogger.debug('Analytics logReturnedToStart 실패: $e');
    }
  }

  /// 알림 설정 변경 추적
  static Future<void> logNotificationSettingChanged({
    required String mealType,
    required bool enabled,
    required String mealTime,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'notification_setting_changed',
        parameters: {
          'meal_type': mealType,
          'enabled': enabled,
          'meal_time': mealTime,
        },
      );
    } catch (e) {
      AppLogger.debug('Analytics logNotificationSettingChanged 실패: $e');
    }
  }

  /// 식사 시간 설정 변경 추적
  static Future<void> logMealTimeSettingChanged({
    required String mealType,
    required String newTime,
    String? oldTime,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'meal_time_setting_changed',
        parameters: {
          'meal_type': mealType,
          'new_time': newTime,
          if (oldTime != null) 'old_time': oldTime,
        },
      );
    } catch (e) {
      AppLogger.debug('Analytics logMealTimeSettingChanged 실패: $e');
    }
  }

  /// 추천 실패 추적
  static Future<void> logRecommendationFailed({
    required String errorType,
    MealTime? mealTime,
    Set<FoodCategory>? categories,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'recommendation_failed',
        parameters: {
          'error_type': errorType,
          if (mealTime != null) 'meal_time': mealTime.name,
          if (categories != null) 'categories': categories.map((e) => e.name).join(','),
        },
      );
    } catch (e) {
      AppLogger.debug('Analytics logRecommendationFailed 실패: $e');
    }
  }
}

