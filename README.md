![Image](https://github.com/user-attachments/assets/baa7b358-8eae-4590-b96b-8c8dc758792b)

# 이따가 뭐 먹지? 앱

식사 시간, 상황, 음주 여부를 선택하면 조건에 맞는 음식을 추천해주는 Flutter 모바일 앱

---

## 📋 프로젝트 개요

| 항목 | 내용 |
|---|---|
|  **개발 기간**  | 2025.01 ~ 2025.02 |
| **프로젝트 유형** | 개인 프로젝트 |
| **핵심 기술** | Flutter, Dart, Supabase, Firebase |
| **앱 다운로드** | [Google Play Store](https://play.google.com/store/apps/details?id=com.automenu2&hl=ko) |

---

## 🎯 프로젝트 목적

"오늘 뭐 먹지? 매일 반복되는 고민을 몇번의 선택으로 끝낸다."

매일 반복되는 메뉴 고민을 없애기 위해 개발한 Flutter 음식 추천하는 앱입니다.<br>
Google Play Store에 출시되어 실제 사용자에게 서비스 중입니다.

| 구분 | 내용 |
|------|------|
| **기존 방식** | 혼자 또는 일행과 고민하며 메뉴를 결정 |
| **본 서비스** | 식사 시간, 상황, 음주 여부, 카테고리 조건을 선택하면 조건에 맞는 음식을 자동으로 추천 |
| **효과** | 반복적인 메뉴 결정 피로를 줄이고, 상황에 맞는 음식을 빠르게 선택 가능 |

---

## 🖥️ AI 활용 개발 방식

이 프로젝트는 **바이브 코딩(Vibe Coding)** 방식으로 개발했습니다.<br>
AI에게 원하는 결과를 설명하고 실행 결과를 보며 진행하는 방식입니다.

**사용 도구:** Cursor, ChatGPT

**개발 흐름:**

1. 구현할 기능의 요구사항과 기술 방향을 먼저 정의
2. ChatGPT와 기능 방향을 논의하며 구체화
3. ChatGPT에게 최종 개발용 프롬프트 생성 요청
4. Cursor에 프롬프트 입력 후 코드 생성
5. 실행하여 기능 동작 여부 확인
6. 오류 발생 시 문제 상황을 설명하고 수정 요청
7. 정상 작동할 때까지 반복 수정
8. 정상 동작 확인 후 성능 최적화 요청
9. 필요 시 코드 구조 개선 요청
10. 최종 동작 확인 후 배포

**개발자 역할**: 기능·기술·성능 요구사항 결정, 비즈니스 로직 설계, AI 결과물 검증 및 동작 판단<br>
**AI 역할**: 코드 작성, 오류 수정, 구조 설계 제안

---

## ✨ 주요 기능

- 아침·점심·저녁 식사 시간 선택 
- 혼자·동료·연인·가족 상황 설정 
- 음주 여부 고려한 맞춤 음식 필터링 
- 한식·일식·양식·중식·분식 음식 종류 직접 선택 
- 선택 조건 기반 음식 1~3개 개인화 추천 카드 스와이프로 제공
- 원하는 시간에 식사 알림 자동 설정 및 발송
- 다크·라이트 모드 전환 

---


## 🏗️ 초기 기획 프롬프트

프롬프트 작성에 특화된 ChatGPT를 활용해 개발용 프롬프트를 구체화했습니다.<br>
이를 통해 생성된 최종 프롬프트를 Cursor에 입력하여 개발을 진행했습니다.
<details>
 <summary>ChatGPT 넣을 프롬프트 예시 전체 내용 보기</summary>

```text

나는 Flutter로 음식 추천 앱을 만들려고 해.
앱 이름은 "이따가 뭐 먹지"야.

아래 내용을 바탕으로 앱의 기획을 구체화해줘:

[앱 개요]
- 사용자가 식사 시간, 상황, 음주 여부, 카테고리를 선택하면 어울리는 음식을 추천해주는 앱

[핵심 기능]
1. 단계별 선택 흐름
   - 1단계: 식사 시간 선택 (아침 / 점심 / 저녁)
   - 2단계: 상황 선택 (혼자 / 직장동료 / 애인 / 가족)
   - 3단계: 음주 여부 선택 (예 / 아니오 / 모름)
   - 4단계: 음식 카테고리 선택 (한식 / 일식 / 양식 / 중식 / 분식)
   - 5단계: 추천 음식 3개로 보여주기

2. 알림 기능
   - 사용자가 식사 시간을 설정하면 1시간 전에 알림 발송
   - 아침/점심/저녁 각각 ON/OFF 가능

3. 다크/라이트 모드 지원

4. 광고 (배너 광고)

[필요 기술]
- 상태관리, DB(음식 데이터 저장), 인증/분석, 광고, 로컬 저장, 알림

다음 내용을 도와줘:
1. 이 앱의 핵심 가치와 차별점을 정리해줘
2. UX 흐름에서 개선할 수 있는 부분이 있으면 제안해줘
3. 추가하면 좋을 기능이 있다면 제안해줘
4. 위 기술 스택이 이 앱에 적합한지 검토해줘
5. 이 앱을 개발할 때 주의할 기술적 포인트를 정리해줘    

```

</details>
<details>
 <summary>Cursor 넣을 프롬프트 예시 전체 내용 보기</summary>

```text

Flutter로 "이따가 뭐 먹지" 음식 추천 앱을 처음부터 완성해줘.
아래 명세를 정확히 따라서 구현해줘.

---

## 앱 개요
- 앱 이름: 이따가 뭐 먹지
- 언어: 한국어 (ko_KR)
- 테마 색상: 주황색 (#FF6B35)
- Material 3 사용

---



## 화면 흐름
MainScreen
  └── Tab 0: MealTimeScreen (아침🌅 / 점심☀️ / 저녁🌙 선택)
        └── SituationScreen (혼자🍽️/ 직장동료👥 / 애인❤️ / 가족👨‍👩‍👧
              └── DrinkingScreen (음주 여부 선택)
                    └── CategoryScreen (한식/일식/양식/중식/분식 다중 선택, 선택 안 해도 다음 가능)
                          └── RecommendationScreen (음식 3개 PageView 좌우 스와이프)
  └── Tab 1: SettingsScreen (식사 시간 설정 + 알림 ON/OFF)

---



## UI 상세

### 공통 디자인 원칙
- 배경: LinearGradient (라이트: white → orange.shade50, 다크: #1A1A1A → #2D2D2D)
- 버튼: BorderRadius 20~24, BoxShadow, 그라데이션 배경
- 화면 전환: FadeTransition + SlideTransition (오른쪽에서 왼쪽)
- 햅틱 피드백 적용
- 버튼 fade-in + scale-up 등장 애니메이션
- 반응형: 세로/가로 모드, 작은 화면 대응 (ResponsiveHelper)
- 상단 AppBar: 다크/라이트 모드 토글 IconButton 포함

### MealTimeScreen
- 아침(🌅, 연한 주황 그라데이션), 점심(☀️, 연한 노랑), 저녁(🌙, 연한 파랑) 버튼
- 가로 모드: Row 배치, 세로 모드: Column 배치

### SituationScreen
- 혼자(🍽, 연녹), 직장동료(👥, 연파랑), 애인(❤️, 연분홍), 가족(👨‍👩‍👧‍👦, 연
- 선택 시 오렌지 테두리 + 체크 아이콘 + 오렌지 그림자
- 미선택 시 회색 배경
- 하단 "다음" 버튼: 선택 전 비활성(회색, opacity 0.6), 선택 후 오렌지

### DrinkingScreen
- 예 / 아니오 / 모름 선택

### CategoryScreen
- 한식 / 일식 / 양식 / 중식 / 분식 다중 선택
- "선택 안 함으로 모든 카테고리 추천" 안내 문구
- 선택 안 해도 다음 가능

### RecommendationScreen
- PageView 좌우 스와이프로 3개 음식 탐색
- 각 페이지: 음식 이미지(이모지), 음식명, 추천 이유 텍스트
- 하단: 페이지 인디케이터 dots
- "다시 추천받기" 버튼 (같은 조건으로 재요청)
- 로딩 중: SkeletonLoader 표시
- 에러 시: ErrorDialog 표시

### SettingsScreen
- 아침/점심/저녁 각각 시간 설정 카드
- 카드 내: 이모지 + 라벨 + 시간 (탭하면 TimePicker) + 알림 ON/OFF Switch
- 가로 모드: Row 배치, 세로 모드: Column 배치

### MainScreen
- BottomNavigationBar (추천받기🍽️/ 설정⚙️
- 하단: BannerAdWidget 고정 (광고 위에 BottomNav)
- 탭 전환 시 HapticFeedback

---


---
```

</details>

---

## 핵심 구현 내용

### 1. LRU 캐시 적용 (FoodService)

Supabase DB 조회 결과를 메모리에 캐싱하여 동일 조건 재요청 시 DB 호출을 생략합니다.

- 캐시 유효 시간: 15분
- 최대 캐시 항목: 100개 (조건 조합 단위)
- 만료 항목 제거 후, 한도 초과 시 가장 오래된 항목부터 LRU 방식으로 삭제
- 매 추천 요청마다 타임스탬프 기반 랜덤 시드를 생성하여 동일 조건에서도 다른 결과가 노출되도록 구성

```dart
// FoodService.dart
final randomSeed = now.millisecondsSinceEpoch ^ (now.microsecondsSinceEpoch << 16);
final random = Random(randomSeed);
final shuffled = List<FoodItem>.from(allCandidates)..shuffle(random);
```

### 2. 동적 추천 이유 텍스트 생성 (_generateDynamicReasonText)

음식 이름 · 식사 시간 · 상황 · 음주 여부 · 카테고리를 조합하여 적절한 추천 이유를 동적으로 생성합니다.

- 조건 조합별 템플릿 분기 (상황 4가지 × 음주 여부 2가지 × 카테고리 5가지)
- 음식 이름의 해시값으로 템플릿 중 하나를 선택 → 같은 음식은 항상 동일한 문구
- 회식(동료+술) 조건에서는 혼자 먹기 좋은 음식을 필터링하는 비즈니스 로직 구성

### 3. Firebase Analytics 이벤트 추적 (AnalyticsService)

사용자의 선택 흐름과 이탈 시점을 추적하기 위해 커스텀 이벤트를 설계하고 구현했습니다.

| 이벤트 | 추적 내용 |
|---|---|
| `meal_time_selected` | 식사 시간 선택 |
| `recommendation_requested` | 추천 요청 (조건 전체 포함) |
| `recommendation_viewed` | 추천 결과 조회 (추천 개수, 첫 번째 음식명) |
| `food_selected` | 최종 음식 선택 (선택 인덱스, 총 옵션 수) |
| `view_another_option` | 다른 옵션 보기 (스와이프 또는 버튼) |
| `recommendation_refreshed` | 다시 추천받기 (이전 음식명, 조회한 옵션 수) |
| `recommendation_failed` | 추천 실패 (에러 타입, 조건 포함) |

### 4. 앱 초기화 구조 설계

서비스 우선순위에 따라 초기화 순서를 분리하여 앱 시작 속도를 확보했습니다.

- Firebase Crashlytics, Supabase: 앱 실행 전 순차 초기화 (필수)
- Google Mobile Ads, 알림 서비스: `runApp()` 이후 비동기 초기화 (앱 시작 블로킹 방지)
- `runZonedGuarded`로 모든 비동기 영역의 미처리 예외를 Crashlytics에 자동 보고

### 5. 반응형 레이아웃 (ResponsiveHelper)

화면 방향(세로/가로)과 화면 크기에 따라 폰트 크기, 간격, 버튼 높이, 레이아웃 구조를 분기 처리했습니다.

---

## 기술 스택 및 선택 이유

| 기술 | 선택 이유 |
|---|---|
| **Flutter / Dart** | Android · iOS를 단일 코드베이스로 구성하기 위해 선택 |
| **Supabase** | PostgreSQL 기반 BaaS로 음식 데이터 관리와 조건 필터링 쿼리를 서버 설정 없이 구성 가능 |
| **Firebase Analytics** | 추천 흐름 내 사용자 행동을 이벤트 단위로 추적하기 위해 선택 |
| **Firebase Crashlytics** | 앱 배포 후 런타임 오류를 원격으로 수집하고 스택 트레이스를 확인하기 위해 선택 |
| **Firebase FCM** | 서버 없이 원격 푸시 알림을 발송하는 구조를 구성하기 위해 선택 |
| **flutter_local_notifications** | 매일 반복되는 식사 알림을 로컬에서 스케줄링하기 위해 선택 |
| **Provider** | 테마 상태 등 앱 전역 상태를 위젯 트리 전체에 간단하게 전달하기 위해 선택 |
| **shared_preferences** | 테마, 알림 시간 등 사용자 설정을 기기 로컬에 영속 저장하기 위해 선택 |
| **Google Mobile Ads** | AdMob 배너 광고를 앱에 통합하기 위해 선택 |

---



## 트러블슈팅 / 개선 경험

### 1. 앱 시작 시간 지연 문제

**문제**: Google Mobile Ads 초기화를 `runApp()` 이전에 동기로 실행하자 앱 첫 화면 표시가 지연되었습니다.

**개선**: 광고 초기화와 알림 서비스 초기화를 `runApp()` 이후 `.then()` 체인으로 분리하여 비동기 실행으로 전환했습니다. Firebase Crashlytics · Supabase만 필수 선행 초기화 대상으로 유지했습니다.

### 2. 동일 조건 반복 요청 시 불필요한 DB 호출

**문제**: 같은 조건으로 추천을 다시 요청할 때마다 Supabase 쿼리가 반복 실행되었습니다.

**개선**: 조건 조합을 키로 하는 메모리 캐시를 구현하고, 15분 유효 기간과 LRU 100개 한도를 설정했습니다. 캐시 적중 시 DB 호출 없이 즉시 반환합니다.

### 3. 회식 조건에서 부적절한 음식 노출

**문제**: 동료+술 조건에서 혼자 먹기 좋은 간단한 반찬류나 분식이 추천 결과에 포함되었습니다.

**개선**: `_isGoodForAlone()` 함수로 혼자 먹기 좋은 음식 목록을 정의하고, 회식 조건에서 해당 음식을 필터링하는 로직을 `FoodService`에 구성했습니다.

### 4. PageController 불안정 문제

**문제**: "다른 옵션 보기" 버튼 클릭 시 PageController가 준비되지 않은 상태에서 `animateToPage`를 호출하면 예외가 발생하는 경우가 있었습니다.

**개선**: `animateToPage` 대신 `jumpToPage`로 교체하고, `_pageController.hasClients` 확인 후 try/catch로 감싸 PageController가 미준비 상태일 때는 인덱스만 변경하는 폴백을 구성했습니다.

### 5. 테마 로딩으로 인한 초기 렌더링 블로킹

**문제**: `ThemeProvider` 초기화 시 저장된 테마를 `SharedPreferences`에서 읽는 동안 앱이 흰 화면으로 대기했습니다.

**개선**: `isLoading` 상태를 두고 로딩 중에는 기본 테마의 로딩 인디케이터를 표시하도록 분기 처리했습니다. 또한 1초 타임아웃을 설정하여 저장소 접근이 지연될 경우 기본값(라이트 모드)으로 빠르게 전환합니다.

### 6. 동적 추천 이유 문구가 맥락에 맞지 않게 생성되는 문제

**문제**: 처음에는 음식별 추천 이유 텍스트를 DB에 고정값으로 저장했습니다. 음식 수가 늘어날수록 이유 데이터도 함께 쌓여 DB가 불필요하게 비대해질 것이 우려되어 조건 조합으로 문구를 동적 생성하는 방식으로 전환했습니다. 하지만 전환 초기에는 상황·음주 여부 분기가 제대로 적용되지 않아 일반 반찬류에 "술자리에 잘 어울립니다" 같은 어색한 이유가 출력되는 문제가 발생했습니다.

**개선**: 상황(4가지) × 음주 여부(2가지) × 카테고리(5가지) 조합별로 템플릿을 분기하고, 음식 이름의 해시값으로 템플릿을 고정 선택하도록 `_generateDynamicReasonText()`를 구성했습니다. 이를 통해 같은 음식은 항상 동일한 문구를 표시하면서도 DB 용량 증가 없이 맥락에 맞는 추천 이유를 생성할 수 있었습니다.

---

## 핵심 함수 테이블

| 함수 | 위치 | 설명 |
|---|---|---|
| `FoodService.getRecommendations()` | `lib/services/food_service.dart` | 조건에 맞는 음식을 캐시 우선으로 조회하고, 매 요청마다 다른 랜덤 순서로 최대 3개 반환 |
| `FoodService._generateDynamicReasonText()` | `lib/services/food_service.dart` | 음식·상황·음주여부·카테고리 조합으로 추천 이유 텍스트를 동적 생성 |
| `FoodService._cleanupCache()` | `lib/services/food_service.dart` | 만료 항목 제거 후 LRU 방식으로 캐시 크기를 100개 이하로 유지 |
| `AnalyticsService.logFoodSelected()` | `lib/services/analytics_service.dart` | 최종 음식 선택 시 음식명, 카테고리, 선택 인덱스, 총 옵션 수를 Firebase Analytics에 기록 |
| `NotificationService.scheduleAllMealNotifications()` | `lib/services/notification_service.dart` | 저장된 설정을 기반으로 아침/점심/저녁 알림을 매일 반복 스케줄링 |
| `ThemeProvider.toggleTheme()` | `lib/providers/theme_provider.dart` | 라이트/다크 모드를 전환하고 변경된 설정을 비동기로 로컬 저장 |

---

## 실행 방법

### 사전 요구사항

- Flutter SDK `^3.10.4`
- `google-services.json` (Android) / `GoogleService-Info.plist` (iOS) — Firebase 프로젝트 설정 필요
- Supabase 프로젝트 URL 및 Anon Key — `lib/config/supabase_config.dart`에 입력

### 로컬 실행

```bash
flutter pub get
flutter run
```

### 의존성 목록

[pubspec.yaml](./pubspec.yaml)

---

## 프로젝트 구조

```
lib/
├── config/          # Supabase 설정
├── data/            # 로컬 하드코딩 음식 데이터 (MVP 초기 버전)
├── models/          # FoodItem, MealTime, EatingSituation, DrinkingStatus, FoodCategory
├── providers/       # ThemeProvider (Provider 패턴)
├── screens/         # 각 단계별 화면 (meal_time, situation, drinking, category, recommendation, settings)
├── services/        # FoodService, AnalyticsService, NotificationService, AdmobService 등
├── utils/           # ResponsiveHelper, AppLogger
└── widgets/         # SkeletonLoader, ErrorDialog, BannerAdWidget
```

---

## License

Private
