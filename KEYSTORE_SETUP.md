# 키스토어 설정 가이드

## 1단계: 키스토어 파일 생성

프로젝트 루트에서 다음 명령어를 실행하세요:

```bash
keytool -genkey -v -keystore android/app/automenu2-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias automenu2
```

또는 `android/app` 폴더로 이동 후:

```bash
cd android/app
keytool -genkey -v -keystore automenu2-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias automenu2
```

## 2단계: key.properties 파일 생성

`android` 폴더에 `key.properties` 파일을 생성하고 다음 내용을 입력하세요:

```properties
storePassword=여기에_키스토어_비밀번호_입력
keyPassword=여기에_알리아스_비밀번호_입력
keyAlias=automenu2
storeFile=app/automenu2-release-key.jks
```

**주의**: 
- `key.properties` 파일은 `.gitignore`에 추가되어 있어 Git에 커밋되지 않습니다.
- 실제 비밀번호로 변경하세요.

## 3단계: build.gradle.kts 수정

`android/app/build.gradle.kts` 파일을 다음과 같이 수정하세요:

```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

// 키스토어 설정 로드
val keystoreProperties = java.util.Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(java.io.FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.example.automenu2"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.automenu2"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
```

## 4단계: Release 빌드

이제 다음 명령어로 서명된 APK를 빌드할 수 있습니다:

```bash
flutter build apk --release
```

또는 App Bundle (Google Play 업로드용):

```bash
flutter build appbundle --release
```

## 5단계: 빌드 파일 위치

- **APK**: `build/app/outputs/flutter-apk/app-release.apk`
- **App Bundle**: `build/app/outputs/bundle/release/app-release.aab`

## 보안 주의사항

1. ✅ 키스토어 파일(`*.jks`)은 `.gitignore`에 추가되어 있습니다.
2. ✅ `key.properties` 파일도 `.gitignore`에 추가되어 있습니다.
3. ⚠️ 키스토어 파일과 비밀번호는 반드시 안전한 곳에 백업하세요!
4. ⚠️ 키스토어를 분실하면 앱 업데이트가 불가능합니다.

