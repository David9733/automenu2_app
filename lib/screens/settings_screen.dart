import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../services/settings_service.dart';
import '../services/notification_service.dart';
import '../services/analytics_service.dart';
import '../utils/responsive_helper.dart';

/// 설정 화면
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String breakfastTime = '08:00';
  String lunchTime = '12:00';
  String dinnerTime = '18:00';
  bool breakfastNotificationEnabled = true;
  bool lunchNotificationEnabled = true;
  bool dinnerNotificationEnabled = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  /// 저장된 설정 불러오기
  Future<void> _loadSettings() async {
    setState(() {
      isLoading = true;
    });

    final breakfast = await SettingsService.getBreakfastTime();
    final lunch = await SettingsService.getLunchTime();
    final dinner = await SettingsService.getDinnerTime();
    final breakfastNotification = await SettingsService.getBreakfastNotificationEnabled();
    final lunchNotification = await SettingsService.getLunchNotificationEnabled();
    final dinnerNotification = await SettingsService.getDinnerNotificationEnabled();

    setState(() {
      breakfastTime = breakfast;
      lunchTime = lunch;
      dinnerTime = dinner;
      breakfastNotificationEnabled = breakfastNotification;
      lunchNotificationEnabled = lunchNotification;
      dinnerNotificationEnabled = dinnerNotification;
      isLoading = false;
    });
  }

  /// 시간 선택 다이얼로그
  Future<void> _selectTime({
    required String currentTime,
    required String mealType,
    required Function(String) onTimeSelected,
  }) async {
    final timeParts = currentTime.split(':');
    final initialTime = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.orange,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime != null) {
      final formattedTime =
          '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
      onTimeSelected(formattedTime);
      HapticFeedback.selectionClick();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 왼쪽: 다크/라이트 모드 토글
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
                    // 가운데: 제목
                    Text(
                      '설정',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          normal: 20,
                          small: 18,
                        ),
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                      ),
                    ),
                    // 오른쪽: 공간 맞춤용
                    SizedBox(
                      width: 48, // IconButton 너비와 동일하게
                    ),
                  ],
                ),
              ),
              // 본문 내용
              Expanded(
                child: isLoading
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(
                              color: Colors.orange,
                              strokeWidth: 3.0,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              '데이터를 불러오는 중...',
                              style: TextStyle(
                                fontSize: 16,
                                color: isDark ? Colors.white70 : Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Scrollbar(
                  thumbVisibility: true,
                  thickness: 6.0,
                  radius: const Radius.circular(3),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
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
                      ) + 70, // 광고 영역(50px) + 여유 공간(20px)
                    ),
                    children: [
                    // 식사 시간 설정 섹션
                    Text(
                      '식사 시간 설정',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '설정한 시간 1시간 전에 알림을 받을 수 있습니다.',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // 아침 시간
                    _buildTimeSettingCard(
                      context: context,
                      emoji: '🌅',
                      label: '아침',
                      time: breakfastTime,
                      isDark: isDark,
                      notificationEnabled: breakfastNotificationEnabled,
                      onTap: () async {
                        await _selectTime(
                          currentTime: breakfastTime,
                          mealType: 'breakfast',
                          onTimeSelected: (time) async {
                            final oldTime = breakfastTime;
                            setState(() {
                              breakfastTime = time;
                            });
                            await SettingsService.saveBreakfastTime(time);
                            
                            // Analytics: 식사 시간 설정 변경 추적
                            AnalyticsService.logMealTimeSettingChanged(
                              mealType: 'breakfast',
                              newTime: time,
                              oldTime: oldTime,
                            );
                            
                            // 알림 스케줄 업데이트
                            await NotificationService.scheduleAllMealNotifications();
                            HapticFeedback.mediumImpact();
                          },
                        );
                      },
                      onNotificationToggle: (enabled) async {
                        setState(() {
                          breakfastNotificationEnabled = enabled;
                        });
                        await SettingsService.saveBreakfastNotificationEnabled(enabled);
                        
                        // Analytics: 알림 설정 변경 추적
                        AnalyticsService.logNotificationSettingChanged(
                          mealType: 'breakfast',
                          enabled: enabled,
                          mealTime: breakfastTime,
                        );
                        
                        // 알림 스케줄 업데이트
                        await NotificationService.scheduleAllMealNotifications();
                        HapticFeedback.mediumImpact();
                      },
                    ),
                    const SizedBox(height: 16),
                    // 점심 시간
                    _buildTimeSettingCard(
                      context: context,
                      emoji: '☀️',
                      label: '점심',
                      time: lunchTime,
                      isDark: isDark,
                      notificationEnabled: lunchNotificationEnabled,
                      onTap: () async {
                        await _selectTime(
                          currentTime: lunchTime,
                          mealType: 'lunch',
                          onTimeSelected: (time) async {
                            final oldTime = lunchTime;
                            setState(() {
                              lunchTime = time;
                            });
                            await SettingsService.saveLunchTime(time);
                            
                            // Analytics: 식사 시간 설정 변경 추적
                            AnalyticsService.logMealTimeSettingChanged(
                              mealType: 'lunch',
                              newTime: time,
                              oldTime: oldTime,
                            );
                            
                            // 알림 스케줄 업데이트
                            await NotificationService.scheduleAllMealNotifications();
                            HapticFeedback.mediumImpact();
                          },
                        );
                      },
                      onNotificationToggle: (enabled) async {
                        setState(() {
                          lunchNotificationEnabled = enabled;
                        });
                        await SettingsService.saveLunchNotificationEnabled(enabled);
                        
                        // Analytics: 알림 설정 변경 추적
                        AnalyticsService.logNotificationSettingChanged(
                          mealType: 'lunch',
                          enabled: enabled,
                          mealTime: lunchTime,
                        );
                        
                        // 알림 스케줄 업데이트
                        await NotificationService.scheduleAllMealNotifications();
                        HapticFeedback.mediumImpact();
                      },
                    ),
                    const SizedBox(height: 16),
                    // 저녁 시간
                    _buildTimeSettingCard(
                      context: context,
                      emoji: '🌙',
                      label: '저녁',
                      time: dinnerTime,
                      isDark: isDark,
                      notificationEnabled: dinnerNotificationEnabled,
                      onTap: () async {
                        await _selectTime(
                          currentTime: dinnerTime,
                          mealType: 'dinner',
                          onTimeSelected: (time) async {
                            final oldTime = dinnerTime;
                            setState(() {
                              dinnerTime = time;
                            });
                            await SettingsService.saveDinnerTime(time);
                            
                            // Analytics: 식사 시간 설정 변경 추적
                            AnalyticsService.logMealTimeSettingChanged(
                              mealType: 'dinner',
                              newTime: time,
                              oldTime: oldTime,
                            );
                            
                            // 알림 스케줄 업데이트
                            await NotificationService.scheduleAllMealNotifications();
                            HapticFeedback.mediumImpact();
                          },
                        );
                      },
                      onNotificationToggle: (enabled) async {
                        setState(() {
                          dinnerNotificationEnabled = enabled;
                        });
                        await SettingsService.saveDinnerNotificationEnabled(enabled);
                        
                        // Analytics: 알림 설정 변경 추적
                        AnalyticsService.logNotificationSettingChanged(
                          mealType: 'dinner',
                          enabled: enabled,
                          mealTime: dinnerTime,
                        );
                        
                        // 알림 스케줄 업데이트
                        await NotificationService.scheduleAllMealNotifications();
                        HapticFeedback.mediumImpact();
                      },
                    ),
                  ],
                ),
              ),
            ),
            ],
          ),
        ),
    );
  }

  Widget _buildTimeSettingCard({
    required BuildContext context,
    required String emoji,
    required String label,
    required String time,
    required bool isDark,
    required bool notificationEnabled,
    required VoidCallback onTap,
    required Function(bool) onNotificationToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            // 시간 설정 부분 (탭 가능)
            InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            onTap();
          },
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.grey.shade300 : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                      Icons.access_time,
                      size: 20,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ],
            ),
          ),
            ),
            // 구분선
            Divider(
              height: 1,
              thickness: 1,
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
            ),
            // 알림 스위치 부분
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Row(
                children: [
                  Icon(
                    Icons.notifications_outlined,
                    size: 20,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '알림 받기',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                      ),
                    ),
                  ),
                  Switch(
                    value: notificationEnabled,
                    onChanged: (value) {
                      onNotificationToggle(value);
                    },
                    activeColor: Colors.orange,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

