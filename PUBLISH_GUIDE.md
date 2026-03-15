# Google Play 스토어 출시 가이드

## 현재 상태
- ✅ 키스토어 파일 생성 완료
- ✅ Release APK 빌드 완료
- ✅ 앱 버전: 1.0.0+1

## 다음 단계

### 1단계: App Bundle 생성 (권장)

Google Play에는 APK보다 **App Bundle (.aab)** 형식이 권장됩니다.

```bash
flutter build appbundle --release
```

**생성 위치**: `build/app/outputs/bundle/release/app-release.aab`

### 2단계: Google Play Console 계정 준비

1. **Google Play Console 접속**
   - https://play.google.com/console 접속
   - Google 계정으로 로그인

2. **개발자 등록**
   - 개발자 등록비: **$25 (일회성)**
   - 결제 후 계정 활성화 (보통 24-48시간 소요)

3. **앱 생성**
   - "앱 만들기" 클릭
   - 앱 이름, 기본 언어, 앱 또는 게임 선택
   - 무료/유료 선택

### 3단계: 앱 정보 준비

Google Play Console에 업로드하기 전에 다음 정보를 준비하세요:

#### 필수 항목:
- ✅ **앱 아이콘**: 512x512px (이미 준비됨)
- ✅ **기능 그래픽**: 1024x500px (선택사항)
- ✅ **스크린샷**: 최소 2개 (필수)
  - 휴대전화: 최소 2개, 최대 8개
  - 7인치 태블릿: 선택사항
  - 10인치 태블릿: 선택사항
- ✅ **앱 설명**: 한국어 및 영어
- ✅ **짧은 설명**: 최대 80자
- ✅ **전체 설명**: 최대 4000자

#### 권장 항목:
- **프라이버시 정책 URL**: (필수 - 개인정보 수집 시)
- **연락처 이메일**: 개발자 연락처
- **웹사이트**: (선택사항)

### 4단계: 콘텐츠 등급 설정

1. **콘텐츠 등급 설문 작성**
   - 앱의 콘텐츠에 대한 질문에 답변
   - 자동으로 등급 부여 (예: Everyone, Teen 등)

### 5단계: 가격 및 배포 설정

1. **가격 설정**
   - 무료 또는 유료 선택
   - 유료인 경우 가격 설정

2. **국가/지역 선택**
   - 앱을 배포할 국가 선택
   - 한국 포함 권장

### 6단계: App Bundle 업로드

1. **프로덕션 트랙 선택**
   - 내부 테스트 / 비공개 테스트 / 공개 테스트 / 프로덕션
   - 처음에는 "내부 테스트" 또는 "비공개 테스트" 권장

2. **App Bundle 업로드**
   - "새 버전 만들기" 클릭
   - `app-release.aab` 파일 업로드
   - 버전 정보 확인 (1.0.0, 버전 코드: 1)

3. **릴리스 노트 작성**
   - 이번 버전의 변경사항 설명
   - 예: "초기 출시 버전"

### 7단계: 검토 제출

1. **모든 섹션 완료 확인**
   - ✅ 앱 콘텐츠
   - ✅ 스토어 등록정보
   - ✅ 정책 준수
   - ✅ 앱 액세스 권한
   - ✅ 타겟 고객 및 콘텐츠
   - ✅ 가격 및 배포

2. **검토 제출**
   - "검토를 위해 제출" 클릭
   - 검토 기간: 보통 1-3일

### 8단계: 출시 후 관리

1. **업데이트 준비**
   - `pubspec.yaml`에서 버전 업데이트
   - 예: `version: 1.0.1+2` (버전명: 1.0.1, 버전 코드: 2)

2. **새 버전 빌드**
   ```bash
   flutter build appbundle --release
   ```

3. **업데이트 업로드**
   - Google Play Console에서 새 버전 업로드
   - 릴리스 노트 작성

## 중요 체크리스트

### 출시 전 확인사항:
- [ ] 앱이 정상적으로 작동하는지 테스트
- [ ] 모든 권한이 필요한지 확인
- [ ] 개인정보 수집 시 프라이버시 정책 준비
- [ ] 스크린샷 준비 (최소 2개)
- [ ] 앱 설명 작성 (한국어 및 영어)
- [ ] 연락처 이메일 설정
- [ ] 콘텐츠 등급 설정 완료

### 보안 확인:
- [ ] 키스토어 파일 백업 완료
- [ ] 키스토어 비밀번호 안전하게 보관
- [ ] `.gitignore`에 키스토어 파일 추가 확인

## 유용한 링크

- **Google Play Console**: https://play.google.com/console
- **앱 서명 가이드**: https://developer.android.com/studio/publish/app-signing
- **앱 번들 가이드**: https://developer.android.com/guide/app-bundle
- **정책 센터**: https://play.google.com/about/developer-content-policy/

## 문제 해결

### 빌드 오류 발생 시:
```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

### 버전 코드 오류 시:
- `pubspec.yaml`의 `version: 1.0.0+1`에서 `+1` 부분이 버전 코드입니다
- 업데이트 시마다 버전 코드를 증가시켜야 합니다

## 다음 액션

1. **App Bundle 생성**:
   ```bash
   flutter build appbundle --release
   ```

2. **Google Play Console 접속 및 앱 생성**

3. **앱 정보 및 스크린샷 준비**

4. **App Bundle 업로드 및 검토 제출**

