import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/supabase_config.dart';
import 'providers/theme_provider.dart';
import 'screens/main_screen.dart';
import 'services/notification_service.dart';
import 'services/fcm_background_handler.dart';
import 'utils/logger.dart';

void main() async {
  // 앱 시작 시간 기록
  final appStartTime = DateTime.now();
  
  // runZonedGuarded로 모든 비동기 오류를 추적
  await runZonedGuarded(
    () async {
      AppLogger.debug('🚀 앱 시작: WidgetsFlutterBinding 초기화...');
      final bindingStartTime = DateTime.now();
      WidgetsFlutterBinding.ensureInitialized();
      final bindingElapsed = DateTime.now().difference(bindingStartTime).inMilliseconds;
      AppLogger.debug('✅ WidgetsFlutterBinding 초기화 완료 (${bindingElapsed}ms)');
      
      // Firebase 초기화 (Crashlytics 사용을 위해 먼저 초기화)
      try {
        AppLogger.debug('🔥 Firebase 초기화 시작...');
        final firebaseStartTime = DateTime.now();
        await Firebase.initializeApp();
        final firebaseElapsed = DateTime.now().difference(firebaseStartTime).inMilliseconds;
        AppLogger.debug('✅ Firebase 초기화 완료 (${firebaseElapsed}ms)');
        
        // Firebase Crashlytics 초기화
        FlutterError.onError = (errorDetails) {
          // Crashlytics에 Flutter 프레임워크 오류 보고
          FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
          // 기본 에러 처리 유지
          FlutterError.presentError(errorDetails);
          AppLogger.error('Flutter Error', errorDetails.exception, errorDetails.stack);
        };
        
        // 플랫폼 레벨 오류 처리 (비동기 오류 등)
        PlatformDispatcher.instance.onError = (error, stack) {
          // Crashlytics에 플랫폼 레벨 오류 보고
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
          AppLogger.error('Platform Error', error, stack);
          return true;
        };
        
        // Firebase Analytics 초기화
        AppLogger.debug('📊 Firebase Analytics 초기화 시작...');
        final analyticsStartTime = DateTime.now();
        final analytics = FirebaseAnalytics.instance;
        await analytics.setAnalyticsCollectionEnabled(true);
        final analyticsElapsed = DateTime.now().difference(analyticsStartTime).inMilliseconds;
        AppLogger.debug('✅ Firebase Analytics 초기화 완료 (${analyticsElapsed}ms)');
        
        // FCM 백그라운드 메시지 핸들러 등록 (앱 초기화 전에 등록해야 함)
        FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      } catch (e) {
        AppLogger.error('Firebase 초기화 실패', e);
        // 앱은 계속 실행되지만 Firebase 기능은 사용 불가
        // Crashlytics 초기화 실패 시 기본 에러 핸들러만 사용
        FlutterError.onError = (errorDetails) {
          FlutterError.presentError(errorDetails);
          AppLogger.error('Flutter Error', errorDetails.exception, errorDetails.stack);
  };
        PlatformDispatcher.instance.onError = (error, stack) {
          AppLogger.error('Platform Error', error, stack);
          return true;
        };
      }
  
      // Supabase 초기화 (MCP를 통해 가져온 값 사용) - 필수이므로 먼저 초기화
      try {
        AppLogger.debug('🗄️ Supabase 초기화 시작...');
        final supabaseStartTime = DateTime.now();
        await Supabase.initialize(
          url: SupabaseConfig.supabaseUrl,
          anonKey: SupabaseConfig.supabaseAnonKey,
        );
        final supabaseElapsed = DateTime.now().difference(supabaseStartTime).inMilliseconds;
        AppLogger.debug('✅ Supabase 초기화 완료 (${supabaseElapsed}ms)');
      } catch (e) {
        AppLogger.error('❌ Supabase 초기화 실패', e);
        // 앱은 계속 실행되지만 Supabase 기능은 사용 불가
      }
  
      AppLogger.debug('🎨 SystemUI 스타일 설정...');
      final systemUIStartTime = DateTime.now();
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
        ),
      );
      final systemUIElapsed = DateTime.now().difference(systemUIStartTime).inMilliseconds;
      AppLogger.debug('✅ SystemUI 스타일 설정 완료 (${systemUIElapsed}ms)');
  
      AppLogger.debug('🏃 MyApp 실행 시작...');
      final runAppStartTime = DateTime.now();
      // 앱을 먼저 실행 (UI 표시)
      runApp(const MyApp());
      final runAppElapsed = DateTime.now().difference(runAppStartTime).inMilliseconds;
      final totalElapsed = DateTime.now().difference(appStartTime).inMilliseconds;
      AppLogger.debug('✅ MyApp 실행 완료 (${runAppElapsed}ms)');
      AppLogger.debug('⏱️ 총 초기화 시간: ${totalElapsed}ms (약 ${(totalElapsed / 1000).toStringAsFixed(2)}초)');
      
      // Google Mobile Ads 초기화는 백그라운드에서 비동기로 처리 (앱 실행을 블로킹하지 않음)
      AppLogger.debug('📱 Google Mobile Ads 백그라운드 초기화 시작...');
      final adsStartTime = DateTime.now();
      MobileAds.instance.initialize().then((_) {
        final adsElapsed = DateTime.now().difference(adsStartTime).inMilliseconds;
        AppLogger.debug('✅ Google Mobile Ads 초기화 완료 (${adsElapsed}ms, 비동기)');
      }).catchError((e) {
        AppLogger.error('❌ Google Mobile Ads 초기화 실패', e);
        // 앱은 계속 실행되지만 광고 기능은 사용 불가
      });
      
      // 알림 서비스 초기화는 백그라운드에서 비동기로 처리 (앱 실행을 블로킹하지 않음)
      AppLogger.debug('🔔 알림 서비스 백그라운드 초기화 시작...');
      final notificationStartTime = DateTime.now();
      NotificationService.initialize().then((_) {
        final notificationElapsed = DateTime.now().difference(notificationStartTime).inMilliseconds;
        AppLogger.debug('✅ 알림 서비스 초기화 완료 (${notificationElapsed}ms, 비동기)');
      }).catchError((e) {
        AppLogger.error('❌ 알림 서비스 초기화 실패', e);
      });
    },
    // runZonedGuarded의 에러 핸들러: 모든 비동기 오류를 Crashlytics에 보고
    (error, stack) {
      AppLogger.error('Unhandled Exception', error, stack);
      // Crashlytics가 초기화되었는지 확인 후 보고
      if (Firebase.apps.isNotEmpty) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      }
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Selector<ThemeProvider, bool>(
        selector: (_, provider) => provider.isLoading,
        builder: (context, isLoading, _) {
          
          if (isLoading) {
            return MaterialApp(
              title: '이따가 뭐 먹지',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFFFF6B35),
                  brightness: Brightness.light,
                ),
                useMaterial3: true,
              ),
              home: const Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFFF6B35),
                  ),
                ),
              ),
            );
          }

          return Selector<ThemeProvider, ThemeMode>(
            selector: (_, provider) => provider.themeMode,
            builder: (context, themeMode, _) {
              return MaterialApp(
                title: '이따가 뭐 먹지',
                debugShowCheckedModeBanner: false,
                // 한국어 로케일 설정
                locale: const Locale('ko', 'KR'),
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('ko', 'KR'), // 한국어
                  Locale('en', 'US'), // 영어 (폴백)
                ],
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: const Color(0xFFFF6B35),
                    brightness: Brightness.light,
                  ),
                  useMaterial3: true,
                ),
                darkTheme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: const Color(0xFFFF6B35),
                    brightness: Brightness.dark,
                  ),
                  useMaterial3: true,
                ),
                themeMode: themeMode,
                builder: (context, child) {
                  // 화면 회전 처리
                  return OrientationBuilder(
                    builder: (context, orientation) {
                      return child ?? const SizedBox.shrink();
                    },
                  );
                },
                home: const MainScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
