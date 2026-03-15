import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:firebase_messaging/firebase_messaging.dart';
import '../services/settings_service.dart';
import '../utils/logger.dart';

/// 푸시 알림 관리 서비스
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = 
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// 알림 서비스 초기화
  static Future<void> initialize() async {
    try {
      AppLogger.debug('알림 서비스 초기화 시작...');
      
      // 타임존 초기화 (빠른 작업)
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

      // Android 초기화 설정
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      
      // iOS 초기화 설정
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      // 로컬 알림 플러그인 초기화 (필수 작업)
      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTap,
      );
      AppLogger.debug('로컬 알림 플러그인 초기화 완료');

      // Android 알림 채널 생성 (필수 작업)
      await _createNotificationChannel();
      
      // Firebase Messaging 초기화는 비동기로 처리 (앱 실행을 블로킹하지 않음)
      _initializeFirebaseMessaging().catchError((e) {
        AppLogger.debug('Firebase Messaging 초기화 실패: $e');
      });
      
      // 기존 알림 모두 취소 후 새로 스케줄링도 비동기로 처리
      scheduleAllMealNotifications().catchError((e) {
        AppLogger.debug('식사 알림 스케줄링 실패: $e');
      });
      
      AppLogger.debug('알림 서비스 초기화 완료 (비동기 작업 진행 중)');
    } catch (e, stackTrace) {
      AppLogger.error('알림 서비스 초기화 중 오류: $e', e, stackTrace);
      rethrow;
    }
  }
  
  /// Firebase Messaging 초기화
  static Future<void> _initializeFirebaseMessaging() async {
    try {
      AppLogger.debug('========== Firebase Messaging 초기화 시작 ==========');
      
      // iOS 알림 권한 요청
      final NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      AppLogger.debug('FCM 권한 상태: ${settings.authorizationStatus}');
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        AppLogger.debug('✅ FCM 권한이 승인되었습니다.');
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        AppLogger.debug('⚠️ FCM 임시 권한이 승인되었습니다.');
      } else {
        AppLogger.debug('❌ FCM 권한이 거부되었습니다: ${settings.authorizationStatus}');
      }

      // FCM 토큰 가져오기
      final token = await _getFCMToken();
      if (token == null) {
        AppLogger.debug('❌ FCM 토큰을 가져올 수 없습니다.');
      }

      // 토큰 갱신 리스너 설정
      _messaging.onTokenRefresh.listen((newToken) {
        AppLogger.debug('🔄 FCM 토큰이 갱신되었습니다: $newToken');
        _saveTokenToServer(newToken);
      });

      // 포그라운드 메시지 리스너 설정
      FirebaseMessaging.onMessage.listen((message) {
        AppLogger.debug('📨📨📨 onMessage 리스너 호출됨 📨📨📨');
        AppLogger.debug('✅ 메시지가 실제로 도착했습니다!');
        AppLogger.debug('메시지 수신 시간: ${DateTime.now()}');
        
        // 비동기 처리하되 에러가 발생해도 다음 메시지를 받을 수 있도록
        _handleForegroundMessage(message).catchError((error, stackTrace) {
          AppLogger.error('❌ 포그라운드 메시지 처리 실패: $error', error, stackTrace);
        });
      });

      // 앱이 백그라운드에서 열렸을 때 메시지 처리
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        AppLogger.debug('📬 onMessageOpenedApp 리스너 호출됨');
        _handleBackgroundMessageOpened(message);
      });

      // 앱이 종료된 상태에서 알림 탭으로 열렸는지 확인
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        AppLogger.debug('📭 앱이 종료된 상태에서 알림 탭으로 열림');
        _handleBackgroundMessageOpened(initialMessage);
      }

      AppLogger.debug('✅ Firebase Messaging 초기화 완료');
      AppLogger.debug('===========================================');
    } catch (e, stackTrace) {
      AppLogger.error('❌ Firebase Messaging 초기화 실패: $e', e, stackTrace);
    }
  }
  
  /// FCM 토큰 가져오기
  static Future<String?> _getFCMToken() async {
    try {
      final String? token = await _messaging.getToken();
      if (token != null) {
        AppLogger.debug('========== FCM 토큰 ==========');
        AppLogger.debug(token);
        AppLogger.debug('=============================');
        // 서버에 토큰 저장
        await _saveTokenToServer(token);
        return token;
      }
      return null;
    } catch (e) {
      AppLogger.debug('FCM 토큰 가져오기 실패: $e');
      return null;
    }
  }
  
  /// FCM 토큰을 서버에 저장 (Supabase 예시)
  static Future<void> _saveTokenToServer(String token) async {
    try {
      // TODO: Supabase나 다른 서버에 토큰 저장
      // 예시:
      // final supabase = Supabase.instance.client;
      // final userId = supabase.auth.currentUser?.id;
      // if (userId != null) {
      //   await supabase.from('user_fcm_tokens').upsert({
      //     'user_id': userId,
      //     'fcm_token': token,
      //     'updated_at': DateTime.now().toIso8601String(),
      //   });
      // }
      AppLogger.debug('FCM 토큰을 서버에 저장했습니다 (구현 필요)');
    } catch (e) {
      AppLogger.debug('FCM 토큰 저장 실패: $e');
    }
  }
  
  /// 현재 FCM 토큰 가져오기 (외부에서 사용 가능)
  static Future<String?> getFCMToken() async {
    return await _getFCMToken();
  }
  
  /// 포그라운드 메시지 처리 (앱이 열려있을 때)
  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    try {
      AppLogger.debug('========== 포그라운드 메시지 수신 ==========');
      AppLogger.debug('메시지 ID: ${message.messageId}');
      AppLogger.debug('제목: ${message.notification?.title ?? "제목 없음"}');
      AppLogger.debug('내용: ${message.notification?.body ?? "내용 없음"}');
      AppLogger.debug('데이터: ${message.data}');
      AppLogger.debug('알림이 null인가? ${message.notification == null}');
      AppLogger.debug('===========================================');

      // 로컬 알림으로 표시 (앱이 열려있을 때는 자동으로 표시되지 않음)
      if (message.notification != null) {
        AppLogger.debug('✅ 알림 정보가 있으므로 로컬 알림으로 표시합니다.');
        await _showLocalNotificationFromFCM(message);
      } else {
        AppLogger.debug('⚠️ 경고: 알림 정보(notification)가 없습니다. 데이터만 있는 메시지입니다.');
        AppLogger.debug('   Firebase Console에서 "알림" 섹션을 채워서 보내야 합니다.');
        
        // 데이터만 있는 경우에도 알림 표시 시도
        if (message.data.isNotEmpty) {
          AppLogger.debug('데이터 기반 알림으로 표시 시도...');
          await _showDataNotification(message);
        }
      }
    } catch (e, stackTrace) {
      AppLogger.error('❌ 포그라운드 메시지 처리 중 오류 발생: $e', e, stackTrace);
      
      // 오류 발생 시에도 최소한의 알림은 표시 시도
      try {
        await _showLocalNotificationFromFCM(message);
      } catch (e2) {
        AppLogger.debug('❌ 오류 복구 시도도 실패: $e2');
      }
    }
  }
  
  /// 데이터만 있는 메시지를 알림으로 표시
  static Future<void> _showDataNotification(RemoteMessage message) async {
    try {
      final title = message.data['title'] ?? message.data['notification_title'] ?? '공지';
      final body = message.data['body'] ?? message.data['notification_body'] ?? message.data['message'] ?? '새로운 알림이 있습니다.';
      
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'announcements',
        '공지 알림',
        channelDescription: '공지 및 이벤트 알림',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        icon: '@mipmap/ic_launcher',
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        message.hashCode.abs(),
        title,
        body,
        notificationDetails,
        payload: message.data.toString(),
      );
      
      AppLogger.debug('✅ 데이터 기반 알림 표시 완료');
    } catch (e) {
      AppLogger.debug('❌ 데이터 기반 알림 표시 실패: $e');
    }
  }
  
  /// 백그라운드에서 알림 탭으로 앱 열림 처리
  static void _handleBackgroundMessageOpened(RemoteMessage message) {
    AppLogger.debug('백그라운드 메시지 탭으로 앱 열림: ${message.messageId}');
    AppLogger.debug('제목: ${message.notification?.title}');
    AppLogger.debug('내용: ${message.notification?.body}');
    AppLogger.debug('데이터: ${message.data}');
    
    // TODO: 특정 화면으로 이동하거나 액션 수행
    // 예: Navigator.pushNamed(context, '/announcement', arguments: message.data);
  }
  
  /// FCM 메시지를 로컬 알림으로 표시
  static Future<void> _showLocalNotificationFromFCM(RemoteMessage message) async {
    try {
      AppLogger.debug('📱 로컬 알림 표시 시작...');
      
      // notification 객체에서 정보 가져오기
      final title = message.notification?.title ?? 
                   message.data['title'] ?? 
                   message.data['notification_title'] ?? 
                   '공지';
      final body = message.notification?.body ?? 
                  message.data['body'] ?? 
                  message.data['notification_body'] ?? 
                  message.data['message'] ?? 
                  '새로운 알림이 있습니다.';
      
      AppLogger.debug('📌 알림 제목: "$title"');
      AppLogger.debug('📌 알림 내용: "$body"');
      
      // 알림 채널이 존재하는지 확인 (Android)
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'announcements',
        '공지 알림',
        channelDescription: '공지 및 이벤트 알림',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        icon: '@mipmap/ic_launcher',
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // 메시지 ID를 사용하되, 없으면 해시코드 사용
      final notificationId = message.messageId != null 
                            ? message.messageId.hashCode.abs()
                            : message.hashCode.abs();
      AppLogger.debug('🆔 알림 ID: $notificationId');
      
      // 알림 표시 전에 약간의 지연 (초기화 완료 보장)
      await Future.delayed(const Duration(milliseconds: 100));
      
      await _notifications.show(
        notificationId,
        title,
        body,
        notificationDetails,
        payload: message.data.toString(),
      );
      
      AppLogger.debug('✅✅✅ 로컬 알림 표시 완료! ✅✅✅');
      AppLogger.debug('사용자에게 알림이 표시되어야 합니다.');
    } catch (e, stackTrace) {
      AppLogger.error('❌❌❌ 로컬 알림 표시 실패 ❌❌❌', e, stackTrace);
      
      // 재시도 로직
      try {
        AppLogger.debug('🔄 재시도 중...');
        await Future.delayed(const Duration(milliseconds: 500));
        
        await _notifications.show(
          message.hashCode.abs(),
          message.notification?.title ?? '공지',
          message.notification?.body ?? '새로운 알림',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'announcements',
              '공지 알림',
              importance: Importance.high,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(),
          ),
        );
        
        AppLogger.debug('✅ 재시도 성공!');
      } catch (e2) {
        AppLogger.debug('❌ 재시도도 실패: $e2');
      }
    }
  }

  /// 알림 채널 생성 (Android)
  static Future<void> _createNotificationChannel() async {
    // 식사 알림 채널
    const mealChannel = AndroidNotificationChannel(
      'meal_reminders',
      '식사 알림',
      description: '식사 시간 1시간 전 알림을 받습니다.',
      importance: Importance.high,
      playSound: true,
    );

    // 공지 알림 채널
    const announcementChannel = AndroidNotificationChannel(
      'announcements',
      '공지 알림',
      description: '공지 및 이벤트 알림을 받습니다.',
      importance: Importance.high,
      playSound: true,
    );

    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(mealChannel);
    await androidPlugin?.createNotificationChannel(announcementChannel);
    
    AppLogger.debug('✅ 알림 채널 생성 완료: meal_reminders, announcements');
  }
  
  /// 테스트 알림 발송 (디버깅용)
  static Future<void> sendTestNotification() async {
    try {
      AppLogger.debug('테스트 알림 발송 시작...');
      
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'announcements',
        '공지 알림',
        channelDescription: '공지 및 이벤트 알림',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        icon: '@mipmap/ic_launcher',
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        9999, // 테스트 알림 ID
        '테스트 알림',
        '이것은 테스트 알림입니다. 알림이 보인다면 정상 작동 중입니다! 🎉',
        notificationDetails,
      );
      
      AppLogger.debug('✅ 테스트 알림 발송 완료!');
    } catch (e) {
      AppLogger.debug('❌ 테스트 알림 발송 실패: $e');
    }
  }

  /// 알림 탭 처리
  static void _onNotificationTap(NotificationResponse response) {
    // 알림 탭 시 동작 (앱 열기 등)
    AppLogger.debug('알림 탭됨: ${response.payload}');
  }

  /// 모든 식사 알림 스케줄링
  static Future<void> scheduleAllMealNotifications() async {
    // 기존 알림 모두 취소
    await cancelAllNotifications();

    // 저장된 식사 시간 가져오기
    final mealTimes = await SettingsService.getAllMealTimes();
    // 저장된 알림 활성화 상태 가져오기
    final notificationEnabled = await SettingsService.getAllNotificationEnabled();

    // 아침 알림 스케줄링 (활성화된 경우만)
    if (mealTimes['breakfast'] != null && notificationEnabled['breakfast'] == true) {
      await scheduleMealNotification(
        mealType: '아침',
        mealTime: mealTimes['breakfast']!,
        notificationId: 1,
      );
    } else if (notificationEnabled['breakfast'] == false) {
      // 비활성화된 경우 해당 알림 취소
      await cancelNotification(1);
    }

    // 점심 알림 스케줄링 (활성화된 경우만)
    if (mealTimes['lunch'] != null && notificationEnabled['lunch'] == true) {
      await scheduleMealNotification(
        mealType: '점심',
        mealTime: mealTimes['lunch']!,
        notificationId: 2,
      );
    } else if (notificationEnabled['lunch'] == false) {
      // 비활성화된 경우 해당 알림 취소
      await cancelNotification(2);
    }

    // 저녁 알림 스케줄링 (활성화된 경우만)
    if (mealTimes['dinner'] != null && notificationEnabled['dinner'] == true) {
      await scheduleMealNotification(
        mealType: '저녁',
        mealTime: mealTimes['dinner']!,
        notificationId: 3,
      );
    } else if (notificationEnabled['dinner'] == false) {
      // 비활성화된 경우 해당 알림 취소
      await cancelNotification(3);
    }
  }

  /// 개별 식사 알림 스케줄링
  static Future<void> scheduleMealNotification({
    required String mealType,
    required String mealTime, // 'HH:mm' 형식
    required int notificationId,
  }) async {
    try {
      final timeParts = mealTime.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      // 1시간 전 시간 계산
      var notificationHour = hour - 1;
      var notificationMinute = minute;

      // 시간이 음수가 되면 전날로 처리
      if (notificationHour < 0) {
        notificationHour = 23;
      }

      // Android 알림 상세 설정
      const androidDetails = AndroidNotificationDetails(
        'meal_reminders',
        '식사 알림',
        channelDescription: '식사 시간 1시간 전 알림',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
      );

      // iOS 알림 상세 설정
      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // 매일 반복 알림 스케줄링
      await _notifications.zonedSchedule(
        notificationId,
        '식사 시간 알림',
        '$mealType 시간이 1시간 후입니다!\n뭐 먹을지 고민해볼 시간이에요 😊',
        _nextInstanceOfTime(notificationHour, notificationMinute),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      AppLogger.debug('✅ $mealType 알림 스케줄링 완료: ${_nextInstanceOfTime(notificationHour, notificationMinute).toString()}');
    } catch (e) {
      AppLogger.debug('❌ 알림 스케줄링 실패: $e');
    }
  }

  /// 다음 알림 시간 계산 (매일 반복)
  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // 이미 지난 시간이면 내일로 설정
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  /// 모든 알림 취소
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// 특정 알림 취소
  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }
  
  /// 식사 시간 알림 테스트 (즉시 발송)
  static Future<void> sendMealNotificationTest(String mealType) async {
    try {
      AppLogger.debug('$mealType 알림 테스트 시작...');
      
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'meal_reminders',
        '식사 알림',
        channelDescription: '식사 시간 1시간 전 알림',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // 즉시 알림 발송 (테스트용)
      await _notifications.show(
        mealType == '아침' ? 1001 : mealType == '점심' ? 1002 : 1003, // 테스트용 ID
        '식사 시간 알림',
        '$mealType 시간이 1시간 후입니다!\n뭐 먹을지 고민해볼 시간이에요 😊',
        notificationDetails,
      );
      
      AppLogger.debug('✅ $mealType 테스트 알림 발송 완료!');
    } catch (e) {
      AppLogger.debug('❌ $mealType 테스트 알림 발송 실패: $e');
      rethrow;
    }
  }
}


