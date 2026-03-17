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
  └── Tab 0: MealTimeScreen (아침 / 점심 / 저녁 선택)
        └── SituationScreen (혼자 / 직장동료 / 애인 / 가족)
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
- 아침(연한 주황 그라데이션), 점심(연한 노랑), 저녁(연한 파랑) 버튼
- 가로 모드: Row 배치, 세로 모드: Column 배치

### SituationScreen
- 혼자(연녹), 직장동료(연파랑), 애인(연분홍), 가족(연보라)
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
- BottomNavigationBar (추천받기 / 설정)
- BottomNavigationBar 아래에 BannerAdWidget 고정 (화면 최하단)
- 탭 전환 시 HapticFeedback

---

```

</details>

---

## 🔑 핵심 구현 내용

### 1. 다크/라이트 모드 (ThemeProvider)

사용자가 선택한 테마를 SharedPreferences에 저장하여 앱 재시작 후에도 유지되도록 구현했습니다.

- SharedPreferences에 `'theme_mode'` 키로 `'light'` / `'dark'` / `'system'` 문자열 저장
- Provider(ChangeNotifier) 패턴의 `ThemeProvider`로 전역 상태 관리, `toggleTheme()`으로 라이트 ↔ 다크 즉시 전환
- 앱 시작 시 1초 타임아웃 내 저장된 테마 로딩, 실패 시 light 기본값으로 폴백
- `Selector` 패턴으로 `themeMode` 변경 시에만 위젯 리빌드하여 불필요한 렌더링 방지

### 2. 반응형 레이아웃 설계 (ResponsiveHelper)

다양한 모바일 기기 환경에서 UI가 깨지지 않도록
화면 방향(세로/가로)과 화면 크기에 따라 레이아웃과 UI 요소를 분기 처리

- 화면 높이를 기준으로 height < 500 → verySmall, height < 600 → small, 그 외 → normal 3단계로 구분
- 각 단계별로 폰트 크기, 여백, 버튼 높이를 별도 설정하여 화면 크기에 맞게 UI 조정
- verySmall 값이 없는 경우 small 기준의 0.9배를 적용하는 폴백 로직 구현

### 3. Firebase Analytics 이벤트 추적 (AnalyticsService)

사용자의 선택 흐름과 이탈 시점을 파악하기 위해 단계별 커스텀 이벤트를 설계하고 구현했습니다.

- 조건 선택 단계: 식사 시간 선택, 상황 선택(혼자/동료/연인/가족), 음주 여부 선택, 카테고리 선택(선택 개수·전체 선택 여부)
- 추천 결과 단계: 추천 요청(조건 전체 포함), 추천 결과 조회(추천 개수·첫 번째 음식명), 최종 음식 선택(선택 인덱스·총 옵션 수), 다른 옵션 보기, 다시 추천받기(이전 음식명·조회한 옵션 수), 처음으로 돌아가기, 추천 실패(에러 타입·조건 포함)
- 설정 단계: 알림 ON/OFF 변경(식사 유형·설정 시간), 알림 시간 변경(이전/이후 시간)
- 공통: 화면 전환(`screen_view`) 추적

### 4. 네이티브 앱 수준의 UX 구현

Flutter 크로스플랫폼 앱에서도 네이티브 앱과 동일한 반응성과 자연스러움을 목표로 직접 설계하고 구현했습니다.

- 화면 전환: `PageRouteBuilder` + `FadeTransition` + `SlideTransition`(easeOutCubic) 조합으로 350~400ms 부드러운 전환, 콘텐츠 흐름에 맞는 방향(좌→우, 하→상)으로 슬라이드
- 터치 피드백: `GestureDetector` + `ScaleTransition` + `HapticFeedback` 조합의 `InteractiveButton` 구현, 상황별 햅틱(`lightImpact` / `selectionClick` / `mediumImpact`) 구분 적용
- 제스처: `BouncingScrollPhysics`로 iOS/Android 통일된 바운스 스크롤, 빠른 하단 스와이프(velocity > 500)로 다시 추천받기 동작
- 애니메이션: `TweenAnimationBuilder`로 화면 진입 시 버튼 순차 등장, `AnimatedContainer`로 선택 항목 색상·인디케이터 도트 크기 즉시 전환
- 스켈레톤 로딩: shimmer 그라디언트 루프 애니메이션으로 로딩 중 레이아웃 점프 방지

### 5. 조건 기반 음식 추천 필터링 (FoodService)

- 식사 시간·상황·음주 여부·카테고리 4가지 조건을 Supabase `.eq()` 필터로 조합해 DB에서 후보를 조회
- 카테고리는 선택된 경우에만 추가 필터링, 선택 없으면 전체 카테고리 대상
- 회식(직장동료+음주) 조건에서는 `_isGoodForAlone()`으로 혼자 먹기 적합한 음식(라면, 반찬류 등)을 결과에서 제외
- 매 요청마다 `현재 시각(ms XOR μs << 16)` 기반 시드로 후보 목록을 셔플하여 최대 3개 반환 → 같은 조건이어도 매번 다른 순서로 노출

### 6. 동적 추천 이유 문구 생성 (_generateDynamicReasonText)

- 상황(4가지) × 음주 여부(2가지) 조합으로 9개 분기를 구성하고, 각 분기 안에서 카테고리(5가지)별 템플릿 배열을 별도 정의
- `foodName.hashCode.abs() % templates.length`로 템플릿을 결정론적으로 선택 → 같은 음식은 항상 동일한 문구를 반환
- `_isGoodForGroupGathering()` / `_isGoodForAlone()` / `_isLightFood()` 보조 함수로 음식 특성을 평가해 분기에 활용
- DB에 이유 텍스트를 저장하지 않고 코드 내 템플릿으로 처리하여 DB 용량 증가 없이 맥락 맞는 문구 생성

### 7. 식사 알림 스케줄링 (NotificationService)

- `scheduleAllMealNotifications()` 호출 시 기존 예약 전체 취소 후 아침/점심/저녁 알림을 재등록
- SettingsService에서 각 식사의 시간(HH:mm)과 ON/OFF 상태를 읽어 enabled=true인 항목만 스케줄링
- 설정된 식사 시간보다 **1시간 전**에 알림 발송 (예: 점심 12:00 → 11:00 알림)
- `Asia/Seoul` 타임존 고정, `matchDateTimeComponents: DateTimeComponents.time`으로 매일 반복
- `exactAllowWhileIdle` 모드로 절전 상태에서도 정확한 시각에 발송 보장

### 8. 레이어드 아키텍처 설계

Flutter 앱을 화면·비즈니스 로직·데이터·공통 유틸리티 4개 레이어로 분리하여
각 레이어가 단일 책임을 갖도록 설계했습니다.

- **screens/** : 단계별 화면(MealTime → Situation → Drinking → Category → Recommendation)을 독립 위젯으로 분리, 화면은 UI 렌더링과 사용자 입력 처리만 담당
- **services/** : 비즈니스 로직을 화면에서 완전히 분리 — `FoodService`(추천 필터링·캐시), `NotificationService`(알림 스케줄링), `AnalyticsService`(이벤트 추적) 각각 단일 책임
- **providers/** : 테마 등 앱 전역 상태를 `Provider(ChangeNotifier)` 패턴으로 관리하여 위젯 트리 어디서나 접근 가능
- **widgets/** : `SkeletonLoader`, `ErrorDialog`, `BannerAdWidget`, `InteractiveButton` 등 재사용 UI 컴포넌트를 별도 분리하여 화면 코드 중복 제거
- **models/** : `FoodItem`, `MealTime`, `EatingSituation` 등 도메인 모델을 별도 레이어로 정의하여 서비스·화면 양쪽에서 타입 안전하게 참조

### 🎬 시연 영상

<table>
  <tr>
    <th>APP 기능</th>
    <th>APP 알림</th>
  </tr>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/00ecc95a-92c2-439a-a800-1b10f3d5d423" width="300"></td>
    <td><img src="https://github.com/user-attachments/assets/21bb5885-d225-4ab9-8541-32258cfd1bc7" width="300"></td>
  </tr>
</table>

---

## 🛠️ 기술 스택 및 선택 이유

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



## 🔧 트러블슈팅 / 개선 경험

### 1. 앱 시작 시간 지연 문제

**문제**: Google Mobile Ads 초기화를 `runApp()` 이전에 동기로 실행하자 앱 첫 화면 표시가 지연되었습니다.

**개선**: 광고 초기화와 알림 서비스 초기화를 `runApp()` 이후 `.then()` 체인으로 분리하여 비동기 실행으로 전환했습니다. Firebase Crashlytics · Supabase만 필수 선행 초기화 대상으로 유지했습니다. `runZonedGuarded`로 모든 비동기 영역의 미처리 예외를 Crashlytics에 자동 보고하도록 감쌌으며, 각 초기화 단계 소요 시간을 ms 단위로 로깅하여 병목 구간을 파악할 수 있도록 했습니다.

### 2. 동일 조건 반복 요청 시 불필요한 DB 호출

**문제**: 같은 조건으로 추천을 다시 요청할 때마다 Supabase 쿼리가 반복 실행되었습니다.

**개선**: 조건 조합을 키로 하는 메모리 캐시를 구현하고, 15분 유효 기간과 LRU 100개 한도를 설정했습니다. 캐시 키는 카테고리 목록을 정렬 후 조합하여 선택 순서가 달라도 동일 키로 캐시가 적중되도록 했습니다. 만료 항목을 먼저 제거하고 한도 초과 시 가장 오래된 항목부터 LRU 방식으로 삭제합니다. 캐시 적중 시 DB 호출 없이 즉시 반환합니다.

### 3. PageController 불안정 문제

**문제**: "다른 옵션 보기" 버튼 클릭 시 PageController가 준비되지 않은 상태에서 `animateToPage`를 호출하면 예외가 발생하는 경우가 있었습니다.

**개선**: `animateToPage` 대신 `jumpToPage`로 교체하고, `_pageController.hasClients` 확인 후 try/catch로 감싸 PageController가 미준비 상태일 때는 인덱스만 변경하는 폴백을 구성했습니다.

### 4. 테마 로딩으로 인한 초기 렌더링 블로킹

**문제**: 두 가지 원인이 복합적으로 작용했습니다.

1. `ThemeProvider` 생성자에서 `_loadTheme()`을 호출할 때, 첫 번째 `await` 이전에 `notifyListeners()`가 동기적으로 실행되었습니다. `ChangeNotifierProvider`의 `create:` 콜백은 위젯 build 단계에서 실행되므로, build 도중 `notifyListeners()` → `setState()` 호출로 이어져 **"setState() called during build"** 에러가 발생했습니다.
2. 앱 시작 시 Firebase·Supabase 초기화와 `ThemeProvider`의 `SharedPreferences.getInstance()` 호출이 동시에 몰려 I/O 경합이 발생했고, 테마가 결정되기 전까지 앱이 흰 화면으로 대기했습니다.

**개선**: `isLoading` 상태를 두고 로딩 중에는 기본 테마의 로딩 인디케이터를 표시하도록 분기 처리했습니다. 또한 `SharedPrefsService` 싱글톤과 500ms 타임아웃으로 중복 접근 및 블로킹을 방지하고, `ThemeService.getThemeMode()`에 1초 타임아웃을 설정하여 저장소 접근이 지연될 경우 기본값(라이트 모드)으로 빠르게 전환합니다.

### 5. Google Play 비공개 테스트 통과 과정

**문제**: Google Play 스토어에 앱을 정식 출시하려면 비공개 테스트(클로즈드 테스트)를 일정 인원 이상이 설치하고 며칠간 실행해야 하는 요건을 충족해야 했습니다. 처음에는 가족·지인·친구에게 부탁했으나 인원 모으기 자체가 어려웠고, 며칠씩 매일 실행을 유지해야 한다는 조건 때문에 중도에 이탈하는 경우가 많아 통과에 실패했습니다. 다음으로 품앗이 형태로 운영되는 온라인 카페를 이용했지만 참여자의 지속적인 실행을 보장하기 어려워 이 방법도 요건을 채우지 못했습니다.

**개선**: 비공개 테스트 대행 업체에 위탁하는 방법으로 전환했습니다. 업체를 통해 필요 인원이 확보되었고, 진행 중에 Play Console 통계 지표가 비정상적인 수치를 보일 때 업체 측에서 먼저 알려줘 신속히 대응할 수 있었습니다. 결과적으로 비공개 테스트 요건을 충족하여 Google Play 스토어 정식 출시에 성공했습니다.

### 6. 동적 추천 이유 문구 및 회식 조건 음식 필터링 문제

**문제**: 처음에는 음식별 추천 이유 텍스트를 DB에 고정값으로 저장했습니다. 음식 수가 늘어날수록 이유 데이터도 함께 쌓여 DB가 불필요하게 비대해질 것이 우려되어 조건 조합으로 문구를 동적 생성하는 방식으로 전환했습니다. 하지만 전환 초기에는 상황·음주 여부 분기가 제대로 적용되지 않아 일반 반찬류에 "술자리에 잘 어울립니다" 같은 어색한 이유가 출력되는 문제가 발생했습니다.
또한 동료+술 조건에서 혼자 먹기 좋은 간단한 반찬류나 분식이 추천 결과에 포함되었습니다.

**개선**: 상황(4가지) × 음주 여부(2가지) × 카테고리(5가지) 조합별로 템플릿을 분기하고, 음식 이름의 해시값으로 템플릿을 고정 선택하도록 `_generateDynamicReasonText()`를 구성했습니다. 이를 통해 같은 음식은 항상 동일한 문구를 표시하면서도 DB 용량 증가 없이 맥락에 맞는 추천 이유를 생성할 수 있었습니다.
또한 `_isGoodForAlone()` 함수로 혼자 먹기 좋은 음식 목록을 정의하고, 회식 조건에서 해당 음식을 필터링하는 로직을 `FoodService`에 구성했습니다.

### 7. 식사 알림 구현 방식 선택 — FCM vs 로컬 알림

**문제**: 아침·점심·저녁 식사 시간 알림 기능을 추가하면서 처음에는 Firebase Cloud Messaging(FCM)을 사용하려 했습니다. FCM은 서버에서 기기로 메시지를 전송하는 방식이기 때문에, 매일 반복되는 알림을 보내려면 별도의 서버나 Cloud Functions가 필요하다는 점을 파악했습니다.

**개선**: FCM을 실제로 적용해본 뒤 동작 방식을 검토하는 과정에서 `flutter_local_notifications` 패키지를 사용한 로컬 알림 방식을 알게 되었습니다. 로컬 알림은 서버 없이 기기 자체에서 스케줄링이 가능하고, 매일 정해진 시간에 반복 발송하는 식사 알림 용도에 더 적합한 방식이었습니다. `NotificationService.scheduleAllMealNotifications()`로 저장된 사용자 설정을 읽어 아침·점심·저녁 알림을 기기 내에서 직접 예약하도록 구현했습니다.

### 8. 로컬 알림이 동작하지 않는 문제 — 패키지 버전 업그레이드로 해결

**문제**: `flutter_local_notifications`로 전환한 뒤에도 알림이 예약은 되는 것처럼 보였지만 실제로 기기에서 발송되지 않았습니다. 로그에는 오류가 없어 원인을 파악하기 어려웠습니다.

**개선**: 패키지 버전을 업그레이드하면서 문제가 해결되었습니다. 하위 버전에서 발생하던 스케줄링 관련 버그가 상위 버전에서 수정된 것으로 파악됩니다. 현재는 `flutter_local_notifications: ^17.2.2`(resolved: 17.2.4)와 `timezone: ^0.9.4`를 사용하고 있으며 정상 동작하고 있습니다.

### 9. 구글 배너 광고가 간헐적으로 표시되지 않는 문제

**문제**: AdMob 배너 광고가 앱 실행 시마다 일관되지 않게 표시되었습니다. 어떤 경우에는 정상적으로 노출되고, 다른 경우에는 광고 영역 자체가 렌더링되지 않거나 빈 공간으로 남았습니다. 오류 로그가 명확하게 나타나지 않아 원인 파악이 어려웠습니다.

**개선**: 광고 로드 타이밍과 위젯 생명주기를 점검하는 과정에서 문제가 해결되었습니다. AdMob 초기화(`MobileAds.instance.initialize()`) 완료 이후에 광고 로드가 시작되도록 순서를 정리하고, `BannerAdWidget`에서 광고 객체의 생명주기(load → dispose)가 위젯 생명주기와 일치하도록 관리하였습니다. 이후 광고가 안정적으로 노출되고 있습니다.

### 10. 광고 배너가 버튼 위에 겹쳐 조작을 방해하는 문제

**문제**: AdMob 배너 광고를 추가한 뒤, 광고 영역이 화면 하단의 버튼들 위에 겹쳐 렌더링되어 버튼을 누르기 어려운 상태가 되었습니다. 광고 위젯을 단순히 기존 레이아웃 위에 올려놓는 방식으로 구현했기 때문에 발생한 문제였습니다.

**개선**: `Stack` 대신 `Column` 기반 레이아웃으로 구조를 변경하여 광고 영역과 컨텐츠 영역이 수직으로 분리되도록 수정했습니다. 광고 배너를 화면 하단에 고정하되, 나머지 컨텐츠 영역이 광고 높이만큼 패딩을 확보하도록 조정하여 버튼과 광고가 겹치지 않게 되었습니다.

### 11. 화면 회전 직후 버튼을 누르면 앱이 오류나거나 멈추는 문제

**문제**: 앱 첫 실행 후 세로 ↔ 가로 모드로 회전한 직후 버튼을 누르면 앱이 충돌하거나 응답하지 않는 현상이 발생했습니다. 화면 회전 시 Flutter가 위젯 트리를 전체 재빌드하는 과정에서, `RecommendationScreen`의 `PageController`가 `PageView`로부터 일시적으로 분리(detach)된 상태가 됩니다. 이 순간 "다른 옵션 보기" 버튼을 누르면 `_pageController.jumpToPage()`가 컨트롤러가 연결된 뷰 없이 호출되어 예외가 발생했습니다. 또한 `MealTimeScreen`에서 가로/세로 레이아웃 전환 시 `ValueKey`가 다른 `RepaintBoundary`로 교체되면서 하위 위젯 트리가 언마운트·리마운트되는데, 이 리빌드 도중 버튼이 눌리면 이미 dispose된 위젯의 `setState`가 호출되는 문제도 있었습니다.

**개선**: `PageController` 사용 전 `_pageController.hasClients` 여부를 확인하도록 가드를 추가하고, `jumpToPage()` 호출 전체를 `try-catch`로 감쌌습니다. 또한 비동기 작업 완료 후 `setState`를 호출하는 모든 지점에 `if (mounted)` 체크를 적용하여, 위젯이 이미 트리에서 제거된 상태에서의 상태 변경을 방지했습니다. 이후 회전 직후 버튼을 눌러도 오류 없이 정상 동작하고 있습니다.

---

## 🚀 실행 방법

### 사전 요구사항

- Flutter SDK `^3.10.4`
- `google-services.json` (Android) / `GoogleService-Info.plist` (iOS) — Firebase 프로젝트 설정 필요
- Supabase 프로젝트 URL 및 Anon Key — `lib/config/supabase_config.dart`에 입력

### 로컬 실행

```bash
flutter pub get
flutter run
```


---

## 🌱 향후 개선 계획

- **Supabase 프리티어 자동 일시정지 대응 자동화**: Supabase 무료 플랜은 일정 기간 비활성 상태가 지속되면 프로젝트가 자동으로 일시정지되어 앱이 동작하지 않습니다. 현재는 주기적으로 수동 접속하거나 생각날 때마다 직접 활성화하는 방식으로 대응하고 있어 비효율적입니다. GitHub Actions 등 외부 스케줄러로 주기적인 헬스체크 요청을 자동 전송하거나, 유료 플랜 전환 또는 Railway·Fly.io 등 자동 일시정지가 없는 대안 플랫폼으로의 마이그레이션을 검토할 계획입니다.
- **iOS App Store 출시**: 현재 Google Play 스토어에만 배포된 상태이며, Apple Developer Program 연간 구독 비용(99 USD) 문제로 App Store 배포는 보류 중입니다. 비용 검토 후 iOS 빌드 설정 및 App Store Connect 심사 절차를 진행하여 iOS 사용자도 이용할 수 있도록 출시할 계획입니다.

---

## 📎 참고자료

<details>
<summary>ERD 보기</summary>
<img width="1538" height="802" alt="Image" src="https://github.com/user-attachments/assets/83bc8c32-e5cd-47a2-94b3-2317ada1193d" />
</details>
