import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/meal_time.dart';
import '../models/eating_situation.dart';
import '../models/drinking_status.dart';
import '../models/food_category.dart';
import '../models/food_item.dart';
import '../providers/theme_provider.dart';
import '../services/food_service.dart';
import '../services/analytics_service.dart';
import '../utils/responsive_helper.dart';
import '../utils/logger.dart';
import '../widgets/skeleton_loader.dart';
import '../widgets/error_dialog.dart';
import '../widgets/banner_ad_widget.dart';

/// 음식 추천 화면
class RecommendationScreen extends StatefulWidget {
  final MealTime mealTime;
  final EatingSituation situation;
  final DrinkingStatus drinkingStatus;
  final Set<FoodCategory>? selectedCategories;

  const RecommendationScreen({
    super.key,
    required this.mealTime,
    required this.situation,
    required this.drinkingStatus,
    this.selectedCategories,
  });

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen>
    with SingleTickerProviderStateMixin {
  List<FoodItem> recommendations = [];
  bool isLoading = true;
  int currentIndex = 0;
  late PageController _pageController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _loadRecommendations();
  }

  Future<void> _loadRecommendations() async {
    try {
      final foods = await FoodService.getRecommendations(
        mealTime: widget.mealTime,
        situation: widget.situation,
        drinkingStatus: widget.drinkingStatus,
        selectedCategories: widget.selectedCategories,
      );

      if (mounted) {
        setState(() {
          recommendations = foods;
          isLoading = false;
        });
        _animationController.forward();
        
        // Analytics: 추천 결과 조회 추적
        if (foods.isNotEmpty) {
          // 카테고리 정보는 선택된 카테고리에서 가져오기
          String? firstCategory;
          if (widget.selectedCategories != null && widget.selectedCategories!.isNotEmpty) {
            firstCategory = widget.selectedCategories!.first.name;
          }
          
          AnalyticsService.logRecommendationViewed(
            recommendationCount: foods.length,
            firstFoodName: foods[0].name,
            firstFoodCategory: firstCategory,
          );
        }
      }
    } catch (e) {
      AppLogger.error('Error loading recommendations', e);
      
      // Analytics: 추천 실패 추적
      AnalyticsService.logRecommendationFailed(
        errorType: 'load_error',
        mealTime: widget.mealTime,
        categories: widget.selectedCategories,
      );
      
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        // 사용자 친화적인 에러 다이얼로그 표시
        await ErrorDialog.show(
          context,
          title: '데이터 불러오기 실패',
          message: '음식 추천을 불러오는 중 문제가 발생했습니다.\n잠시 후 다시 시도해주세요.',
          actionText: '다시 시도',
          onAction: () {
            setState(() {
              isLoading = true;
            });
            _loadRecommendations();
          },
        );
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (isLoading) {
      final isLandscape = ResponsiveHelper.isLandscape(context);
      
      return Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: Center(
            child: isLandscape
                ? // 가로모드: 스켈레톤 카드 제외
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Colors.orange,
                          strokeWidth: 3.0,
                        ),
                        SizedBox(
                          height: ResponsiveHelper.getResponsiveSpacing(
                            context,
                            normal: 24,
                            small: 16,
                          ),
                        ),
                        Text(
                          '데이터를 불러오는 중...',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              normal: 18,
                              small: 16,
                            ),
                            color: isDark ? Colors.white70 : Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                : // 세로모드: 스켈레톤 카드 포함
                  SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.all(
                          ResponsiveHelper.getResponsiveSpacing(
                            context,
                            normal: 24,
                            small: 16,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.2,
                            ),
                            CircularProgressIndicator(
                              color: Colors.orange,
                              strokeWidth: 3.0,
                            ),
                            SizedBox(
                              height: ResponsiveHelper.getResponsiveSpacing(
                                context,
                                normal: 24,
                                small: 16,
                              ),
                            ),
                            Text(
                              '데이터를 불러오는 중...',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  normal: 16,
                                  small: 14,
                                ),
                                color: isDark ? Colors.white70 : Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: ResponsiveHelper.getResponsiveSpacing(
                                context,
                                normal: 48,
                                small: 32,
                              ),
                            ),
                            // 스켈레톤 카드 미리보기
                            RecommendationCardSkeleton(isDark: isDark),
                          ],
                        ),
                      ),
                    ),
          ),
        ),
      );
    }

    if (recommendations.isEmpty) {
      return Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.white,
        appBar: AppBar(
          title: const Text(
            '이따가 뭐 먹지',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Text(
            '추천할 음식이 없습니다.',
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),
        ),
      );
    }

    final hasMoreOptions = recommendations.length > 1;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              HapticFeedback.selectionClick();
              context.read<ThemeProvider>().toggleTheme();
            },
            tooltip: isDark ? '라이트 모드' : '다크 모드',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF1A1A1A),
                    const Color(0xFF2D2D2D),
                  ]
                : [
                    Colors.white,
                    Colors.orange.shade50,
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 메인 콘텐츠 영역
              Expanded(
                child: Column(
                  children: [
                    // 인디케이터 (여러 옵션이 있을 때만)
                    if (hasMoreOptions) ...[
                SizedBox(
                  height: ResponsiveHelper.getResponsiveSpacing(
                    context,
                    normal: 16,
                    small: 12,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    recommendations.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.getResponsiveSpacing(
                          context,
                          normal: 4,
                          small: 3,
                        ),
                      ),
                      width: currentIndex == index
                          ? ResponsiveHelper.getResponsiveFontSize(
                              context,
                              normal: 24,
                              small: 20,
                            )
                          : ResponsiveHelper.getResponsiveFontSize(
                              context,
                              normal: 8,
                              small: 6,
                            ),
                      height: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        normal: 8,
                        small: 6,
                      ),
                      decoration: BoxDecoration(
                        color: currentIndex == index
                            ? Colors.orange
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: ResponsiveHelper.getResponsiveSpacing(
                    context,
                    normal: 16,
                    small: 12,
                  ),
                ),
              ],
              // 음식 카드
              Expanded(
                child: GestureDetector(
                  onVerticalDragEnd: (details) {
                    // 아래로 스와이프하면 새로고침
                    if (details.primaryVelocity != null && details.primaryVelocity! > 500) {
                      HapticFeedback.mediumImpact();
                      
                      // Analytics: 다시 추천받기 추적 (스와이프)
                      AnalyticsService.logRecommendationRefreshed(
                        previousFoodName: recommendations.isNotEmpty ? recommendations[currentIndex].name : null,
                        viewedBeforeRefresh: currentIndex + 1,
                      );
                      
                      setState(() {
                        isLoading = true;
                        currentIndex = 0;
                      });
                      _loadRecommendations();
                    }
                  },
                  child: PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: (index) {
                      if (mounted) {
                        setState(() {
                          currentIndex = index;
                        });
                        HapticFeedback.selectionClick();
                        
                        // Analytics: 다른 옵션 보기 추적
                        if (index > 0) {
                          AnalyticsService.logViewAnotherOption(
                            currentIndex: index,
                            totalCount: recommendations.length,
                          );
                        }
                      }
                    },
                    itemCount: recommendations.length,
                    itemBuilder: (context, index) {
                      return _buildFoodCard(recommendations[index]);
                    },
                  ),
                ),
              ),
              // 배너 광고 영역 (버튼들 위)
              const BannerAdWidget(),
              SizedBox(
                height: ResponsiveHelper.getResponsiveSpacing(
                  context,
                  normal: 16,
                  small: 12,
                ),
              ),
              // 버튼들
              Padding(
                padding: EdgeInsets.only(
                  left: ResponsiveHelper.getResponsiveSpacing(
                    context,
                    normal: 24.0,
                    small: 16.0,
                  ),
                  right: ResponsiveHelper.getResponsiveSpacing(
                    context,
                    normal: 24.0,
                    small: 16.0,
                  ),
                  top: ResponsiveHelper.getResponsiveSpacing(
                    context,
                    normal: 24.0,
                    small: 16.0,
                  ),
                  bottom: ResponsiveHelper.getResponsiveSpacing(
                    context,
                    normal: 24.0,
                    small: 16.0,
                  ),
                ),
                child: Column(
                  children: [
                    // "이거 먹을래" 버튼
                    SizedBox(
                      width: double.infinity,
                      height: ResponsiveHelper.getResponsiveButtonHeight(
                        context,
                        normal: 64,
                        small: 56,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          
                          // Analytics: 음식 결정 추적
                          if (recommendations.isNotEmpty) {
                            final selectedFood = recommendations[currentIndex];
                            // 카테고리 정보는 선택된 카테고리에서 가져오기
                            String category = 'unknown';
                            if (widget.selectedCategories != null && widget.selectedCategories!.isNotEmpty) {
                              category = widget.selectedCategories!.first.name;
                            }
                            
                            AnalyticsService.logFoodSelected(
                              foodName: selectedFood.name,
                              category: category,
                              selectedIndex: currentIndex,
                              totalOptionsViewed: currentIndex + 1,
                              totalRecommendations: recommendations.length,
                            );
                          }
                          
                          _showCompletionDialog();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          elevation: 8,
                          shadowColor: Colors.orange.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          '이거 먹을래',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              normal: 20,
                              small: 18,
                            ),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    // "다른 옵션 보기" 버튼
                    if (hasMoreOptions) ...[
                      SizedBox(
                        height: ResponsiveHelper.getResponsiveSpacing(
                          context,
                          normal: 16,
                          small: 12,
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: ResponsiveHelper.getResponsiveButtonHeight(
                          context,
                          normal: 56,
                          small: 50,
                        ),
                        child: OutlinedButton(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            
                            if (!mounted) return;
                            
                            final nextIndex = (currentIndex + 1) % recommendations.length;
                            
                            // Analytics: 다른 옵션 보기 추적 (버튼 클릭)
                            AnalyticsService.logViewAnotherOption(
                              currentIndex: nextIndex,
                              totalCount: recommendations.length,
                            );
                            
                            // 모든 모드에서 jumpToPage 사용 (더 안정적)
                            if (_pageController.hasClients) {
                              try {
                                _pageController.jumpToPage(nextIndex);
                                setState(() {
                                  currentIndex = nextIndex;
                                });
                              } catch (e) {
                                // 에러 발생 시 인덱스만 변경
                                if (mounted) {
                                  setState(() {
                                    currentIndex = nextIndex;
                                  });
                                }
                              }
                            } else {
                              // PageController가 준비되지 않았으면 인덱스만 변경
                              setState(() {
                                currentIndex = nextIndex;
                              });
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.orange,
                            side: const BorderSide(color: Colors.orange, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            '다른 옵션 보기',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                normal: 18,
                                small: 16,
                              ),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
                    ],
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFoodCard(FoodItem food) {
    return RepaintBoundary(
      child: _FoodCardWidget(
        food: food,
        animationController: _animationController,
      ),
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final isLandscape = ResponsiveHelper.isLandscape(context);
        final isDark = Theme.of(context).brightness == Brightness.dark;
        
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(
                  isLandscape ? 20.0 : 24.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: isLandscape ? 12.0 : 16.0,
                    ),
                    Text(
                      '🍽️',
                      style: TextStyle(
                        fontSize: isLandscape ? 48.0 : 64.0,
                      ),
                    ),
                    SizedBox(height: isLandscape ? 12.0 : 16.0),
                    Text(
                      '맛있게 드세요!',
                      style: TextStyle(
                        fontSize: isLandscape ? 20.0 : 24.0,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                      ),
                    ),
                    SizedBox(height: isLandscape ? 16.0 : 24.0),
                if (isLandscape)
                  // 가로모드: 세로 배치
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            HapticFeedback.selectionClick();
                            
                            // Analytics: 다시 추천받기 추적
                            AnalyticsService.logRecommendationRefreshed(
                              previousFoodName: recommendations.isNotEmpty ? recommendations[currentIndex].name : null,
                              viewedBeforeRefresh: currentIndex + 1,
                            );
                            
                            Navigator.of(context).pop();
                            Navigator.of(context).pop(true);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.orange,
                            side: const BorderSide(color: Colors.orange, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('다시 추천받기'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            
                            // Analytics: 처음으로 돌아가기 추적
                            AnalyticsService.logReturnedToStart();
                            
                            // MainScreen까지 모든 화면 제거 (하단바가 있는 MainScreen으로 돌아가기)
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('처음으로'),
                        ),
                      ),
                    ],
                  )
                else
                  // 세로모드: 가로 배치
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            HapticFeedback.selectionClick();
                            
                            // Analytics: 다시 추천받기 추적
                            AnalyticsService.logRecommendationRefreshed(
                              previousFoodName: recommendations.isNotEmpty ? recommendations[currentIndex].name : null,
                              viewedBeforeRefresh: currentIndex + 1,
                            );
                            
                            Navigator.of(context).pop();
                            Navigator.of(context).pop(true);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.orange,
                            side: const BorderSide(color: Colors.orange, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('다시 추천받기'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            
                            // Analytics: 처음으로 돌아가기 추적
                            AnalyticsService.logReturnedToStart();
                            
                            // MainScreen까지 모든 화면 제거 (하단바가 있는 MainScreen으로 돌아가기)
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('처음으로'),
                        ),
                      ),
                    ],
                  ),
                  ],
                ),
              ),
              // X 버튼
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: isDark ? Colors.white70 : Colors.grey.shade600,
                    size: 24,
                  ),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    Navigator.of(context).pop();
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// 성능 최적화: 카드를 별도 위젯으로 분리
class _FoodCardWidget extends StatelessWidget {
  final FoodItem food;
  final AnimationController animationController;

  const _FoodCardWidget({
    required this.food,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLandscape = ResponsiveHelper.isLandscape(context);
    
    return FadeTransition(
      opacity: animationController,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.getResponsiveSpacing(
            context,
            normal: 24.0,
            small: 16.0,
          ),
        ),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        Colors.grey.shade800,
                        Colors.grey.shade900,
                      ]
                    : [
                        Colors.white,
                        Colors.orange.shade50,
                      ],
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Scrollbar(
              thumbVisibility: true, // 항상 스크롤바 표시
              thickness: 6.0, // 스크롤바 두께
              radius: const Radius.circular(3), // 스크롤바 모서리 둥글게
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(), // 네이티브처럼 부드러운 스크롤
                child: Padding(
                  padding: EdgeInsets.all(
                    isLandscape
                        ? ResponsiveHelper.getResponsiveSpacing(
                            context,
                            normal: 16.0,
                            small: 12.0,
                          )
                        : ResponsiveHelper.getResponsiveSpacing(
                            context,
                            normal: 32.0,
                            small: 20.0,
                          ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    // 음식 이모지
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: child,
                        );
                      },
                      child: Text(
                        food.imageUrl,
                        style: TextStyle(
                          fontSize: isLandscape
                              ? ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  normal: 80,
                                  small: 60,
                                )
                              : ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  normal: 140,
                                  small: 100,
                                ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: isLandscape
                          ? ResponsiveHelper.getResponsiveSpacing(
                              context,
                              normal: 16,
                              small: 12,
                            )
                          : ResponsiveHelper.getResponsiveSpacing(
                              context,
                              normal: 32,
                              small: 20,
                            ),
                    ),
                    // 음식 이름
                    Text(
                      food.name,
                      style: TextStyle(
                        fontSize: isLandscape
                            ? ResponsiveHelper.getResponsiveFontSize(
                                context,
                                normal: 24,
                                small: 20,
                              )
                            : ResponsiveHelper.getResponsiveFontSize(
                                context,
                                normal: 36,
                                small: 28,
                              ),
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(
                      height: isLandscape
                          ? ResponsiveHelper.getResponsiveSpacing(
                              context,
                              normal: 12,
                              small: 8,
                            )
                          : ResponsiveHelper.getResponsiveSpacing(
                              context,
                              normal: 24,
                              small: 16,
                            ),
                    ),
                    // 추천 이유
                    Container(
                      padding: EdgeInsets.all(
                        isLandscape
                            ? ResponsiveHelper.getResponsiveSpacing(
                                context,
                                normal: 12,
                                small: 10,
                              )
                            : ResponsiveHelper.getResponsiveSpacing(
                                context,
                                normal: 20,
                                small: 16,
                              ),
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey.shade700 : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        food.reasonText,
                        style: TextStyle(
                          fontSize: isLandscape
                              ? ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  normal: 14,
                                  small: 12,
                                )
                              : ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  normal: 17,
                                  small: 15,
                                ),
                          height: 1.6,
                          color: isDark ? Colors.grey.shade200 : const Color(0xFF555555),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
    );
  }
}
