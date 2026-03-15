import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/meal_time.dart';
import '../providers/theme_provider.dart';
import '../utils/responsive_helper.dart';
import '../widgets/interactive_button.dart';
import '../services/analytics_service.dart';
import 'situation_screen.dart';

/// 식사 시간 선택 화면
class MealTimeScreen extends StatefulWidget {
  const MealTimeScreen({super.key});

  @override
  State<MealTimeScreen> createState() => _MealTimeScreenState();
}

class _MealTimeScreenState extends State<MealTimeScreen> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // 첫 프레임 후에 복잡한 레이아웃 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 초기화되지 않았으면 간단한 로딩 화면 표시
    if (!_isInitialized) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF1A1A1A), const Color(0xFF2D2D2D)]
                : [Colors.white, Colors.orange.shade50],
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.orange,
          ),
        ),
      );
    }
    
    // 로그는 이미 찍었으므로, 이제 Container를 return
    return Container(
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
              // AppBar 수동 구현
              Container(
                height: kToolbarHeight,
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.getResponsiveSpacing(
                    context,
                    normal: 8.0,
                    small: 4.0,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
              ),
              // 본문 내용
              Expanded(
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
                    
                    if (orientation == Orientation.landscape) {
                      // 가로 모드: Row 레이아웃 (RepaintBoundary로 격리)
                      return RepaintBoundary(
                        key: const ValueKey('landscape_layout'),
                        child: Padding(
                          padding: EdgeInsets.all(padding),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 왼쪽: 타이틀
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOut,
                              builder: (context, value, child) {
                                return Opacity(
                                  opacity: value,
                                  child: Transform.translate(
                                    offset: Offset(0, 20 * (1 - value)),
                                    child: child,
                                  ),
                                );
                              },
                              child: Text(
                                '이따가 뭐 먹지',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                                    context,
                                    normal: 28,
                                    small: 24,
                                  ),
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                                  decoration: TextDecoration.none,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: ResponsiveHelper.getResponsiveSpacing(
                                context,
                                normal: 16,
                                small: 12,
                              ),
                            ),
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOut,
                              builder: (context, value, child) {
                                return Opacity(
                                  opacity: value,
                                  child: Transform.translate(
                                    offset: Offset(0, 20 * (1 - value)),
                                    child: child,
                                  ),
                                );
                              },
                              child: Text(
                                '언제 드실 건가요?',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                                    context,
                                    normal: 20,
                                    small: 18,
                                  ),
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? Colors.grey.shade300 : const Color(0xFF666666),
                                  decoration: TextDecoration.none,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: ResponsiveHelper.getResponsiveSpacing(
                          context,
                          normal: 32,
                          small: 16,
                        ),
                      ),
                      // 오른쪽: 버튼들
                      Expanded(
                        flex: 3,
                        child: RepaintBoundary(
                          child: Scrollbar(
                            thumbVisibility: true,
                            thickness: 6.0,
                            radius: const Radius.circular(3),
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildMealTimeButton(
                                    context,
                                    MealTime.breakfast,
                                    '🌅',
                                    [Color(0xFFFFE5CC), Color(0xFFFFD4A3)],
                                    0,
                                    isDark,
                                  ),
                                  SizedBox(
                                    height: ResponsiveHelper.getResponsiveSpacing(
                                      context,
                                      normal: 12,
                                      small: 8,
                                    ),
                                  ),
                                  _buildMealTimeButton(
                                    context,
                                    MealTime.lunch,
                                    '☀️',
                                    [Color(0xFFFFF4CC), Color(0xFFFFE8A3)],
                                    1,
                                    isDark,
                                  ),
                                  SizedBox(
                                    height: ResponsiveHelper.getResponsiveSpacing(
                                      context,
                                      normal: 12,
                                      small: 8,
                                    ),
                                  ),
                                  _buildMealTimeButton(
                                    context,
                                    MealTime.dinner,
                                    '🌙',
                                    [Color(0xFFE5F0FF), Color(0xFFCCE0FF)],
                                    2,
                                    isDark,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                        ),
                      );
                    }
                    
                    // 세로 모드: Column 레이아웃 (기존)
                    return RepaintBoundary(
                      key: const ValueKey('portrait_layout'),
                      child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 앱 타이틀
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: Text(
                          '이따가 뭐 먹지',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              normal: 32,
                              small: 26,
                            ),
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                            decoration: TextDecoration.none,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveHelper.getResponsiveSpacing(
                          context,
                          normal: 16,
                          small: 12,
                        ),
                      ),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: Text(
                          '언제 드실 건가요?',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              normal: 24,
                              small: 20,
                            ),
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.grey.shade300 : const Color(0xFF666666),
                            decoration: TextDecoration.none,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveHelper.getResponsiveSpacing(
                          context,
                          normal: 64,
                          small: 32,
                        ),
                      ),
                      // 아침 버튼
                      _buildMealTimeButton(
                        context,
                        MealTime.breakfast,
                        '🌅',
                        [Color(0xFFFFE5CC), Color(0xFFFFD4A3)],
                        0,
                        isDark,
                      ),
                      SizedBox(
                        height: ResponsiveHelper.getResponsiveSpacing(
                          context,
                          normal: 20,
                          small: 12,
                        ),
                      ),
                      // 점심 버튼
                      _buildMealTimeButton(
                        context,
                        MealTime.lunch,
                        '☀️',
                        [Color(0xFFFFF4CC), Color(0xFFFFE8A3)],
                        1,
                        isDark,
                      ),
                      SizedBox(
                        height: ResponsiveHelper.getResponsiveSpacing(
                          context,
                          normal: 20,
                          small: 12,
                        ),
                      ),
                      // 저녁 버튼
                      _buildMealTimeButton(
                        context,
                        MealTime.dinner,
                        '🌙',
                        [Color(0xFFE5F0FF), Color(0xFFCCE0FF)],
                        2,
                        isDark,
                      ),
                    ],
                  ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
    );
  }

  Widget _buildMealTimeButton(
    BuildContext context,
    MealTime mealTime,
    String emoji,
    List<Color> gradientColors,
    int index,
    bool isDark,
  ) {
    final isLandscape = ResponsiveHelper.isLandscape(context);
    
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 50)),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(
            scale: 0.8 + (0.2 * value),
            child: child,
          ),
        );
      },
      child: Container(
        height: ResponsiveHelper.getResponsiveButtonHeight(
          context,
          normal: isLandscape ? 60 : 90,
          small: 70,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    // 다크 모드용 어두운 그라데이션
                    gradientColors[0].withOpacity(0.3),
                    gradientColors[1].withOpacity(0.3),
                  ]
                : gradientColors,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: InteractiveButton(
          onPressed: () {
            // Analytics: 식사 시간 선택 추적
            AnalyticsService.logMealTimeSelected(mealTime);
            
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    SituationScreen(
                      mealTime: mealTime,
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
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      )),
                      child: child,
                    ),
                  );
                },
                transitionDuration: const Duration(milliseconds: 350),
              ),
            );
          },
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      emoji,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          normal: 40,
                          small: 32,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: ResponsiveHelper.getResponsiveSpacing(
                        context,
                        normal: 20,
                        small: 12,
                      ),
                    ),
                    Text(
                      mealTime.label,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          normal: 26,
                          small: 22,
                        ),
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                      ),
                    ),
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
