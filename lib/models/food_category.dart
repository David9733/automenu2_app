/// 음식 종류
enum FoodCategory {
  korean('한식'),
  japanese('일식'),
  western('양식'),
  chinese('중식'),
  snack('분식');

  final String label;
  const FoodCategory(this.label);
}

