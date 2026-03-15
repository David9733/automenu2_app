import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/meal_time.dart';
import '../models/eating_situation.dart';
import '../models/drinking_status.dart';
import '../providers/theme_provider.dart';
import '../utils/responsive_helper.dart';
import '../widgets/interactive_button.dart';
import '../widgets/banner_ad_widget.dart';
import '../services/analytics_service.dart';
import 'category_screen.dart';

/// 음주 여부 선택 화면
class DrinkingScreen extends StatefulWidget {
  final MealTime mealTime;
  final EatingSituation situation;

  const DrinkingScreen({
    super.key,
    required this.mealTime,
    required this.situation,
  });

  @override
  State<DrinkingScreen> createState() => _DrinkingScreenState();

  // 성능 최적화: 그라데이션 색상 상수화
  static const _darkGradientColors = [
    Color(0xFF1A1A1A),
    Color(0xFF2D2D2D),
  ];
  static const _lightGradientColors = [
    Colors.white,
    Color(0xFFFFF3E0), // Colors.orange.shade50 대신 직접 색상 사용
  ];
}

class _DrinkingScreenState extends State<DrinkingScreen> {
  DrinkingStatus? selectedDrinkingStatus;
  bool _isThemeChanging = false;

  @override
  Widget build(BuildContext context) {
    // Theme.of(context)를 직접 사용하여 테마 변경 시 자동 반영
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
            onPressed: _isThemeChanging ? null : () {
              HapticFeedback.selectionClick();
              setState(() {
                _isThemeChanging = true;
              });
              context.read<ThemeProvider>().toggleTheme();
              // 테마 변경 후 버튼 활성화 (debounce)
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted) {
                  setState(() {
                    _isThemeChanging = false;
                  });
                }
              });
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
                ? DrinkingScreen._darkGradientColors
                : DrinkingScreen._lightGradientColors,
          ),
        ),
        child: SafeArea(
          child: Builder(
            builder: (context) {
              // MediaQuery.of(context).orientation을 사용하여
              // MaterialApp의 OrientationBuilder와 동기화
              final orientation = MediaQuery.of(context).orientation;
              return RepaintBoundary(
                key: ValueKey('drinking_layout_$orientation'),
                child: _buildContent(context, isDark, orientation),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isDark, Orientation orientation) {
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
          Text(
            '🍺 술을 마실 예정인가요?',
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
                ? _buildLandscapeButtons(context, isDark)
                : _buildPortraitButtons(context, isDark),
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
          _buildNextButton(context),
        ],
      ),
    );
  }

  Widget _buildLandscapeButtons(BuildContext context, bool isDark) {
    // 가로모드에서 스크롤 가능하도록 SingleChildScrollView 사용
    // RepaintBoundary로 감싸서 테마 변경 시 안정성 확보
    return RepaintBoundary(
      child: Scrollbar(
        thumbVisibility: true,
        thickness: 6.0,
        radius: const Radius.circular(3),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDrinkingButton(DrinkingStatus.yes, isDark),
              SizedBox(
                height: ResponsiveHelper.getResponsiveSpacing(
                  context,
                  normal: 20,
                  small: 12,
                ),
              ),
              _buildDrinkingButton(DrinkingStatus.unknown, isDark),
              SizedBox(
                height: ResponsiveHelper.getResponsiveSpacing(
                  context,
                  normal: 20,
                  small: 12,
                ),
              ),
              _buildDrinkingButton(DrinkingStatus.no, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPortraitButtons(BuildContext context, bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildDrinkingButton(DrinkingStatus.yes, isDark),
        SizedBox(
          height: ResponsiveHelper.getResponsiveSpacing(
            context,
            normal: 20,
            small: 12,
          ),
        ),
        _buildDrinkingButton(DrinkingStatus.unknown, isDark),
        SizedBox(
          height: ResponsiveHelper.getResponsiveSpacing(
            context,
            normal: 20,
            small: 12,
          ),
        ),
        _buildDrinkingButton(DrinkingStatus.no, isDark),
      ],
    );
  }

  Widget _buildNextButton(BuildContext context) {
    final isEnabled = selectedDrinkingStatus != null;
    final buttonHeight = ResponsiveHelper.getResponsiveButtonHeight(
      context,
      normal: 64,
      small: 56,
    );

    return SizedBox(
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: isEnabled
            ? () {
                HapticFeedback.mediumImpact();
                
                // Analytics: 술 여부 선택 추적 (다음 버튼 클릭 시)
                AnalyticsService.logDrinkingStatusSelected(selectedDrinkingStatus!);
                
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        CategoryScreen(
                      mealTime: widget.mealTime,
                      situation: widget.situation,
                      drinkingStatus: selectedDrinkingStatus!,
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
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? Colors.orange : Colors.grey.shade300,
          foregroundColor: Colors.white,
          elevation: isEnabled ? 8 : 0,
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
          minimumSize: Size(double.infinity, buttonHeight),
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
    );
  }

  Widget _buildDrinkingButton(DrinkingStatus status, bool isDark) {
    final isSelected = selectedDrinkingStatus == status;
    
    return RepaintBoundary(
      child: _DrinkingButtonWidget(
        status: status,
        isSelected: isSelected,
        isDark: isDark,
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() {
            selectedDrinkingStatus = status;
          });
          
          // Analytics: 술 여부 선택 추적
          AnalyticsService.logDrinkingStatusSelected(status);
        },
      ),
    );
  }
}

// 성능 최적화: 버튼을 별도 위젯으로 분리하여 불필요한 재빌드 방지
class _DrinkingButtonWidget extends StatelessWidget {
  final DrinkingStatus status;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _DrinkingButtonWidget({
    required this.status,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  // 성능 최적화: 색상 상수화
  static const _selectedDarkColors = [
    Color(0x4DFF6B35), // Colors.orange.withOpacity(0.3)
    Color(0x33FF6B35), // Colors.orange.withOpacity(0.2)
  ];
  static const _selectedLightColors = [
    Color(0xFFFFE0B2), // Colors.orange.shade100
    Color(0xFFFFF3E0), // Colors.orange.shade50
  ];
  static const _unselectedDarkColor = Color(0xFF424242); // Colors.grey.shade800
  static const _unselectedLightColor = Color(0xFFF5F5F5); // Colors.grey.shade100

  @override
  Widget build(BuildContext context) {
    final isLandscape = ResponsiveHelper.isLandscape(context);
    final baseEmojiSize = status == DrinkingStatus.unknown ? 48.0 : 32.0;

    return Container(
      height: ResponsiveHelper.getResponsiveButtonHeight(
        context,
        normal: isLandscape ? 68 : 84,
        small: 74,
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
              ? (isDark ? _selectedDarkColors : _selectedLightColors)
              : (isDark
                  ? const [_unselectedDarkColor, _unselectedDarkColor]
                  : const [_unselectedLightColor, _unselectedLightColor]),
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? Colors.orange : Colors.transparent,
          width: 2.5,
        ),
        boxShadow: isSelected
            ? const [
                BoxShadow(
                  color: Color(0x4DFF6B35), // Colors.orange.withOpacity(0.3)
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ]
            : const [
                BoxShadow(
                  color: Color(0x0D000000), // Colors.black.withOpacity(0.05)
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
      ),
      child: InteractiveButton(
        onPressed: onTap,
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
                    status.emoji,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        normal: baseEmojiSize,
                        small: baseEmojiSize * 0.85,
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
                    status.label,
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
                  if (isSelected)
                    Padding(
                      padding: EdgeInsets.only(
                        left: ResponsiveHelper.getResponsiveSpacing(
                          context,
                          normal: 12,
                          small: 8,
                        ),
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.orange,
                        size: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          normal: 24,
                          small: 20,
                        ),
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

