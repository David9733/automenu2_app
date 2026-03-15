/// 식사 상황 타입
enum EatingSituation {
  alone('혼자'),
  coworkers('동료'),
  partner('애인'),
  family('가족');

  final String label;
  const EatingSituation(this.label);
}

