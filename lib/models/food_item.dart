import 'meal_time.dart';
import 'eating_situation.dart';

/// 음식 아이템 모델
class FoodItem {
  final String id;
  final String name;
  final String imageUrl; // 나중에 실제 이미지로 교체 가능
  final MealTime mealTime;
  final List<EatingSituation> situations;
  final bool suitableForDrinking; // 음주 시 적합한지
  final String reasonText; // 추천 이유

  FoodItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.mealTime,
    required this.situations,
    this.suitableForDrinking = false,
    required this.reasonText,
  });
}

