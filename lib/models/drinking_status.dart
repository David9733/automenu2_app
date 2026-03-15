/// 음주 여부 상태
enum DrinkingStatus {
  no('안마신다'),
  yes('마신다'),
  unknown('모른다');

  final String label;
  const DrinkingStatus(this.label);
  
  /// 이모지 반환
  String get emoji {
    switch (this) {
      case DrinkingStatus.yes:
        return '⭕';
      case DrinkingStatus.no:
        return '❌';
      case DrinkingStatus.unknown:
        return '🔺';
    }
  }
}

