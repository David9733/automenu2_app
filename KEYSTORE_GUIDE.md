# Android 키스토어(Keystore) 생성 가이드

## 1. 키스토어 파일 생성

### 기본 명령어 형식
```bash
keytool -genkey -v -keystore [키스토어파일명].jks -keyalg RSA -keysize 2048 -validity 10000 -alias [알리아스명]
```

### 실제 예시
```bash
keytool -genkey -v -keystore automenu2-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias automenu2
```

### 명령어 옵션 설명
- `-genkey`: 새 키 쌍 생성
- `-v`: 상세 정보 출력 (verbose)
- `-keystore [파일명].jks`: 키스토어 파일 이름 (예: `automenu2-release-key.jks`)
- `-keyalg RSA`: 암호화 알고리즘 (RSA 사용)
- `-keysize 2048`: 키 크기 (2048비트 권장)
- `-validity 10000`: 유효 기간 (일 단위, 10000일 = 약 27년)
- `-alias [이름]`: 키의 별칭 (앱 이름 사용 권장)

## 2. 키스토어 생성 과정

명령어를 실행하면 다음 정보를 입력하라는 프롬프트가 나타납니다:

```
키 저장소 비밀번호 입력: [비밀번호 입력]
새 비밀번호 다시 입력: [비밀번호 확인]

이름과 성을 입력하십시오.
  [Unknown]: [개발자 이름]

조직 단위 이름을 입력하십시오.
  [Unknown]: [부서명 또는 생략]

조직 이름을 입력하십시오.
  [Unknown]: [회사명 또는 앱 이름]

구/군/시 이름을 입력하십시오?
  [Unknown]: [도시명]

시/도 이름을 입력하십시오.
  [Unknown]: [시/도명]

이 조직의 두 자리 국가 코드를 입력하십시오.
  [Unknown]: KR

CN=개발자이름, OU=부서, O=회사명, L=도시, ST=시도, C=KR이(가) 맞습니까?
  [아니오]: y

[알리아스명]에 대한 키 비밀번호를 입력하십시오.
        (RETURN을 누르면 키 저장소 비밀번호와 동일): [Enter 또는 별도 비밀번호]
```

### 중요 사항
- **키스토어 비밀번호**: 반드시 안전한 곳에 보관하세요. 분실하면 앱 업데이트가 불가능합니다.
- **알리아스 비밀번호**: Enter를 누르면 키스토어 비밀번호와 동일하게 설정됩니다.
- **국가 코드**: 한국은 `KR`, 미국은 `US` 등

## 3. 키스토어 파일 위치

키스토어 파일은 안전한 위치에 저장하세요. 권장 위치:

```
프로젝트 루트/android/app/
또는
별도의 안전한 폴더 (백업 필수!)
```

## 4. 키스토어 정보 확인

생성된 키스토어 정보를 확인하려면:

```bash
keytool -list -v -keystore automenu2-release-key.jks
```

## 5. 키스토어 비밀번호 변경

비밀번호를 변경하려면:

```bash
keytool -storepasswd -keystore automenu2-release-key.jks
```

## 6. 키스토어 백업

**중요**: 키스토어 파일과 비밀번호는 반드시 안전한 곳에 백업하세요!
- 키스토어 파일 분실 시 앱 업데이트 불가능
- Google Play Console에 등록된 앱은 키스토어 없이 업데이트할 수 없음

## 7. 보안 주의사항

1. **키스토어 파일을 Git에 커밋하지 마세요!**
   - `.gitignore`에 추가: `*.jks`, `*.keystore`
   
2. **비밀번호는 안전하게 관리**
   - 비밀번호 관리자 사용 권장
   - 팀원과 공유 시 안전한 방법 사용

3. **백업 필수**
   - 여러 위치에 백업 보관
   - 클라우드 저장소 사용 시 암호화 필수

