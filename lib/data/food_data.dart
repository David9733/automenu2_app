import '../models/food_item.dart';
import '../models/meal_time.dart';
import '../models/eating_situation.dart';

/// 간단한 음식 데이터 (MVP용 하드코딩)
/// 추후 데이터베이스나 API로 교체 가능
class FoodData {
  static final List<FoodItem> foods = [
    // 아침
    FoodItem(
      id: '1',
      name: '김치찌개',
      imageUrl: '🍲',
      mealTime: MealTime.breakfast,
      situations: [EatingSituation.alone, EatingSituation.coworkers],
      reasonText: '아침에 든든하게 먹기 좋고 혼자 먹기에도 부담 없어요.',
    ),
    FoodItem(
      id: '2',
      name: '샌드위치',
      imageUrl: '🥪',
      mealTime: MealTime.breakfast,
      situations: [EatingSituation.alone, EatingSituation.coworkers],
      reasonText: '빠르게 먹을 수 있어서 아침에 딱이에요.',
    ),
    FoodItem(
      id: '3',
      name: '국수',
      imageUrl: '🍜',
      mealTime: MealTime.breakfast,
      situations: [EatingSituation.alone, EatingSituation.family],
      reasonText: '가볍고 소화가 잘 되어 아침 식사로 좋아요.',
    ),

    // 점심
    FoodItem(
      id: '4',
      name: '비빔밥',
      imageUrl: '🍚',
      mealTime: MealTime.lunch,
      situations: [EatingSituation.alone, EatingSituation.coworkers],
      reasonText: '혼자 먹기 편하고 영양도 골고루 들어있어요.',
    ),
    FoodItem(
      id: '5',
      name: '치킨',
      imageUrl: '🍗',
      mealTime: MealTime.lunch,
      situations: [EatingSituation.coworkers, EatingSituation.partner],
      reasonText: '동료들과 함께 나누기 좋고 모두가 좋아하는 메뉴예요.',
    ),
    FoodItem(
      id: '6',
      name: '돈까스',
      imageUrl: '🍛',
      mealTime: MealTime.lunch,
      situations: [EatingSituation.alone, EatingSituation.coworkers],
      reasonText: '일반적으로 좋아하는 메뉴로 결정하기 쉬워요.',
    ),
    FoodItem(
      id: '7',
      name: '파스타',
      imageUrl: '🍝',
      mealTime: MealTime.lunch,
      situations: [EatingSituation.partner, EatingSituation.family],
      reasonText: '데이트나 가족 식사에 분위기 좋은 메뉴예요.',
    ),

    // 저녁
    FoodItem(
      id: '8',
      name: '삼겹살',
      imageUrl: '🥓',
      mealTime: MealTime.dinner,
      situations: [EatingSituation.coworkers, EatingSituation.partner],
      suitableForDrinking: true,
      reasonText: '회식이나 데이트에 좋고 술과도 잘 어울려요.',
    ),
    FoodItem(
      id: '9',
      name: '초밥',
      imageUrl: '🍣',
      mealTime: MealTime.dinner,
      situations: [EatingSituation.partner, EatingSituation.family],
      reasonText: '특별한 날 가족이나 연인과 함께 먹기 좋아요.',
    ),
    FoodItem(
      id: '10',
      name: '떡볶이',
      imageUrl: '🌶️',
      mealTime: MealTime.dinner,
      situations: [EatingSituation.alone, EatingSituation.coworkers],
      reasonText: '혼자 먹기 좋고 간단하게 해결하기 좋아요.',
    ),
    FoodItem(
      id: '11',
      name: '족발',
      imageUrl: '🍖',
      mealTime: MealTime.dinner,
      situations: [EatingSituation.coworkers, EatingSituation.family],
      suitableForDrinking: true,
      reasonText: '여러 명이 함께 나누기 좋고 술안주로도 완벽해요.',
    ),
    FoodItem(
      id: '12',
      name: '피자',
      imageUrl: '🍕',
      mealTime: MealTime.dinner,
      situations: [EatingSituation.coworkers, EatingSituation.family],
      reasonText: '모두가 좋아하는 메뉴로 결정하기 쉬워요.',
    ),
  ];

  /// 조건에 맞는 음식 추천
  static List<FoodItem> getRecommendations({
    required MealTime mealTime,
    required EatingSituation situation,
    bool isDrinking = false,
  }) {
    var filtered = foods.where((food) {
      // 식사 시간 일치
      if (food.mealTime != mealTime) return false;
      
      // 상황 일치
      if (!food.situations.contains(situation)) return false;
      
      // 음주 여부 확인
      if (isDrinking && !food.suitableForDrinking) return false;
      
      return true;
    }).toList();

    // 최대 3개까지만 반환
    return filtered.take(3).toList();
  }
}

