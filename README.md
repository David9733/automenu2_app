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

앱 개발 중 AI 코딩 도구(Cursor)에 아래 한 줄 입력으로 랜딩페이지 개발용 프롬프트를 생성했습니다.<br>
```next.js기반으로 랜딩페이지를 만들고 싶어. 개인정보처리방침까지 포함해서. 그걸 만들기 위한 프롬프트를 줘```<br>
이를 통해 생성된 프롬프트를 기반으로 기능 구현을 시작하고, 이후 AI 코딩 도구(Cursor)를 활용하여 개발을 진행했습니다.
<details>
 <summary>생성된 프롬프트 예시 전체 내용 보기</summary>

```text
- Context

 - Flutter 앱 "이따가 뭐 먹지"의 Next.js 랜딩페이지 + 개인정보처리방침 페이지 생성
 - 사용 방식: Claude/AI에 바로 붙여넣기 → 코드 생성
 - 연락처/스토어 링크 없음 → 플레이스홀더 처리
 - 기존 LANDING_PAGE_PROMPT.md 대체하는 완성형 버전으로 저장

 출력

 LANDING_PAGE_PROMPT.md를 개선된 완성형 프롬프트로 교체.
 내용: 기술 스펙, 전체 파일 구조, 개인정보처리방침 내용 인라인 포함.

 최종 프롬프트 내용 (아래를 그대로 파일에 저장)

 ---
 Next.js 14 (App Router) + TypeScript + Tailwind CSS로
 "이따가 뭐 먹지" 모바일 앱의 랜딩페이지를 완성된 코드로 만들어주세요.
 모든 파일을 실행 가능한 상태로 작성해주세요.

 앱 정보

 - 앱 이름: 이따가 뭐 먹지
 - 설명: 간단한 질문 몇 가지로 딱 맞는 음식을 추천해주는 모바일 앱
 - 타겟: 직장인
 - 메인 컬러: #FF6B35 (오렌지)
 - Google Play: [GOOGLE_PLAY_URL] (플레이스홀더)
 - App Store: [APP_STORE_URL] (플레이스홀더)
 - 문의 이메일: [CONTACT_EMAIL] (플레이스홀더)

 주요 기능 (기능 소개 섹션에 사용)

 1. 🌅 식사 시간 선택 - 아침, 점심, 저녁 중 선택
 2. 👥 상황 선택 - 혼자, 동료, 애인, 가족과의 식사
 3. 🍺 음주 여부 선택 - 가볍게 한잔? 오늘은 패스?
 4. 🍽️맞춤 음식 추천 - 조건에 맞는 음식 1-3개 카드로 제공
 5. 👆 스와이프 제스처 - 카드 넘기며 원하는 음식 선택
 6. ⏰ 식사 알림 - 식사 시간에 맞춰 알림 설정

 기술 스택

 - Next.js 14 App Router
 - TypeScript
 - Tailwind CSS
 - lucide-react (아이콘)
 - 폰트: Noto Sans KR (Google Fonts)

 필수 파일 목록 (모두 작성해주세요)

 설정 파일

 - package.json - next, react, typescript, tailwindcss, lucide-react 포함
 - tailwind.config.ts - 커스텀 색상 (#FF6B35 오렌지) 포함
 - next.config.ts
 - tsconfig.json
 - postcss.config.mjs

 앱 파일

 - app/layout.tsx - Noto Sans KR 폰트, 메타데이터, 다크모드 클래스
 - app/page.tsx - 모든 섹션 조합
 - app/globals.css
 - app/privacy/page.tsx - 개인정보처리방침 페이지

 컴포넌트

 - components/Header.tsx - 로고 + 상단 내비게이션
 - components/Hero.tsx - 히어로 섹션
 - components/Features.tsx - 기능 소개 6개 카드
 - components/HowItWorks.tsx - 사용 방법 스텝 (선택 → 추천 → 식사)
 - components/DownloadSection.tsx - 다운로드 CTA
 - components/Footer.tsx - 푸터

 각 섹션 상세 요구사항

 Header

 - 왼쪽: 앱 이름 "이따가 뭐 먹지" (오렌지 컬러)
 - 오른쪽: "다운로드" 버튼
 - sticky, 스크롤 시 배경 blur 효과

 Hero 섹션

 - 배경: 오렌지 그라데이션 (#FF6B35 → #FF8C42)
 - 큰 제목: "오늘 뭐 먹을지\n고민 끝!"
 - 부제목: "식사 시간, 상황, 음주 여부만 선택하면\n딱 맞는 음식을 추천해드립니다"
 - 버튼 2개: Google Play 다운로드, App Store 다운로드
 - 오른쪽에 스마트폰 목업 (CSS로 구현, 실제 이미지 없이)

 Features 섹션

 - 6개 카드 그리드 (3열 × 2행)
 - 각 카드: 이모지 아이콘, 제목, 1-2줄 설명, 호버 시 오렌지 테두리 효과

 HowItWorks 섹션

 - 3단계 플로우: "시간 & 상황 선택" → "조건 분석" → "음식 추천"
 - 화살표로 연결

 DownloadSection

 - 배경: 짙은 회색 또는 오렌지
 - "지금 바로 다운로드" 헤드라인
 - Google Play / App Store 버튼 (SVG 로고 포함)

 Footer

 - 앱 이름, 슬로건
 - 링크: 개인정보처리방침 (/privacy)
 - 문의: [CONTACT_EMAIL]
 - 저작권: © 2024 이따가 뭐 먹지. All rights reserved.

 개인정보처리방침 페이지 (/privacy)

 app/privacy/page.tsx에 아래 내용을 HTML로 렌더링:
 - 상단: 뒤로가기 버튼 (← 홈으로)
 - 왼쪽 sticky: 목차 네비게이션 (데스크톱)
 - 본문: 아래 개인정보처리방침 전체 내용

 ---개인정보처리방침 원문---

 개인정보 처리 방침

 이따가 뭐 먹지 앱의 개인정보 처리 방침입니다.

 1. 개인정보의 처리 목적

 본 앱은 다음의 목적을 위하여 개인정보를 처리합니다.

 1.1 서비스 제공

 - 음식 추천 서비스 제공
 - 식사 시간 알림 서비스 제공
 - 앱 기능 개선 및 최적화

 1.2 서비스 분석 및 개선

 - 앱 사용 패턴 분석
 - 서비스 품질 향상을 위한 통계 분석
 - 오류 및 크래시 정보 수집 및 분석

 1.3 마케팅 및 광고

 - 맞춤형 광고 제공
 - 광고 성과 측정

 2. 처리하는 개인정보 항목 및 보유기간

 자동 수집 정보

 - 기기 정보: 기기 모델, 운영체제 버전, 고유 식별자
 - 앱 사용 정보: 앱 버전, 화면 조회 기록, 기능 사용 기록
 - 로그 정보: 오류 로그, 크래시 정보
 - 광고 식별자: 광고 ID (선택적)

 사용자 선택 정보

 - 식사 시간 설정: 아침, 점심, 저녁 식사 시간
 - 알림 설정: 식사 알림 활성화 여부
 - 앱 내 선택 정보: 식사 시간, 상황, 음주 여부, 음식 종류 선택 기록

 푸시 알림 관련 정보

 - FCM 토큰: 푸시 알림 전송을 위한 기기 토큰

 보유기간

 - 서비스 이용 기간: 앱 사용 중 및 앱 삭제 시까지
 - 법령에 따른 보존기간: 관련 법령에 따라 필요한 경우 해당 기간 동안 보관

 3. 개인정보의 제3자 제공

 본 앱은 원칙적으로 이용자의 개인정보를 외부에 제공하지 않습니다. 다만, 다음의 경우는 예외입니다.

 - Firebase (Google): 서비스 분석, 오류 추적, 푸시 알림 전송
 - Google Mobile Ads (Google): 맞춤형 광고 제공, 광고 성과 측정
 - Supabase: FCM 토큰, 앱 설정 정보 저장 및 관리

 4. 개인정보 처리의 위탁

 - Firebase (Google): 서비스 분석, 오류 추적, 푸시 알림 전송
 - Google Mobile Ads (Google): 광고 제공
 - Supabase: 데이터베이스 서비스

 5. 정보주체의 권리·의무 및 행사방법

 이용자는 다음과 같은 권리를 행사할 수 있습니다.
 - 개인정보 열람 요구
 - 개인정보 정정·삭제 요구 (앱 삭제 시 자동 삭제)
 - 개인정보 처리정지 요구 (앱 내 설정에서 비활성화 가능)
 - 또는 아래 연락처로 요청 가능

 6. 개인정보의 파기

 개인정보가 불필요하게 되었을 때에는 지체 없이 파기합니다.
 - 파기 절차: 앱 삭제 또는 요청 시, 보유기간 경과 시
 - 파기 방법: 전자적 파일은 복구 불가능하게 안전 삭제

 7. 개인정보 보호책임자

 - 이메일: [CONTACT_EMAIL]

 8. 개인정보의 안전성 확보 조치

 - 관리적 조치: 내부관리계획 수립·시행
 - 기술적 조치: 접근권한 관리, 접근통제시스템, 암호화, 보안프로그램
 - 물리적 조치: 전산실, 자료보관실 접근통제

 9. 쿠키 및 유사 기술의 사용

 본 앱은 쿠키를 사용하지 않습니다.
 다만, 서비스 분석 및 광고 제공을 위해 Firebase Analytics와 광고 식별자를 사용할 수 있습니다.

 10. 개인정보 처리방침 변경

 이 방침은 법령·정책 변경 시 변경사항 시행 7일 전부터 앱 내 공지사항을 통해 고지합니다.
 - 시행일자: 2024년 1월 1일
 - 최종 수정일: 2024년 1월 1일

 11. 권익침해 구제방법

 - 개인정보 침해신고센터: privacy.go.kr / 국번 없이 182
 - 개인정보 분쟁조정위원회: http://www.kopico.go.kr / 1833-6972
 - 대검찰청 사이버범죄수사단: http://www.spo.go.kr / 02-3480-3573
 - 경찰청 사이버테러대응센터: http://www.netan.go.kr / 국번 없이 182

 ---개인정보처리방침 끝---

 디자인 요구사항

 - 반응형: 모바일 우선, sm/md/lg 브레이크포인트
 - 다크모드: Tailwind dark: 클래스로 지원 (시스템 설정 따름)
 - 애니메이션: 스크롤 시 fade-in (CSS @keyframes 또는 Intersection Observer)
 - 버튼 hover: 오렌지 밝기 변화 + scale 효과

 SEO

 app/layout.tsx에 메타데이터:
 - title: "이따가 뭐 먹지 - 음식 추천 앱"
 - description: "식사 시간과 상황만 선택하면 딱 맞는 음식을 추천해드립니다"
 - og:title, og:description, og:type: website
 - keywords: 음식추천, 점심메뉴, 뭐먹지, 직장인점심

 주의사항

 - 실제 앱 스크린샷 이미지 없음 → CSS로 폰 목업 구현하거나 placeholder div 사용
 - [GOOGLE_PLAY_URL], [APP_STORE_URL], [CONTACT_EMAIL]은 플레이스홀더로 유지
 - npx create-next-app@latest로 시작하지 말고 모든 파일 내용을 직접 제공
 - Tailwind v4가 아닌 v3 기준으로 작성

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

## 초기 기획 프롬프트 (Prompt-driven Planning)

프로젝트 초기 단계에서 서비스 목적과 핵심 기능을 정의하는 프롬프트를 작성했습니다.
이 프롬프트를 기반으로 기능 구현을 시작하고, 이후 AI 코딩 도구를 활용하여 개발을 진행했습니다.

```text
목표:
"오늘 뭐 먹지?"라는 반복적인 고민을 해결해주는 모바일 앱을 만든다.
식사 시간, 상황, 음주 여부를 입력받아 조건에 맞는 음식을 추천해준다.

요구 기능:
- 식사 시간 선택 (아침 / 점심 / 저녁)
- 상황 선택 (혼자 / 동료 / 애인 / 가족)
- 음주 여부 선택
- 음식 카테고리 필터 (한식 / 일식 / 중식 / 양식 / 분식)
- 조건에 맞는 음식 추천 (최대 3개, 카드 UI로 표시)
- 음식 카드 스와이프로 다른 옵션 탐색
- 식사 시간 전 알림 기능 (사용자 설정 가능)
- 다크 모드 지원

기술 방향:
- Flutter로 Android / iOS 동시 지원
- 음식 데이터는 Supabase에 저장, 조건 필터링 쿼리로 추천
- Firebase Analytics로 사용자 행동 추적
- Firebase Crashlytics로 오류 모니터링
- FCM + 로컬 알림으로 식사 알림 구현

추가 요구사항:
- 추천 결과에 추천 이유 텍스트 표시 (상황에 맞는 문구)
- 앱 시작 속도 최적화 (광고, 알림 서비스는 비동기 초기화)
- 동일 조건 반복 요청 시 DB 재호출 방지 (캐싱)
- 가로/세로 화면 방향 모두 대응하는 반응형 레이아웃
```

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
