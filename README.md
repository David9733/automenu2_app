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

### 1. 레이어드 아키텍처 설계

Flutter 앱을 화면·비즈니스 로직·데이터·공통 유틸리티 5개 레이어로 분리하여 각 레이어가 단일 책임을 갖도록 설계했습니다.

- **screens/** : 단계별 화면을 독립 위젯으로 분리, 화면은 UI 렌더링과 사용자 입력 처리만 담당
- **services/** : 추천 필터링·캐시, 알림 스케줄링, 이벤트 추적 각각 단일 책임으로 하여 비즈니스 로직을 분리
- **providers/** : 테마 등 앱 전역 상태를 `Provider(ChangeNotifier)` 패턴으로 관리하여 위젯 트리 어디서나 접근 가능
- **widgets/** : 재사용 UI 컴포넌트를 별도 분리하여 화면 코드 중복 제거  
- **models/** : 도메인 모델을 별도 레이어로 정의하여 서비스·화면 양쪽에서 타입 안전하게 참조

### 2. 조건 기반 음식 추천 필터링

선택한 조건 조합을 Supabase 쿼리로 필터링하고, 예외 처리와 결과 다양성까지 FoodService 한 곳에 집중하여 구현했습니다.

- 식사 시간·상황·음주 여부·카테고리 4가지 조건을 Supabase `.eq()` 필터로 조합해 DB에서 후보를 조회
- 카테고리는 선택된 경우에만 추가 필터링, 선택 없으면 전체 카테고리 대상
- 회식(직장동료+음주) 조건에서는 `_isGoodForAlone()`으로 혼자 먹기 적합한 음식(라면, 반찬류 등)을 결과에서 제외
- 매 요청마다 현재 시각 기반 시드로 후보 목록을 셔플하여 최대 3개 반환 → 같은 조건이어도 매번 다른 순서로 노출
- 상황 × 음주 × 카테고리 조합 템플릿에 음식 이름 해시값을 적용, DB 저장 없이 맥락에 맞는 추천 이유 생성   

### 3. 다크/라이트 모드

사용자가 선택한 테마를 SharedPreferences에 저장하여 앱 재시작 후에도 유지되도록 구현했습니다.

- SharedPreferences에 `'theme_mode'` 키로 `'light'` / `'dark'` / `'system'` 문자열 저장
- Provider(ChangeNotifier) 패턴의 `ThemeProvider`로 전역 상태 관리
- 앱 시작 시 1초 타임아웃 내 저장된 테마 로딩, 실패 시 light 기본값으로 폴백
- `Selector` 패턴으로 `themeMode` 변경 시에만 위젯 리빌드하여 불필요한 렌더링 방지

### 4. 반응형 레이아웃 설계

모바일 기기 환경에서 UI가 깨지지 않도록 화면 방향(세로/가로)과 화면 크기에 따라 레이아웃과 UI 요소를 분기 처리했습니다.

- 화면 높이를 기준으로 height < 500 → verySmall, height < 600 → small, 그 외 → normal 3단계로 구분
- 각 단계별로 폰트 크기, 여백, 버튼 높이를 별도 설정하여 화면 크기에 맞게 UI 조정
- verySmall 값이 없는 경우 small 기준의 0.9배를 적용하는 폴백 로직 구현

### 5. 네이티브 앱 수준의 UX 구현

Flutter 크로스플랫폼 앱에서도 네이티브 앱과 동일한 반응성과 자연스러움을 목표로 직접 설계하고 구현했습니다.

- 화면 전환: `PageRouteBuilder` + `FadeTransition` + `SlideTransition`으로 350~400ms, 방향(좌→우, 하→상) 슬라이드
- 터치 피드백: `ScaleTransition` + `HapticFeedback`(`lightImpact` / `selectionClick` / `mediumImpact`) 적용
- 제스처: `BouncingScrollPhysics`로 iOS/Android 바운스 스크롤 통일, 빠른 하단 스와이프(velocity > 500)로 재추천
- 애니메이션: `TweenAnimationBuilder`로 버튼 순차 등장, `AnimatedContainer`로 선택 항목 색상·도트 크기 즉시 전환
- 스켈레톤 로딩: shimmer 그라디언트 루프 애니메이션으로 로딩 중 레이아웃 점프 방지

### 6. Firebase Analytics 이벤트 추적

사용자의 선택 흐름과 이탈 시점을 파악하기 위해 단계별 커스텀 이벤트를 설계하고 구현했습니다.

- 조건 선택 단계: 식사 시간 선택, 상황 선택, 음주 여부 선택, 카테고리 선택
- 추천 결과 단계: 추천 요청, 결과 조회, 음식 선택, 다른 옵션, 재추천, 처음으로, 추천 실패
- 설정 단계: 알림 ON/OFF 변경, 알림 시간 변경
- 공통: 화면 전환(`screen_view`) 추적

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

| 기술 | 버전 | 선택 이유 |
|------|------|-----------|
| **Flutter** | 3.35.0 | Android · iOS를 단일 코드베이스로 구성, 위젯 기반 구조로 화면 단위 개발 |
| **Dart** | 3.10.4 | 강타입 시스템으로 빌드 단계에서 오류를 사전 차단 |
| **firebase_core** | 3.15.2 | Firebase 전체 제품군의 기반 초기화 패키지<br>Analytics · Crashlytics · FCM 사용을 위해 필수 포함 |
| **Supabase** | 2.12.0 | 음식 데이터 관리와 조건 필터링 쿼리를 서버 설정 없이 구성 가능<br>`.eq()` 필터 조합으로 다중 조건을 단일 쿼리로 처리 |
| **Firebase Analytics** | 11.6.0 | 단계별 커스텀 이벤트로 추천 흐름 내 이탈 시점 분석 |
| **Firebase Crashlytics** | 4.3.10 | 앱 배포 후 런타임 오류를 원격으로 수집하고 스택 트레이스를 확인 가능 |
| **Firebase FCM** | 15.2.10 | 원격 푸시 알림 구조 구성 및 향후 서버 기반 공지·마케팅 확장을 고려해 포함 |
| **flutter_local_notifications** | 17.2.4 | 매일 반복되는 식사 알림을 서버 없이 기기 내에서 스케줄링하기 위해 선택<br>아침·점심·저녁 각각 ON/OFF 및 시간 설정을 일괄 예약 |
| **timezone** | 0.9.4 | 로컬 시간 기준으로 정확한 반복 알림 발송을 하기 위해 기기 시간대 처리 목적 |
| **Provider** | 6.1.5 | 앱 전역 상태를 위젯 트리 전체에 간단하게 전달하기 위해 선택<br>`Selector` 패턴으로 `themeMode` 변경 시 위젯 리빌드하여 낭비 렌더링 방지 |
| **shared_preferences** | 2.5.4 | 사용자 설정을 기기 로컬에 영속 저장하기 위해 선택<br>앱 재시작 후에도 설정이 유지되도록 키-값 형태로 저장 |
| **Google Mobile Ads** | 5.3.1 | AdMob 배너 광고를 앱 하단에 고정 통합하기 위해 선택 |

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Provider](https://img.shields.io/badge/Provider-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Google Admob](https://img.shields.io/badge/AdMob-EA4335?style=for-the-badge&logo=google&logoColor=white)

---



## 🔧 트러블슈팅 / 개선 경험

### 성능 최적화

- **앱 시작 시간 지연** : Google Mobile Ads 초기화를 `runApp()` 이전에 동기로 실행하자 첫 화면 표시가 지연되었습니다.<br> 광고·알림 초기화를 `runApp()` 이후 `.then()` 체인으로 분리해 비동기 실행으로 전환하고, Firebase Crashlytics, Supabase만 필수 선행 초기화 대상으로 유지했습니다. 초기화 순서는 실행 시간이 아니라 첫 화면 렌더링과의 의존 관계를 기준으로 결정해야 체감 속도가 실질적으로 개선된다는 것을 확인했습니다.

- **동일 조건 반복 요청 시 불필요한 DB 호출** : 같은 조건으로 추천을 요청할 때마다 Supabase 쿼리가 반복 실행되었습니다. 조건 조합을 키로 하는 메모리 캐시를 구현하고 15분 유효 기간과 LRU 100개 한도를 설정했습니다. 카테고리 목록을<br>정렬 후 조합해 선택 순서가 달라도 동일 키로 캐시가 적중되도록 했습니다. 캐시는 키 설계가 효율을 결정합니다. 의미상<br>동일한 요청이 입력 순서 차이로 다른 키로 처리되지 않도록 정규화를 먼저 설계해야 한다는 것을 배웠습니다.

### Flutter

- **테마 로딩으로 인한 초기 렌더링 블로킹** : `ThemeProvider` 생성자에서 `_loadTheme()` 호출 시 build 단계에 `notifyListeners()` 연쇄로 `"setState() called during build"` 에러가 발생했고, 초기화 경합으로 테마 결정 전까지<br>흰 화면이 유지되었습니다. `isLoading` 상태 분기와 `ThemeService.getThemeMode()`에 1초 타임아웃을 추가해 로딩 중에는 인디케이터를, 지연 시에는 라이트 모드 폴백으로 즉시 전환하도록 처리했습니다. Provider 초기화 타이밍이 Flutter 빌드<br>사이클과 어긋나면 내부에서 에러가 연쇄 발생할 수 있다는 것을 확인했습니다.

- **화면 회전 직후 버튼 조작 시 앱 충돌** : 세로 ↔ 가로 회전 직후 버튼을 누르면 앱이 충돌하거나 응답하지 않았습니다. 위젯<br>트리 전체 재빌드 중 `PageController`가 `PageView`로부터 일시적으로 분리된 상태에서 `jumpToPage()`가 호출되거나,<br>이미 dispose된 위젯의 `setState`가 호출되는 것이 원인이었습니다. `_pageController.hasClients` 가드와 `try-catch`를 추가하고, 비동기 `setState` 호출 지점에 `if (mounted)` 체크를 적용하여 해결했습니다. 생명주기에 종속된 객체는 hasClients 가드와 mounted 체크를 함께 적용해야 한다는 것을 확인했습니다.

### 기능 설계

- **동적 추천 이유 생성 및 회식 조건 필터링** : 음식별 추천 이유를 DB 고정값으로 저장했더니 음식 수가 늘수록 DB가 커졌고, 동적 생성으로 전환하는 과정에서 상황·음주 분기가 제대로 적용되지 않아 일반 반찬에 어색한 추천 이유가 출력됐습니다. 상황×음주×카테고리 조합 템플릿과 음식 이름 해시값으로 `_generateDynamicReasonText()`를 구성하고, `_isGoodForAlone()`으로 회식 조건 필터링을 추가해 해결했습니다. 조합 가능한 변수가 있다면 DB 고정값보다 코드<br>생성이 확장성과 유지보수 모두 유리하다는 것을 확인했습니다.

- **FCM으로 반복 알림 구현 불가로 로컬 알림 전환** : 매일 반복되는 식사 알림을 FCM으로 구현하려 했으나 반복 발송을 위해 별도 서버나 Cloud Functions가 필요하다는 점을 파악했습니다. `flutter_local_notifications`로 전환해 서버 없이 기기 자체에서 스케줄링하고, `NotificationService.scheduleAllMealNotifications()`로 아침·점심·저녁 알림을 기기 내에서 직접 예약하도록 구현했습니다. 서버 없는 환경에서 매일 반복 발송이 필요한 알림은 FCM보다 로컬 알림이 구조적으로<br>더 적합하다는 것을 직접 확인했습니다.

### 광고

- **AdMob 배너 광고 간헐적 미표시** : AdMob 배너가 앱 실행 시마다 일관되지 않게 표시되거나 빈 공간으로 남았고, 오류<br>로그도 명확하지 않아 원인 파악이 어려웠습니다. `MobileAds.instance.initialize()` 완료 이후에 광고 로드가<br>시작되도록 순서를 정리하고, `BannerAdWidget`에서 광고 객체의 생명주기(load → dispose)를 위젯 생명주기와 일치하도록 관리해 안정적으로 노출되도록 했습니다. SDK 초기화 완료 전 광고 로드는 오류 로그 없이 조용히 실패하므로, initialize()<br>이후 시퀀싱을 명시적으로 보장해야 한다는 것을 배웠습니다.

- **광고 배너와 버튼 겹침** : AdMob 배너를 기존 레이아웃 위에 단순히 올려놓자 광고 영역이 하단 버튼들 위에 겹쳐 조작을<br>방해했습니다. `Stack` 대신 `Column` 기반 레이아웃으로 구조를 변경해 광고·콘텐츠 영역이 수직으로 분리되도록 하고,<br>콘텐츠 영역이 광고 높이만큼 패딩을 확보하도록 조정했습니다. Stack의 터치 영역 침범은 시각적으로 드러나지 않으므로, 레이아웃 변경 시 터치 영역이 물리적으로 겹치지 않는 구조를 우선 선택해야 한다는 것을 배웠습니다.

### 디버깅

- **로컬 알림 미동작** : `flutter_local_notifications`로 전환한 뒤에도 알림이 예약은 되는 것처럼 보였지만 실제 기기에서 발송되지 않았고, 로그에도 오류가 없어 원인 파악이 어려웠습니다. Flutter 및 다른 의존성과 호환되는 버전으로<br>다운그레이드하면서 문제가 해결되었습니다.(현재 `flutter_local_notifications: ^17.2.2`, `timezone: ^0.9.4`)<br>예약 성공처럼 보이지만 실제 발송이 안 되고 오류 로그도 없는 증상은 버전 비호환의 전형적 패턴이므로, 재현이 어렵고<br>로그가 없는 실패에서는 패키지 버전부터 먼저 확인해야 한다는 것을 배웠습니다.

### 배포

- **Google Play 비공개 테스트 통과** : 정식 출시 전 일정 인원 이상이 며칠간 앱을 실행해야 하는 비공개 테스트 요건을<br>충족해야 했으나, 가족·지인 모집과 온라인 카페 품앗이 방식 모두 지속적인 참여를 보장하기 어려웠습니다. 비공개 테스트 대행 업체를 통해 필요 인원을 확보하고 Play Console 이상 지표도 신속히 대응해 정식 출시에 성공했습니다. Google Play 비공개 테스트는 12명 이상의 테스터가 14일 연속으로 앱을 실행해야 정식 출시 신청이 가능한 구체적인 요건이 있어, 개발 완료 후에도 출시까지 최소 2주 이상의 별도 일정이 필요하다는 것을 직접 체감했습니다.

---

## 🚀 실행 방법

### 로컬 실행

```bash
# 1. 패키지 설치
flutter pub get

# 2. 실행
flutter run
```

Android: `google-services.json`<br>
iOS: `GoogleService-Info.plist`<br>
Supabase URL, Anon Key: `lib/config/supabase_config.dart`
```dart
// lib/config/supabase_config.dart
const supabaseUrl = 'YOUR_SUPABASE_URL';
const supabaseAnonKey = 'YOUR_ANON_KEY';
```


---

## 🌱 향후 개선 계획

- [ ] Supabase 자동 일시정지 대응 자동화
- [ ] iOS App Store 출시
- [ ] 음식 데이터 확장

---

## 📎 참고자료

<details>
<summary>ERD 보기</summary>
<img width="1538" height="802" alt="Image" src="https://github.com/user-attachments/assets/83bc8c32-e5cd-47a2-94b3-2317ada1193d" />
</details>
