import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../utils/logger.dart';

/// FCM 백그라운드 메시지 핸들러 (최상위 함수여야 함)
/// 앱이 백그라운드나 완전히 종료된 상태에서 메시지 수신 시 호출됨
/// 
/// 중요: 백그라운드/종료 상태에서는 FCM이 자동으로 시스템 알림을 표시합니다.
/// 이 핸들러는 메시지 수신을 로깅하고 추가 처리가 필요한 경우에만 사용합니다.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  
  AppLogger.debug('========== 🔔 백그라운드/종료 상태 메시지 수신 🔔 ==========');
  AppLogger.debug('✅ 메시지가 도착했습니다!');
  AppLogger.debug('메시지 ID: ${message.messageId}');
  AppLogger.debug('제목: ${message.notification?.title ?? "제목 없음"}');
  AppLogger.debug('내용: ${message.notification?.body ?? "내용 없음"}');
  AppLogger.debug('데이터: ${message.data}');
  AppLogger.debug('알림 정보 존재 여부: ${message.notification != null}');
  
  if (message.notification == null) {
    AppLogger.debug('⚠️ 경고: notification 필드가 없습니다. Firebase Console에서');
    AppLogger.debug('   "알림" 섹션을 채워서 메시지를 보내야 합니다.');
  } else {
    AppLogger.debug('✅ 알림 정보가 정상적으로 있습니다. FCM이 자동으로 알림을 표시합니다.');
  }
  
  AppLogger.debug('=======================================================');
  
  // 백그라운드/종료 상태에서는 FCM이 자동으로 시스템 알림을 표시하므로
  // 추가 처리 없이 로그만 남깁니다.
  // 필요시 여기에 추가 로직을 구현할 수 있습니다.
}

