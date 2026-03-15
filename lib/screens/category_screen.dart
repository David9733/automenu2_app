import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/meal_time.dart';
import '../models/eating_situation.dart';
import '../models/drinking_status.dart';
import '../models/food_category.dart';
import '../providers/theme_provider.dart';
import '../utils/responsive_helper.dart';
import '../widgets/interactive_button.dart';
import '../widgets/error_dialog.dart';
import '../widgets/banner_ad_widget.dart';
import '../services/analytics_service.dart';
import '../utils/logger.dart';
import 'recommendation_screen.dart';

/// 음식 종류 선택 화면
class CategoryScreen extends StatefulWidget {
  final MealTime mealTime;
  final EatingSituation situation;
  final DrinkingStatus drinkingStatus;

  const CategoryScreen({
    super.key,
    required this.mealTime,
    required this.situation,
    required this.drinkingStatus,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  Set<FoodCategory> selectedCategories = {};
  bool isAnyCategory = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () {
            HapticFeedback.selectionClick();
            Navigator.pop(context);
          },
        ),
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
          child: Builder(
            builder: (context) {
              // MediaQuery.of(context).orientation을 사용하여
              // MaterialApp의 OrientationBuilder와 동기화
              final orientation = MediaQuery.of(context).orientation;
              final padding = ResponsiveHelper.getResponsiveSpacing(
                context,
                normal: 24.0,
                small: 16.0,
              );
              
              return Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: ResponsiveHelper.getResponsiveSpacing(
                        context,
                        normal: 16,
                        small: 8,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            '🍽️ 음식 종류',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                normal: 28,
                                small: 24,
                              ),
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() {
                              isAnyCategory = !isAnyCategory;
                              if (isAnyCategory) {
                                selectedCategories.clear();
                              }
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveHelper.getResponsiveSpacing(
                                context,
                                normal: 12,
                                small: 8,
                              ),
                              vertical: ResponsiveHelper.getResponsiveSpacing(
                                context,
                                normal: 8,
                                small: 6,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '상관없음',
                                  style: TextStyle(
                                    fontSize: ResponsiveHelper.getResponsiveFontSize(
                                      context,
                                      normal: orientation == Orientation.landscape ? 18 : 16,
                                      small: 14,
                                    ),
                                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  width: ResponsiveHelper.getResponsiveSpacing(
                                    context,
                                    normal: 8,
                                    small: 6,
                                  ),
                                ),
                                SizedBox(
                                  width: orientation == Orientation.landscape ? 28 : 24,
                                  height: orientation == Orientation.landscape ? 28 : 24,
                                  child: Checkbox(
                                    value: isAnyCategory,
                                    onChanged: (value) {
                                      HapticFeedback.selectionClick();
                                      setState(() {
                                        isAnyCategory = value ?? false;
                                        if (isAnyCategory) {
                                          selectedCategories.clear();
                                        }
                                      });
                                      
                                      // Analytics: 음식 종류 선택 추적 (상관없음)
                                      AnalyticsService.logFoodCategorySelected(
                                        categories: selectedCategories,
                                        isAnyCategory: isAnyCategory,
                                      );
                                    },
                                    activeColor: Colors.orange,
                                    materialTapTargetSize: MaterialTapTargetSize.padded,
                                    visualDensity: VisualDensity.standard,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: ResponsiveHelper.getResponsiveSpacing(
                        context,
                        normal: 24,
                        small: 16,
                      ),
                    ),
                    Expanded(
                      child: Scrollbar(
                        thumbVisibility: true,
                        thickness: 6.0,
                        radius: const Radius.circular(3),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                            if (!isAnyCategory) ...[
                              SizedBox(
                                height: ResponsiveHelper.getResponsiveSpacing(
                                  context,
                                  normal: 8,
                                  small: 4,
                                ),
                              ),
                              // 음식 종류 선택 (세로로 쌓기)
                              _buildCategoryButton(FoodCategory.korean, isDark),
                              SizedBox(
                                height: ResponsiveHelper.getResponsiveSpacing(
                                  context,
                                  normal: 16,
                                  small: 12,
                                ),
                              ),
                              _buildCategoryButton(FoodCategory.japanese, isDark),
                              SizedBox(
                                height: ResponsiveHelper.getResponsiveSpacing(
                                  context,
                                  normal: 16,
                                  small: 12,
                                ),
                              ),
                              _buildCategoryButton(FoodCategory.western, isDark),
                              SizedBox(
                                height: ResponsiveHelper.getResponsiveSpacing(
                                  context,
                                  normal: 16,
                                  small: 12,
                                ),
                              ),
                              _buildCategoryButton(FoodCategory.chinese, isDark),
                              SizedBox(
                                height: ResponsiveHelper.getResponsiveSpacing(
                                  context,
                                  normal: 16,
                                  small: 12,
                                ),
                              ),
                              _buildCategoryButton(FoodCategory.snack, isDark),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                    SizedBox(
                      height: ResponsiveHelper.getResponsiveSpacing(
                        context,
                        normal: 32,
                        small: 16,
                      ),
                    ),
                    // 배너 광고 영역 (추천 받기 버튼 위)
                    const BannerAdWidget(),
                    SizedBox(
                      height: ResponsiveHelper.getResponsiveSpacing(
                        context,
                        normal: 16,
                        small: 12,
                      ),
                    ),
                    // 추천 받기 버튼
                    SizedBox(
                      height: ResponsiveHelper.getResponsiveButtonHeight(
                        context,
                        normal: 64,
                        small: 56,
                      ),
                      child: ElevatedButton(
                        onPressed: (!isLoading && (isAnyCategory || selectedCategories.isNotEmpty))
                            ? () {
                                HapticFeedback.mediumImpact();
                                
                                // Analytics: 추천 요청 추적
                                AnalyticsService.logRecommendationRequest(
                                  mealTime: widget.mealTime,
                                  situation: widget.situation,
                                  drinkingStatus: widget.drinkingStatus,
                                  categories: isAnyCategory
                                      ? null
                                      : (selectedCategories.isEmpty
                                          ? null
                                          : selectedCategories),
                                  isAnyCategory: isAnyCategory,
                                );
                                
                                setState(() {
                                  isLoading = true;
                                });
                                // 로딩 효과를 위한 짧은 딜레이
                                Future.delayed(const Duration(milliseconds: 500), () async {
                                  if (mounted) {
                                    try {
                                      await Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation, secondaryAnimation) =>
                                              RecommendationScreen(
                                            mealTime: widget.mealTime,
                                            situation: widget.situation,
                                            drinkingStatus: widget.drinkingStatus,
                                            selectedCategories: isAnyCategory
                                                ? null
                                                : (selectedCategories.isEmpty
                                                    ? null
                                                    : selectedCategories),
                                          ),
                                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                            // 부드러운 페이드 인 효과
                                            return FadeTransition(
                                              opacity: CurvedAnimation(
                                                parent: animation,
                                                curve: Curves.easeIn,
                                              ),
                                              child: SlideTransition(
                                                position: Tween<Offset>(
                                                  begin: const Offset(0.0, 0.3),
                                                  end: Offset.zero,
                                                ).animate(CurvedAnimation(
                                                  parent: animation,
                                                  curve: Curves.easeOutCubic,
                                                )),
                                                child: child,
                                              ),
                                            );
                                          },
                                          transitionDuration: const Duration(milliseconds: 400),
                                        ),
                                      );
                                    } catch (e) {
                                      AppLogger.error('Error navigating to RecommendationScreen', e);
                                      
                                      // Analytics: 추천 실패 추적
                                      AnalyticsService.logRecommendationFailed(
                                        errorType: 'navigation_error',
                                        mealTime: widget.mealTime,
                                        categories: isAnyCategory
                                            ? null
                                            : (selectedCategories.isEmpty
                                                ? null
                                                : selectedCategories),
                                      );
                                      
                                      if (mounted) {
                                        await ErrorDialog.show(
                                          context,
                                          title: '화면 전환 실패',
                                          message: '추천 화면으로 이동하는 중 문제가 발생했습니다.\n잠시 후 다시 시도해주세요.',
                                        );
                                      }
                                    } finally {
                                      if (mounted) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    }
                                  }
                                });
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (isAnyCategory || selectedCategories.isNotEmpty)
                              ? Colors.orange
                              : Colors.grey.shade300,
                          foregroundColor: Colors.white,
                          elevation: (isAnyCategory || selectedCategories.isNotEmpty) ? 8 : 0,
                          shadowColor: (isAnyCategory || selectedCategories.isNotEmpty)
                              ? Colors.orange.withOpacity(0.4)
                              : Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              normal: 24,
                              small: 20,
                            ),
                            vertical: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              normal: 16,
                              small: 12,
                            ),
                          ),
                          minimumSize: Size(
                            double.infinity,
                            ResponsiveHelper.getResponsiveButtonHeight(
                              context,
                              normal: 64,
                              small: 56,
                            ),
                          ),
                        ),
                        child: isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: ResponsiveHelper.getResponsiveFontSize(
                                      context,
                                      normal: 20,
                                      small: 18,
                                    ),
                                    width: ResponsiveHelper.getResponsiveFontSize(
                                      context,
                                      normal: 20,
                                      small: 18,
                                    ),
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    '데이터를 불러오는 중...',
                                    style: TextStyle(
                                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                                        context,
                                        normal: 18,
                                        small: 16,
                                      ),
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.3,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                '추천 받기',
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
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton(FoodCategory category, bool isDark) {
    final isSelected = selectedCategories.contains(category);
    
    return RepaintBoundary(
      child: _CategoryButtonWidget(
        category: category,
        isSelected: isSelected,
        isDark: isDark,
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() {
            if (isSelected) {
              selectedCategories.remove(category);
            } else {
              selectedCategories.add(category);
            }
          });
          
          // Analytics: 음식 종류 선택 추적
          AnalyticsService.logFoodCategorySelected(
            categories: selectedCategories,
            isAnyCategory: isAnyCategory,
          );
        },
      ),
    );
  }
}

// 성능 최적화: 카테고리 버튼을 별도 위젯으로 분리
class _CategoryButtonWidget extends StatelessWidget {
  final FoodCategory category;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _CategoryButtonWidget({
    required this.category,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLandscape = ResponsiveHelper.isLandscape(context);

    return InteractiveButton(
      onPressed: onTap,
      child: Container(
      height: ResponsiveHelper.getResponsiveButtonHeight(
        context,
        normal: isLandscape ? 64 : 80,
        small: 70,
      ),
      margin: EdgeInsets.symmetric(
        vertical: ResponsiveHelper.getResponsiveSpacing(
          context,
          normal: 4,
          small: 2,
        ),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isSelected
              ? (isDark
                  ? [
                      Colors.orange.withOpacity(0.3),
                      Colors.orange.withOpacity(0.2),
                    ]
                  : [
                      Colors.orange.shade100,
                      Colors.orange.shade50,
                    ])
              : (isDark
                  ? [Colors.grey.shade800, Colors.grey.shade800]
                  : [Colors.grey.shade100, Colors.grey.shade100]),
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? Colors.orange : Colors.transparent,
          width: 2.5,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.getResponsiveSpacing(
                context,
                normal: 20,
                small: 16,
              ),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    category.label,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        normal: 22,
                        small: 20,
                      ),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                    ),
                  ),
                  if (isSelected) ...[
                    SizedBox(
                      width: ResponsiveHelper.getResponsiveSpacing(
                        context,
                        normal: 12,
                        small: 8,
                      ),
                    ),
                    Icon(
                      Icons.check_circle,
                      color: Colors.orange,
                      size: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        normal: 24,
                        small: 20,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    ),
    );
  }
}

