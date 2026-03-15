import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/food_item.dart';
import '../models/meal_time.dart';
import '../models/eating_situation.dart';
import '../models/drinking_status.dart';
import '../models/food_category.dart';
import '../utils/logger.dart';

/// 캐시된 후보 목록 클래스
class _CachedCandidateList {
  final List<FoodItem> candidates;
  final DateTime timestamp;
  static const int cacheExpireMinutes = 15; // 15분 후 만료
  
  _CachedCandidateList(this.candidates, this.timestamp);
  
  bool isValid() {
    return DateTime.now().difference(timestamp).inMinutes < cacheExpireMinutes;
  }
}

/// Supabase에서 음식 데이터를 가져오는 서비스
class FoodService {
  static final SupabaseClient _supabase = Supabase.instance.client;
  
  // 캐시 설정
  static const int _maxCacheSize = 100; // 최대 100개 조합 캐시 (각 카테고리별 36개 + 여유분)
  
  // 메모리 캐싱 (앱 종료 시 자동 삭제)
  static final Map<String, _CachedCandidateList> _candidateCache = {};
  static final Map<String, DateTime> _cacheAccessTime = {};
  
  /// 캐시 키 생성
  static String _getCacheKey({
    required String mealTimeStr,
    required String situationStr,
    required String drinkingStatusStr,
    Set<FoodCategory>? selectedCategories,
  }) {
    if (selectedCategories != null && selectedCategories.isNotEmpty) {
      final categoriesList = selectedCategories.map((e) => e.name).toList()..sort();
      final categoryKey = categoriesList.join(',');
      return '${mealTimeStr}_${situationStr}_${drinkingStatusStr}_$categoryKey';
    } else {
      return '${mealTimeStr}_${situationStr}_${drinkingStatusStr}_all';
    }
  }
  
  /// 캐시 정리 (만료된 항목 제거 및 LRU 정리)
  static void _cleanupCache() {
    // 1. 만료된 캐시 제거
    final expiredKeys = <String>[];
    for (final entry in _candidateCache.entries) {
      if (!entry.value.isValid()) {
        expiredKeys.add(entry.key);
      }
    }
    
    for (final key in expiredKeys) {
      _candidateCache.remove(key);
      _cacheAccessTime.remove(key);
    }
    
    if (expiredKeys.isNotEmpty) {
      AppLogger.debug('🧹 만료된 캐시 ${expiredKeys.length}개 제거');
    }
    
    // 2. 캐시 크기 제한 (LRU 방식)
    if (_candidateCache.length > _maxCacheSize) {
      // 접근 시간 순으로 정렬 (오래된 것부터)
      final sortedByAccess = _cacheAccessTime.entries.toList()
        ..sort((a, b) => a.value.compareTo(b.value));
      
      // 오래된 것부터 삭제 (최대 크기까지)
      final keysToRemove = sortedByAccess
          .take(_candidateCache.length - _maxCacheSize)
          .map((e) => e.key)
          .toList();
      
      for (final key in keysToRemove) {
        _candidateCache.remove(key);
        _cacheAccessTime.remove(key);
      }
      
      AppLogger.debug('🧹 LRU 캐시 정리: ${keysToRemove.length}개 항목 제거 (현재 ${_candidateCache.length}개 유지)');
    }
  }
  
  /// 전체 후보 목록 가져오기 (캐싱용)
  static Future<List<FoodItem>> _fetchAllCandidates({
    required MealTime mealTime,
    required EatingSituation situation,
    required DrinkingStatus drinkingStatus,
    Set<FoodCategory>? selectedCategories,
  }) async {
    final mealTimeStr = mealTime.name;
    final situationStr = situation.name;
    final drinkingStatusStr = drinkingStatus.name;
    
    // 임시 Random (후보 목록은 섞지 않고 원본 순서로 반환)
    final tempRandom = Random(0);
    
    List<FoodItem> candidates;
    if (selectedCategories != null && selectedCategories.isNotEmpty) {
      candidates = await _getRecommendationsWithCategories(
        mealTimeStr: mealTimeStr,
        situationStr: situationStr,
        drinkingStatusStr: drinkingStatusStr,
        selectedCategories: selectedCategories,
        mealTime: mealTime,
        situation: situation,
        drinkingStatus: drinkingStatus,
        random: tempRandom,
      );
    } else {
      candidates = await _getRecommendationsWithoutCategories(
        mealTimeStr: mealTimeStr,
        situationStr: situationStr,
        drinkingStatusStr: drinkingStatusStr,
        mealTime: mealTime,
        situation: situation,
        drinkingStatus: drinkingStatus,
        random: tempRandom,
      );
    }
    
    return candidates;
  }

  /// 조건에 맞는 음식 추천 가져오기
  static Future<List<FoodItem>> getRecommendations({
    required MealTime mealTime,
    required EatingSituation situation,
    required DrinkingStatus drinkingStatus,
    Set<FoodCategory>? selectedCategories,
  }) async {
    try {
      // 캐시 정리 (필요시)
      _cleanupCache();
      
      // enum 값을 Supabase에 저장된 문자열로 변환
      final mealTimeStr = mealTime.name; // breakfast, lunch, dinner
      final situationStr = situation.name; // alone, coworkers, partner, family
      final drinkingStatusStr = drinkingStatus.name; // yes, no, unknown

      final cacheKey = _getCacheKey(
        mealTimeStr: mealTimeStr,
        situationStr: situationStr,
        drinkingStatusStr: drinkingStatusStr,
        selectedCategories: selectedCategories,
      );

      AppLogger.debug('=== 추천 요청 ===');
      AppLogger.debug('식사 시간: $mealTimeStr');
      AppLogger.debug('상황: $situationStr');
      AppLogger.debug('음주 여부: $drinkingStatusStr');
      AppLogger.debug('카테고리: ${selectedCategories?.map((e) => e.name).join(', ') ?? '없음'}');
      AppLogger.debug('캐시키: $cacheKey');

      List<FoodItem> allCandidates;

      // 캐시 확인
      final cached = _candidateCache[cacheKey];
      if (cached != null && cached.isValid()) {
        AppLogger.debug('✅ 캐시에서 후보 목록 사용 (${cached.candidates.length}개)');
        allCandidates = cached.candidates;
        // 캐시 접근 시간 업데이트
        _cacheAccessTime[cacheKey] = DateTime.now();
      } else {
        AppLogger.debug('🔄 DB에서 후보 목록 가져오기...');
        // 캐시가 없거나 만료된 경우 DB에서 가져오기
        allCandidates = await _fetchAllCandidates(
          mealTime: mealTime,
          situation: situation,
          drinkingStatus: drinkingStatus,
          selectedCategories: selectedCategories,
        );
        
        if (allCandidates.isNotEmpty) {
          // 캐시에 저장
          _candidateCache[cacheKey] = _CachedCandidateList(allCandidates, DateTime.now());
          _cacheAccessTime[cacheKey] = DateTime.now();
          AppLogger.debug('💾 후보 목록 캐시 저장 완료 (${allCandidates.length}개)');
        }
      }

      if (allCandidates.isEmpty) {
        AppLogger.debug('=== 최종 결과 없음 ===');
        AppLogger.debug('필터 조건: $mealTimeStr / $situationStr / $drinkingStatusStr / ${selectedCategories?.map((e) => e.name).join(', ') ?? '없음'}');
        AppLogger.debug('⚠️ 이 조합에 대한 데이터가 없습니다. 데이터를 추가해야 합니다.');
        return [];
      }

      // 매번 다른 랜덤 결과를 위한 시드 생성
      // 타임스탬프를 강하게 반영하여 같은 조건이라도 매번 다른 결과가 나오도록 함
      final now = DateTime.now();
      final randomSeed = now.millisecondsSinceEpoch ^
                         (now.microsecondsSinceEpoch << 16);
      final random = Random(randomSeed);

      // 캐시된 후보 목록을 매번 다른 순서로 섞기
      final shuffled = List<FoodItem>.from(allCandidates)..shuffle(random);
      
      // 최대 3개까지 반환
      final finalResult = shuffled.length >= 3
          ? shuffled.take(3).toList()
          : shuffled;

      if (finalResult.length < 2) {
        AppLogger.debug('⚠️ 경고: 정확한 매칭 결과가 2개 미만입니다 (${finalResult.length}개). 데이터를 추가해야 합니다.');
      }

      AppLogger.debug('🎲 랜덤 선택 완료: ${finalResult.length}개 (후보 ${allCandidates.length}개 중)');
      AppLogger.debug('=== 최종 추천 결과: ${finalResult.length}개 ===');
      AppLogger.debug('필터 조건: $mealTimeStr / $situationStr / $drinkingStatusStr / ${selectedCategories?.map((e) => e.name).join(', ') ?? '없음'}');
      for (var item in finalResult) {
        AppLogger.debug('- ${item.name}');
      }
      
      return finalResult;
    } on PostgrestException catch (e) {
      // Supabase 데이터베이스 에러
      AppLogger.error('Supabase Error: ${e.message}', e);
      rethrow; // 상위로 전달하여 UI에서 처리
    } catch (e) {
      // 기타 에러
      AppLogger.error('Error fetching recommendations: $e');
      rethrow; // 상위로 전달하여 UI에서 처리
    }
  }

  /// 카테고리가 선택된 경우의 추천 가져오기
  static Future<List<FoodItem>> _getRecommendationsWithCategories({
    required String mealTimeStr,
    required String situationStr,
    required String drinkingStatusStr,
    required Set<FoodCategory> selectedCategories,
    required MealTime mealTime,
    required EatingSituation situation,
    required DrinkingStatus drinkingStatus,
    required Random random,
  }) async {
        final categoryStrings = selectedCategories.map((cat) {
          switch (cat) {
            case FoodCategory.korean:
              return 'korean';
            case FoodCategory.japanese:
              return 'japanese';
            case FoodCategory.western:
              return 'western';
            case FoodCategory.chinese:
              return 'chinese';
            case FoodCategory.snack:
              return 'snack';
          }
        }).toList();

    // food_id와 해당하는 food_category를 함께 추적
    var foodIdToCategory = <String, String>{};
    
    // 각 카테고리에 대해 쿼리 실행
          for (final category in categoryStrings) {
            final categoryQuery = _supabase
                .from('food_conditions')
          .select('food_id, priority, food_category')
                .eq('meal_time', mealTimeStr)
                .eq('eating_situation', situationStr)
                .eq('drinking_status', drinkingStatusStr)
          .eq('food_category', category) // 정확히 일치하는 카테고리만
          .not('food_category', 'is', null); // null 값 제외
            
            final categoryResponse = await categoryQuery
                .order('priority', ascending: false)
          .limit(100); // 훨씬 더 많은 결과 가져오기
      
      // food_category가 정확히 일치하고 null이 아닌지 확인
      for (final condition in categoryResponse) {
        final conditionCategory = condition['food_category'] as String?;
        final foodId = condition['food_id'] as String;
        if (conditionCategory != null && conditionCategory == category) {
          // 선택된 카테고리와 일치하는 경우만 저장
          foodIdToCategory[foodId] = category;
        }
      }
    }
    
    if (foodIdToCategory.isEmpty) {
            return [];
          }
          
    // 랜덤하게 섞기
    final foodIdsList = foodIdToCategory.keys.toList()..shuffle(random);
    var foodCategoryMap = <String, String>{}; // food_id -> category 매핑 유지
    
    // food_id -> category 매핑 저장
    for (final foodId in foodIdsList) {
      foodCategoryMap[foodId] = foodIdToCategory[foodId]!;
    }
          
    // IN 쿼리로 한 번에 여러 food_id 조회 (최적화: 50번 요청 → 1번 요청)
    final foodIdsToQuery = foodIdsList.take(50).toList();
    if (foodIdsToQuery.isEmpty) {
      return [];
    }
    
    final foodsQuery = _supabase
        .from('foods')
        .select('id, name, image_url, reason_text')
        .inFilter('id', foodIdsToQuery);
    
    final foodsResponse = await foodsQuery;
    var allFoods = List<Map<String, dynamic>>.from(foodsResponse);
    
    // 최종 필터링: 선택된 카테고리에 속하는 음식만 포함
    var filteredFoods = allFoods.where((food) {
      final foodId = food['id'] as String;
      final foodCategory = foodCategoryMap[foodId];
      return foodCategory != null && categoryStrings.contains(foodCategory);
    }).toList();
    
    // 추가 필터링: 회식 조건(동료 + 술)에서는 혼자 먹기 좋은 음식 제외
    if (situation == EatingSituation.coworkers && drinkingStatus == DrinkingStatus.yes) {
      filteredFoods = filteredFoods.where((food) {
        final name = food['name'] as String;
        // 회식에 어울리지 않는 음식 제외
        return !_isGoodForAlone(name);
      }).toList();
    }
    
    return _convertToFoodItems(
      filteredFoods,
      mealTime: mealTime,
      situation: situation,
      drinkingStatus: drinkingStatus,
      selectedCategories: selectedCategories,
      foodCategoryMap: foodCategoryMap,
    );
  }

  /// 카테고리가 선택되지 않은 경우의 추천 가져오기
  static Future<List<FoodItem>> _getRecommendationsWithoutCategories({
    required String mealTimeStr,
    required String situationStr,
    required String drinkingStatusStr,
    required MealTime mealTime,
    required EatingSituation situation,
    required DrinkingStatus drinkingStatus,
    required Random random,
  }) async {
    final query = _supabase
          .from('food_conditions')
          .select('food_id, priority, food_category')
          .eq('meal_time', mealTimeStr)
          .eq('eating_situation', situationStr)
          .eq('drinking_status', drinkingStatusStr);

      final conditionsResponse = await query
          .order('priority', ascending: false)
        .limit(100); // 더 많은 결과 가져오기

      if (conditionsResponse.isEmpty) {
        return [];
      }

    // food_id와 카테고리 매핑
    var foodIdToCategory = <String, String>{};
    for (final condition in conditionsResponse) {
      final foodId = condition['food_id'] as String;
      final category = condition['food_category'] as String?;
      if (category != null) {
        foodIdToCategory[foodId] = category;
      }
    }

    // food_id 리스트 추출 및 랜덤 섞기
    var foodIds = foodIdToCategory.keys.toSet().toList();
    
    foodIds.shuffle(random); // 랜덤하게 섞기

    // IN 쿼리로 한 번에 여러 food_id 조회 (최적화: 50번 요청 → 1번 요청)
    final foodIdsToQuery = foodIds.take(50).toList();
    if (foodIdsToQuery.isEmpty) {
      return [];
    }
    
    final foodsQuery = _supabase
        .from('foods')
        .select('id, name, image_url, reason_text')
        .inFilter('id', foodIdsToQuery);
    
    final foodsResponse = await foodsQuery;
    var allFoods = List<Map<String, dynamic>>.from(foodsResponse);

    // 추가 필터링: 회식 조건(동료 + 술)에서는 혼자 먹기 좋은 음식 제외
    var filteredFoods = allFoods;
    if (situation == EatingSituation.coworkers && drinkingStatus == DrinkingStatus.yes) {
      filteredFoods = allFoods.where((food) {
        final name = food['name'] as String;
        // 회식에 어울리지 않는 음식 제외
        return !_isGoodForAlone(name);
      }).toList();
    }
    
    return _convertToFoodItems(
      filteredFoods,
      mealTime: mealTime,
      situation: situation,
      drinkingStatus: drinkingStatus,
      selectedCategories: null,
      foodCategoryMap: foodIdToCategory,
    );
  }

  /// Map 데이터를 FoodItem 리스트로 변환
  static List<FoodItem> _convertToFoodItems(
    List<Map<String, dynamic>> allFoods, {
    required MealTime mealTime,
    required EatingSituation situation,
    required DrinkingStatus drinkingStatus,
    Set<FoodCategory>? selectedCategories,
    Map<String, String>? foodCategoryMap,
  }) {
      final foodItems = <FoodItem>[];
    
    for (final foodData in allFoods) {
        final foodId = foodData['id'] as String;
        final name = foodData['name'] as String;
        final imageUrl = foodData['image_url'] as String? ?? '🍽️';
      
      // 조건에 맞는 동적 이유 생성
      final category = foodCategoryMap?[foodId];
      final dynamicReasonText = _generateDynamicReasonText(
        foodName: name,
        mealTime: mealTime,
        situation: situation,
        drinkingStatus: drinkingStatus,
        category: category != null ? _stringToCategory(category) : null,
      );

        foodItems.add(FoodItem(
          id: foodId,
          name: name,
          imageUrl: imageUrl,
          mealTime: mealTime,
          situations: [situation],
          suitableForDrinking: drinkingStatus == DrinkingStatus.yes,
        reasonText: dynamicReasonText,
        ));
      }

      return foodItems;
  }

  /// 음식의 특성을 판단하는 함수
  /// 회식에 어울리는지, 혼자 먹기 좋은지, 가벼운 음식인지 등을 판단
  static bool _isGoodForGroupGathering(String foodName) {
    // 회식/여러 명과 함께 먹기에 좋은 음식들
    final groupFoods = [
      '삼겹살', '족발', '갈비', '불고기', '비빔밥', '냉면', '칼국수', '잔치국수',
      '비빔국수', '파스타', '리조또', '피자', '치킨', '탕수육', '짜장면', '짬뽕',
      '라멘', '우동', '초밥', '회', '보쌈', '닭갈비', '소갈비', '막국수',
      '부대찌개', '김치찌개', '된장찌개', '순두부찌개', '동태찌개', '감자탕',
      '곱창', '막창', '대창', '양고기', '오삼불고기', '제육볶음', '제육덮밥',
    ];
    
    return groupFoods.any((food) => foodName.contains(food));
  }

  static bool _isGoodForAlone(String foodName) {
    // 혼자 먹기에 좋은 음식들 (간단한 반찬, 가벼운 음식)
    // 주의: 회식에 어울리지 않는 음식들
    final aloneFoods = [
      '멸치볶음', '콩나물무침', '시금치무침', '감자조림', '장조림', '콩조림',
      '진미채 볶음', '연근조림', '감자채 볶음', '시래깃국', '미역국', '된장국',
      '어묵', '순대', '김밥', '라면', '떡볶이', '토스트', '샌드위치',
      '오므라이스', '카레', '계란볶음밥', '김치볶음밥', '야채볶음밥',
      '계란후라이', '계란말이', '스크램블에그', '감잣국', '북엇국', '콩나물국',
    ];
    
    return aloneFoods.any((food) => foodName.contains(food));
  }

  static bool _isLightFood(String foodName) {
    // 가벼운 음식들 (회식에 적합하지 않은 가벼운 반찬/간식)
    final lightFoods = [
      '국', '국수', '면', '샐러드', '무침', '볶음', '조림',
      '어묵', '순대', '김밥', '떡볶이', '토스트', '샌드위치',
      '콩나물', '시금치', '멸치', '진미채', '연근', '감자채',
    ];
    
    return lightFoods.any((food) => foodName.contains(food));
  }

  /// 조건에 맞는 동적 이유 텍스트 생성
  /// 음식의 특성을 고려하여 적절한 템플릿을 선택
  static String _generateDynamicReasonText({
    required String foodName,
    required MealTime mealTime,
    required EatingSituation situation,
    required DrinkingStatus drinkingStatus,
    FoodCategory? category,
  }) {
    // 식사시간 텍스트
    final mealTimeText = switch (mealTime) {
      MealTime.breakfast => '아침',
      MealTime.lunch => '점심',
      MealTime.dinner => '저녁',
    };

    // 음주 여부
    final isDrinking = drinkingStatus == DrinkingStatus.yes;

    // 음식의 특성 판단
    final isGoodForGroup = _isGoodForGroupGathering(foodName);
    final isGoodForAloneFood = _isGoodForAlone(foodName);
    final isLight = _isLightFood(foodName);
    
    // 음식 이름 해시를 사용하여 여러 템플릿 중 하나를 선택
    final foodHash = foodName.hashCode.abs();
    
    // 조건별 맞춤 텍스트 생성
    if (situation == EatingSituation.coworkers && isDrinking) {
      // 직장 회식 + 술
      if (isGoodForAloneFood || isLight) {
        // 혼자 먹기 좋은 음식이나 가벼운 음식은 회식 메뉴로 부적절
        // 더 적절한 문구 사용
        final templates = [
          '회식 자리에서 가볍게 즐길 수 있는 $foodName입니다.',
          '동료들과 함께 가볍게 즐기기 좋은 $foodName입니다.',
          '회식 후 가볍게 즐길 수 있는 $foodName입니다.',
          '동료들과 나누며 가볍게 즐기기 좋은 $foodName입니다.',
        ];
        return templates[foodHash % templates.length];
      } else if (isGoodForGroup) {
        // 회식에 어울리는 음식
        final templates = switch (category) {
          FoodCategory.korean => [
            '직장 회식에는 $foodName이 대표 메뉴입니다.',
            '여러 명이 함께 나누며 즐기기 좋은 $foodName입니다.',
            '회식 자리에서 인기 있는 $foodName입니다.',
            '동료들과 함께 즐기기 좋은 $foodName입니다.',
          ],
          FoodCategory.chinese => [
            '직장 회식에 $foodName은 인기 메뉴입니다.',
            '팀원들과 함께 즐기기 좋은 $foodName입니다.',
            '회식 자리에 잘 어울리는 $foodName입니다.',
            '동료들과 나누기 좋은 $foodName입니다.',
          ],
          FoodCategory.japanese => [
            '직장 회식에는 $foodName이 잘 어울립니다.',
            '회식 자리에서 자주 선택하는 $foodName입니다.',
            '동료들과 함께 즐기기 좋은 $foodName입니다.',
            '직장 회식 메뉴로 완벽한 $foodName입니다.',
          ],
          FoodCategory.western => [
            '직장 회식에 $foodName은 실용적인 선택입니다.',
            '다양한 취향을 만족시키는 $foodName입니다.',
            '회식 자리에 잘 어울리는 $foodName입니다.',
            '동료들과 함께 즐기기 좋은 $foodName입니다.',
          ],
          FoodCategory.snack => [
            '직장 회식에 가볍게 즐길 수 있는 $foodName입니다.',
            '분위기를 돋우기 좋은 $foodName입니다.',
            '회식 자리에서 인기 있는 $foodName입니다.',
            '동료들과 함께 즐기기 좋은 $foodName입니다.',
          ],
          null => [
            '직장 회식에는 $foodName이 잘 어울립니다.',
            '동료들과 함께 즐기기 좋은 $foodName입니다.',
            '회식 자리에서 인기 있는 $foodName입니다.',
            '여러 명이 함께 나누기 좋은 $foodName입니다.',
          ],
        };
        return templates[foodHash % templates.length];
      } else {
        // 일반적인 경우
        return '동료들과 함께 즐기기 좋은 $foodName입니다.';
      }
    } else if (situation == EatingSituation.coworkers) {
      // 직장 동료 (술 없음)
      if (isGoodForAloneFood || isLight) {
        // 혼자 먹기 좋은 음식이나 가벼운 음식
        final templates = [
          '동료들과 가볍게 즐길 수 있는 $foodName입니다.',
          '$mealTimeText에 동료들과 함께 가볍게 즐기기 좋은 $foodName입니다.',
          '직장에서 함께 가볍게 즐기기 좋은 $foodName입니다.',
          '동료들과 나누며 가볍게 즐길 수 있는 $foodName입니다.',
        ];
        return templates[foodHash % templates.length];
      } else if (isGoodForGroup) {
        final templates = switch (category) {
          FoodCategory.korean => [
            '$mealTimeText에 동료들과 함께 먹기 좋은 $foodName입니다.',
            '직장 동료들과 함께 즐기기 좋은 $foodName입니다.',
            '팀원들과 나누기 좋은 $foodName입니다.',
            '동료들과 함께 즐거운 식사 시간을 보낼 수 있는 $foodName입니다.',
          ],
          FoodCategory.chinese => [
            '동료들과 함께 즐기기 좋은 $foodName입니다.',
            '직장 동료들과 나누기 좋은 $foodName입니다.',
            '팀원들과 함께 즐거운 식사를 할 수 있는 $foodName입니다.',
            '동료들과 함께 먹기 좋은 $foodName입니다.',
          ],
          FoodCategory.japanese => [
            '직장 동료들과 함께 나누기 좋은 $foodName입니다.',
            '동료들과 함께 즐기기 좋은 $foodName입니다.',
            '팀원들과 나누며 즐길 수 있는 $foodName입니다.',
            '직장에서 함께 먹기 좋은 $foodName입니다.',
          ],
          FoodCategory.western => [
            '동료들과 함께 즐기기 좋은 $foodName입니다.',
            '직장 동료들과 나누기 좋은 $foodName입니다.',
            '팀원들과 함께 즐거운 식사 시간을 보낼 수 있는 $foodName입니다.',
            '동료들과 함께 먹기 좋은 $foodName입니다.',
          ],
          FoodCategory.snack => [
            '동료들과 가볍게 즐길 수 있는 $foodName입니다.',
            '직장 동료들과 함께 즐기기 좋은 $foodName입니다.',
            '가볍게 나누며 즐길 수 있는 $foodName입니다.',
            '동료들과 함께 즐거운 시간을 보낼 수 있는 $foodName입니다.',
          ],
          null => [
            '동료들과 함께 먹기 좋은 $foodName입니다.',
            '직장 동료들과 함께 즐기기 좋은 $foodName입니다.',
            '팀원들과 나누기 좋은 $foodName입니다.',
            '동료들과 함께 즐거운 식사를 할 수 있는 $foodName입니다.',
          ],
        };
        return templates[foodHash % templates.length];
      } else {
        return '동료들과 함께 먹기 좋은 $foodName입니다.';
      }
    } else if (situation == EatingSituation.alone) {
      // 혼자
      if (isGoodForAloneFood) {
        final templates = switch (category) {
          FoodCategory.korean => [
            '$mealTimeText에 혼자 먹기 좋은 든든한 $foodName입니다.',
            '혼자 즐기기에 딱 맞는 $foodName입니다.',
            '$mealTimeText 혼자 식사로 완벽한 $foodName입니다.',
            '혼자 먹기에 부담 없는 $foodName입니다.',
          ],
          FoodCategory.chinese => [
            '혼자 먹기에 부담 없는 $foodName입니다.',
            '혼자 즐기기에 딱 맞는 $foodName입니다.',
            '$mealTimeText 혼자 식사로 좋은 $foodName입니다.',
            '혼자 먹기 좋은 $foodName입니다.',
          ],
          FoodCategory.japanese => [
            '$mealTimeText 혼자 식사하기 좋은 $foodName입니다.',
            '혼자 즐기기에 완벽한 $foodName입니다.',
            '$mealTimeText에 혼자 먹기 좋은 $foodName입니다.',
            '혼자 즐기기 좋은 $foodName입니다.',
          ],
          FoodCategory.western => [
            '혼자 즐기기 좋은 $foodName입니다.',
            '$mealTimeText 혼자 식사로 완벽한 $foodName입니다.',
            '혼자 먹기에 딱 맞는 $foodName입니다.',
            '$mealTimeText에 혼자 즐기기 좋은 $foodName입니다.',
          ],
          FoodCategory.snack => [
            '혼자 가볍게 즐기기 좋은 $foodName입니다.',
            '혼자 즐기기에 딱 맞는 $foodName입니다.',
            '$mealTimeText 혼자 식사로 좋은 $foodName입니다.',
            '혼자 먹기에 부담 없는 $foodName입니다.',
          ],
          null => [
            '$mealTimeText에 혼자 먹기 좋은 $foodName입니다.',
            '혼자 즐기기에 딱 맞는 $foodName입니다.',
            '$mealTimeText 혼자 식사로 완벽한 $foodName입니다.',
            '혼자 먹기에 부담 없는 $foodName입니다.',
          ],
        };
        return templates[foodHash % templates.length];
      } else {
        // 회식용 음식을 혼자 먹는 경우
        return '$mealTimeText에 혼자 먹기 좋은 $foodName입니다.';
      }
    } else if (situation == EatingSituation.partner && isDrinking) {
      // 애인 + 술
      if (isGoodForGroup) {
        final templates = switch (category) {
          FoodCategory.korean => [
            '데이트 코스에 $foodName은 완벽한 선택입니다.',
            '애인과 함께 즐기기 좋은 $foodName입니다.',
            '로맨틱한 분위기의 $foodName입니다.',
            '데이트에 어울리는 $foodName입니다.',
          ],
          FoodCategory.chinese => [
            '애인과 함께 즐기기 좋은 $foodName입니다.',
            '데이트에 어울리는 $foodName입니다.',
            '로맨틱한 분위기의 $foodName입니다.',
            '애인과 함께 나누기 좋은 $foodName입니다.',
          ],
          FoodCategory.japanese => [
            '애인과 함께 특별한 $foodName을 즐겨보세요.',
            '데이트에 어울리는 $foodName입니다.',
            '로맨틱한 분위기의 $foodName입니다.',
            '애인과 함께 즐기기 좋은 $foodName입니다.',
          ],
          FoodCategory.western => [
            '로맨틱한 분위기의 $foodName입니다.',
            '데이트에 완벽한 $foodName입니다.',
            '애인과 함께 즐기기 좋은 $foodName입니다.',
            '데이트 코스로 어울리는 $foodName입니다.',
          ],
          FoodCategory.snack => [
            '애인과 가볍게 즐기기 좋은 $foodName입니다.',
            '데이트에 어울리는 가벼운 $foodName입니다.',
            '로맨틱한 분위기의 $foodName입니다.',
            '애인과 함께 즐기기 좋은 $foodName입니다.',
          ],
          null => [
            '애인과 함께 즐기기 좋은 $foodName입니다.',
            '데이트에 어울리는 $foodName입니다.',
            '로맨틱한 분위기의 $foodName입니다.',
            '애인과 함께 나누기 좋은 $foodName입니다.',
          ],
        };
        return templates[foodHash % templates.length];
      } else {
        return '애인과 함께 즐기기 좋은 $foodName입니다.';
      }
    } else if (situation == EatingSituation.partner) {
      // 애인 (술 없음)
      if (isGoodForGroup) {
        final templates = switch (category) {
          FoodCategory.korean => [
            '애인과 함께 즐기기 좋은 $foodName입니다.',
            '데이트에 어울리는 $foodName입니다.',
            '로맨틱한 분위기의 $foodName입니다.',
            '애인과 함께 나누기 좋은 $foodName입니다.',
          ],
          FoodCategory.chinese => [
            '데이트에 어울리는 $foodName입니다.',
            '애인과 함께 즐기기 좋은 $foodName입니다.',
            '로맨틱한 분위기의 $foodName입니다.',
            '애인과 함께 나누며 즐길 수 있는 $foodName입니다.',
          ],
          FoodCategory.japanese => [
            '애인과 함께 특별한 $foodName을 즐겨보세요.',
            '데이트에 어울리는 $foodName입니다.',
            '로맨틱한 분위기의 $foodName입니다.',
            '애인과 함께 즐기기 좋은 $foodName입니다.',
          ],
          FoodCategory.western => [
            '로맨틱한 분위기의 $foodName입니다.',
            '데이트에 완벽한 $foodName입니다.',
            '애인과 함께 즐기기 좋은 $foodName입니다.',
            '데이트 코스로 어울리는 $foodName입니다.',
          ],
          FoodCategory.snack => [
            '애인과 가볍게 즐기기 좋은 $foodName입니다.',
            '데이트에 어울리는 가벼운 $foodName입니다.',
            '로맨틱한 분위기의 $foodName입니다.',
            '애인과 함께 즐기기 좋은 $foodName입니다.',
          ],
          null => [
            '애인과 함께 즐기기 좋은 $foodName입니다.',
            '데이트에 어울리는 $foodName입니다.',
            '로맨틱한 분위기의 $foodName입니다.',
            '애인과 함께 나누기 좋은 $foodName입니다.',
          ],
        };
        return templates[foodHash % templates.length];
      } else {
        return '애인과 함께 즐기기 좋은 $foodName입니다.';
      }
    } else if (situation == EatingSituation.family && isDrinking) {
      // 가족 + 술
      if (isGoodForGroup) {
        final templates = switch (category) {
          FoodCategory.korean => [
            '가족 모임에 $foodName은 완벽한 선택입니다.',
            '가족과 함께 즐기기 좋은 $foodName입니다.',
            '가족과 함께 나누며 즐거운 시간을 보낼 수 있는 $foodName입니다.',
            '가족 모임에 잘 어울리는 $foodName입니다.',
          ],
          FoodCategory.chinese => [
            '가족과 함께 즐기기 좋은 $foodName입니다.',
            '가족 모임에 어울리는 $foodName입니다.',
            '가족과 함께 나누기 좋은 $foodName입니다.',
            '가족 모임에 잘 어울리는 $foodName입니다.',
          ],
          FoodCategory.japanese => [
            '가족 모임에 잘 어울리는 $foodName입니다.',
            '가족과 함께 즐기기 좋은 $foodName입니다.',
            '가족과 함께 나누며 즐길 수 있는 $foodName입니다.',
            '가족 모임에 완벽한 $foodName입니다.',
          ],
          FoodCategory.western => [
            '가족과 함께 즐기기 좋은 $foodName입니다.',
            '가족 모임에 어울리는 $foodName입니다.',
            '가족과 함께 나누기 좋은 $foodName입니다.',
            '가족 모임에 잘 어울리는 $foodName입니다.',
          ],
          FoodCategory.snack => [
            '가족과 함께 즐기기 좋은 $foodName입니다.',
            '가족 모임에 가볍게 즐길 수 있는 $foodName입니다.',
            '가족과 함께 나누며 즐길 수 있는 $foodName입니다.',
            '가족 모임에 어울리는 $foodName입니다.',
          ],
          null => [
            '가족과 함께 즐기기 좋은 $foodName입니다.',
            '가족 모임에 어울리는 $foodName입니다.',
            '가족과 함께 나누기 좋은 $foodName입니다.',
            '가족 모임에 잘 어울리는 $foodName입니다.',
          ],
        };
        return templates[foodHash % templates.length];
      } else {
        return '가족과 함께 즐기기 좋은 $foodName입니다.';
      }
    } else if (situation == EatingSituation.family) {
      // 가족 (술 없음)
      if (isGoodForGroup || !isGoodForAloneFood) {
        final templates = switch (category) {
          FoodCategory.korean => [
            '가족과 함께 나누기 좋은 $foodName입니다.',
            '가족 식사에 어울리는 $foodName입니다.',
            '가족과 함께 즐기기 좋은 $foodName입니다.',
            '가족 모임에 잘 어울리는 $foodName입니다.',
          ],
          FoodCategory.chinese => [
            '가족 식사에 어울리는 $foodName입니다.',
            '가족과 함께 즐기기 좋은 $foodName입니다.',
            '가족과 함께 나누기 좋은 $foodName입니다.',
            '가족 모임에 잘 어울리는 $foodName입니다.',
          ],
          FoodCategory.japanese => [
            '가족과 함께 즐기기 좋은 $foodName입니다.',
            '가족 모임에 잘 어울리는 $foodName입니다.',
            '가족과 함께 나누며 즐길 수 있는 $foodName입니다.',
            '가족 식사에 어울리는 $foodName입니다.',
          ],
          FoodCategory.western => [
            '가족 식사에 잘 어울리는 $foodName입니다.',
            '가족과 함께 즐기기 좋은 $foodName입니다.',
            '가족과 함께 나누기 좋은 $foodName입니다.',
            '가족 모임에 어울리는 $foodName입니다.',
          ],
          FoodCategory.snack => [
            '가족과 함께 즐기기 좋은 $foodName입니다.',
            '가족 모임에 가볍게 즐길 수 있는 $foodName입니다.',
            '가족과 함께 나누며 즐길 수 있는 $foodName입니다.',
            '가족 식사에 어울리는 $foodName입니다.',
          ],
          null => [
            '가족과 함께 즐기기 좋은 $foodName입니다.',
            '가족 모임에 어울리는 $foodName입니다.',
            '가족과 함께 나누기 좋은 $foodName입니다.',
            '가족 식사에 잘 어울리는 $foodName입니다.',
          ],
        };
        return templates[foodHash % templates.length];
      } else {
        return '가족과 함께 즐기기 좋은 $foodName입니다.';
      }
    } else if (isDrinking) {
      // 일반 + 술
      if (isGoodForGroup) {
        final templates = switch (category) {
          FoodCategory.korean => [
            '$foodName은 술과 잘 어울리는 대표 메뉴입니다.',
            '술과 함께 즐기기 좋은 $foodName입니다.',
            '$foodName은 술안주로 완벽합니다.',
            '술과 함께 나누며 즐길 수 있는 $foodName입니다.',
          ],
          FoodCategory.chinese => [
            '술과 함께 즐기기 좋은 $foodName입니다.',
            '술안주로 완벽한 $foodName입니다.',
            '술과 함께 나누기 좋은 $foodName입니다.',
            '술과 어울리는 $foodName입니다.',
          ],
          FoodCategory.japanese => [
            '$foodName은 술안주로 완벽합니다.',
            '술과 함께 즐기기 좋은 $foodName입니다.',
            '술안주로 인기 있는 $foodName입니다.',
            '술과 함께 나누며 즐길 수 있는 $foodName입니다.',
          ],
          FoodCategory.western => [
            '술과 함께 즐기기 좋은 $foodName입니다.',
            '술안주로 완벽한 $foodName입니다.',
            '술과 함께 나누기 좋은 $foodName입니다.',
            '술과 어울리는 $foodName입니다.',
          ],
          FoodCategory.snack => [
            '술과 함께 즐기기 좋은 가볍은 $foodName입니다.',
            '술안주로 가볍게 즐길 수 있는 $foodName입니다.',
            '술과 함께 가볍게 즐기기 좋은 $foodName입니다.',
            '술안주로 인기 있는 $foodName입니다.',
          ],
          null => [
            '술과 함께 즐기기 좋은 $foodName입니다.',
            '술안주로 완벽한 $foodName입니다.',
            '술과 함께 나누기 좋은 $foodName입니다.',
            '술과 어울리는 $foodName입니다.',
          ],
        };
        return templates[foodHash % templates.length];
      } else if (isLight || isGoodForAloneFood) {
        return '술과 함께 가볍게 즐기기 좋은 $foodName입니다.';
      } else {
        return '술과 함께 즐기기 좋은 $foodName입니다.';
      }
    } else {
      // 일반
      final templates = switch (category) {
        FoodCategory.korean => [
          '$mealTimeText에 먹기 좋은 $foodName입니다.',
          '$mealTimeText 식사로 완벽한 $foodName입니다.',
          '$mealTimeText에 즐기기 좋은 $foodName입니다.',
          '$mealTimeText 식사로 좋은 $foodName입니다.',
        ],
        FoodCategory.chinese => [
          '$mealTimeText 식사로 좋은 $foodName입니다.',
          '$mealTimeText에 먹기 좋은 $foodName입니다.',
          '$mealTimeText 식사로 완벽한 $foodName입니다.',
          '$mealTimeText에 즐기기 좋은 $foodName입니다.',
        ],
        FoodCategory.japanese => [
          '$mealTimeText에 즐기기 좋은 $foodName입니다.',
          '$mealTimeText 식사로 완벽한 $foodName입니다.',
          '$mealTimeText에 먹기 좋은 $foodName입니다.',
          '$mealTimeText 식사로 좋은 $foodName입니다.',
        ],
        FoodCategory.western => [
          '$mealTimeText 식사로 완벽한 $foodName입니다.',
          '$mealTimeText에 먹기 좋은 $foodName입니다.',
          '$mealTimeText 식사로 좋은 $foodName입니다.',
          '$mealTimeText에 즐기기 좋은 $foodName입니다.',
        ],
        FoodCategory.snack => [
          '$mealTimeText에 가볍게 즐기기 좋은 $foodName입니다.',
          '$mealTimeText 식사로 가볍게 즐길 수 있는 $foodName입니다.',
          '$mealTimeText에 먹기 좋은 $foodName입니다.',
          '$mealTimeText 식사로 좋은 $foodName입니다.',
        ],
        null => [
          '$mealTimeText에 먹기 좋은 $foodName입니다.',
          '$mealTimeText 식사로 완벽한 $foodName입니다.',
          '$mealTimeText에 즐기기 좋은 $foodName입니다.',
          '$mealTimeText 식사로 좋은 $foodName입니다.',
        ],
      };
      return templates[foodHash % templates.length];
    }
  }

  /// 문자열을 FoodCategory enum으로 변환
  static FoodCategory? _stringToCategory(String categoryStr) {
    switch (categoryStr) {
      case 'korean':
        return FoodCategory.korean;
      case 'chinese':
        return FoodCategory.chinese;
      case 'japanese':
        return FoodCategory.japanese;
      case 'western':
        return FoodCategory.western;
      case 'snack':
        return FoodCategory.snack;
      default:
        return null;
    }
  }
}
