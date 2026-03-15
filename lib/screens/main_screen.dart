import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'meal_time_screen.dart';
import 'settings_screen.dart';
import '../widgets/banner_ad_widget.dart';

/// 탭 바를 포함한 메인 화면
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final scaffold = Scaffold(
      body: Column(
        children: [
          // 메인 콘텐츠 영역 (광고 공간 확보)
          // IndexedStack 대신 조건부 렌더링 사용 (현재 화면만 build)
          Expanded(
            child: _currentIndex == 0 
              ? const MealTimeScreen()
              : const SettingsScreen(),
          ),
          // 배너 광고 영역 (하단 고정)
          const BannerAdWidget(),
          // 하단 네비게이션 바
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                HapticFeedback.selectionClick();
                setState(() {
                  _currentIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
              selectedItemColor: Colors.orange,
              unselectedItemColor: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              selectedFontSize: 14,
              unselectedFontSize: 12,
              elevation: 8,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.restaurant_menu),
                  activeIcon: Icon(Icons.restaurant_menu),
                  label: '추천받기',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  activeIcon: Icon(Icons.settings),
                  label: '설정',
                ),
              ],
            ),
          ),
        ],
      ),
    );
    
    return scaffold;
  }
}
