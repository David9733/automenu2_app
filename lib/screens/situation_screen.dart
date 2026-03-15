import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/meal_time.dart';
import '../models/eating_situation.dart';
import '../providers/theme_provider.dart';
import '../utils/responsive_helper.dart';
import '../widgets/interactive_button.dart';
import '../widgets/banner_ad_widget.dart';
import '../services/analytics_service.dart';
import 'drinking_screen.dart';

/// 식사 상황 선택 화면
class SituationScreen extends StatefulWidget {
  final MealTime mealTime;

  const SituationScreen({
    super.key,
    required this.mealTime,
  });

  @override
  State<SituationScreen> createState() => _SituationScreenState();
}

class _SituationScreenState extends State<SituationScreen>
    with SingleTickerProviderStateMixin {
  EatingSituation? selectedSituation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.stop();
    _animationController.dispose();
    super.dispose();
  }

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
            if (!mounted) return;
            HapticFeedback.selectionClick();
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
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
          child: Column(
            children: [
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
                    
                    return RepaintBoundary(
                      key: ValueKey('situation_layout_$orientation'),
                      child: Padding(
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
                          Text(
                            '누구와 드시나요?',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                normal: 28,
                                small: 24,
                              ),
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: orientation == Orientation.landscape
                                ? ResponsiveHelper.getResponsiveSpacing(
                                    context,
                                    normal: 64,
                                    small: 32,
                                  )
                                : 36.0,
                          ),
                          Expanded(
                            child: orientation == Orientation.landscape
                                ? RepaintBoundary(
                                    child: Scrollbar(
                                      thumbVisibility: true,
                                      thickness: 6.0,
                                      radius: const Radius.circular(3),
                                      child: SingleChildScrollView(
                                        physics: const BouncingScrollPhysics(),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: ResponsiveHelper.getResponsiveSpacing(
                                              context,
                                              normal: 20,
                                              small: 16,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              _buildSituationButton(
                                                EatingSituation.alone,
                                                '🍽️',
                                                [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
                                                isDark,
                                              ),
                                              SizedBox(
                                                height: ResponsiveHelper.getResponsiveSpacing(
                                                  context,
                                                  normal: 12,
                                                  small: 8,
                                                ),
                                              ),
                                              _buildSituationButton(
                                                EatingSituation.coworkers,
                                                '👥',
                                                [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
                                                isDark,
                                              ),
                                              SizedBox(
                                                height: ResponsiveHelper.getResponsiveSpacing(
                                                  context,
                                                  normal: 12,
                                                  small: 8,
                                                ),
                                              ),
                                              _buildSituationButton(
                                                EatingSituation.partner,
                                                '❤️',
                                                [Color(0xFFFFE0F0), Color(0xFFFFB3D9)],
                                                isDark,
                                              ),
                                              SizedBox(
                                                height: ResponsiveHelper.getResponsiveSpacing(
                                                  context,
                                                  normal: 12,
                                                  small: 8,
                                                ),
                                              ),
                                              _buildSituationButton(
                                                EatingSituation.family,
                                                '👨‍👩‍👧‍👦',
                                                [Color(0xFFF3E5F5), Color(0xFFE1BEE7)],
                                                isDark,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      _buildSituationButton(
                                        EatingSituation.alone,
                                        '🍽️',
                                        [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
                                        isDark,
                                      ),
                                      SizedBox(
                                        height: ResponsiveHelper.getResponsiveSpacing(
                                          context,
                                          normal: 20,
                                          small: 12,
                                        ),
                                      ),
                                      _buildSituationButton(
                                        EatingSituation.coworkers,
                                        '👥',
                                        [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
                                        isDark,
                                      ),
                                      SizedBox(
                                        height: ResponsiveHelper.getResponsiveSpacing(
                                          context,
                                          normal: 20,
                                          small: 12,
                                        ),
                                      ),
                                      _buildSituationButton(
                                        EatingSituation.partner,
                                        '❤️',
                                        [Color(0xFFFFE0F0), Color(0xFFFFB3D9)],
                                        isDark,
                                      ),
                                      SizedBox(
                                        height: ResponsiveHelper.getResponsiveSpacing(
                                          context,
                                          normal: 20,
                                          small: 12,
                                        ),
                                      ),
                                      _buildSituationButton(
                                        EatingSituation.family,
                                        '👨‍👩‍👧‍👦',
                                        [Color(0xFFF3E5F5), Color(0xFFE1BEE7)],
                                        isDark,
                                      ),
                                    ],
                                  ),
                          ),
                          SizedBox(
                            height: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              normal: 32,
                              small: 16,
                            ),
                          ),
                          // 배너 광고 영역 (다음 버튼 위)
                          const BannerAdWidget(),
                          SizedBox(
                            height: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              normal: 16,
                              small: 12,
                            ),
                          ),
                          // 다음 버튼
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              if (!mounted) {
                                return const SizedBox.shrink();
                              }
                              return Transform.scale(
                                scale: selectedSituation != null ? 1.0 : 0.95,
                                child: Opacity(
                                  opacity: selectedSituation != null ? 1.0 : 0.6,
                                  child: child,
                                ),
                              );
                            },
                            child: SizedBox(
                              height: ResponsiveHelper.getResponsiveButtonHeight(
                                context,
                                normal: 64,
                                small: 56,
                              ),
                              child: ElevatedButton(
                                onPressed: selectedSituation != null
                                    ? () {
                                        if (!mounted) return;
                                        HapticFeedback.mediumImpact();
                                              
                                              // Analytics: 식사 상황 선택 추적
                                              AnalyticsService.logEatingSituationSelected(selectedSituation!);
                                              
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation, secondaryAnimation) =>
                                                DrinkingScreen(
                                              mealTime: widget.mealTime,
                                              situation: selectedSituation!,
                                            ),
                                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: selectedSituation != null ? Colors.orange : Colors.grey.shade300,
                                  foregroundColor: Colors.white,
                                  elevation: selectedSituation != null ? 8 : 0,
                                  shadowColor: Colors.orange.withOpacity(0.4),
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
                                child: Text(
                                  '다음',
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
      ),
    );
  }

  Widget _buildSituationButton(
    EatingSituation situation,
    String emoji,
    List<Color> gradientColors,
    bool isDark,
  ) {
    final isSelected = selectedSituation == situation;
    final isLandscape = ResponsiveHelper.isLandscape(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
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
                      gradientColors[0].withOpacity(0.4),
                      gradientColors[1].withOpacity(0.4),
                    ]
                  : gradientColors)
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
      child: InteractiveButton(
        onPressed: () {
          if (!mounted) return;
          setState(() {
            selectedSituation = situation;
          });
          
          // Analytics: 식사 상황 선택 추적 (버튼 클릭 시)
          AnalyticsService.logEatingSituationSelected(situation);
          
          if (_animationController.isAnimating) {
            _animationController.stop();
          }
          _animationController.forward().then((_) {
            if (mounted) {
              _animationController.reverse();
            }
          });
        },
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
                    emoji,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        normal: 32,
                        small: 28,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: ResponsiveHelper.getResponsiveSpacing(
                      context,
                      normal: 16,
                      small: 12,
                    ),
                  ),
                  Text(
                    situation.label,
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
