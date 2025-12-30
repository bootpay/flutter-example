# Flutter Example 트러블슈팅 가이드

## Android 빌드 에러: "cannot find symbol: PigeonApi*"

### 증상

Android 빌드 시 다음과 같은 에러 발생:

```
error: cannot find symbol
public class WebResourceRequestProxyApi extends PigeonApiWebResourceRequest {
                                                ^
  symbol: class PigeonApiWebResourceRequest

error: cannot find symbol
public class ProxyApiRegistrar extends AndroidWebkitLibraryPigeonProxyApiRegistrar {
                                       ^
  symbol: class AndroidWebkitLibraryPigeonProxyApiRegistrar
```

### 원인

Flutter 프로젝트가 `settings.gradle`에서 **plugins DSL** 방식으로 Kotlin 버전을 지정하는 경우:

```groovy
// settings.gradle
plugins {
    id "org.jetbrains.kotlin.android" version "2.0.21" apply false
}
```

하지만 `bootpay_webview_flutter_android` 패키지가 구식 **buildscript** 방식을 사용하면:

```groovy
// 구식 방식 (문제 발생)
buildscript {
    classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
}
apply plugin: 'kotlin-android'
```

Kotlin 플러그인이 제대로 적용되지 않아 `.kt` 파일(Pigeon 생성 코드)이 컴파일되지 않습니다.
Java 파일에서 Kotlin 클래스를 참조하려고 하면 "cannot find symbol" 에러가 발생합니다.

### 해결 방법

`bootpay_webview_flutter_android`의 `android/build.gradle`을 다음과 같이 수정:

**수정 전 (구식 buildscript 방식):**
```groovy
group = 'kr.co.bootpay.webviewflutter'
version = '1.0-SNAPSHOT'

buildscript {
    ext.kotlin_version = rootProject.ext.has('kotlin_version')
        ? rootProject.ext.get('kotlin_version')
        : '1.7.10'

    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:8.5.2'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }
}

rootProject.allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

apply plugin: 'com.android.library'
apply plugin: 'kotlin-android'

android {
    // ...
}
```

**수정 후 (plugins DSL 방식):**
```groovy
plugins {
    id 'com.android.library'
    id 'org.jetbrains.kotlin.android'
}

group = 'kr.co.bootpay.webviewflutter'
version = '1.0-SNAPSHOT'

android {
    // ...
}
```

### 주의사항

- `plugins {}` 블록은 **반드시 파일 맨 위**에 있어야 합니다
- `plugins {}` 블록 앞에는 `buildscript {}`, `pluginManagement {}` 외에 다른 코드가 올 수 없습니다
- `group`, `version` 등의 선언은 `plugins {}` 블록 **아래**에 위치해야 합니다

### 적용 버전

- `bootpay_webview_flutter_android: ^4.10.61` 이상에서 해결됨

---

## Android 빌드 경고: AGP/Kotlin 버전

### 증상

```
Warning: Flutter support for your project's Android Gradle Plugin version (8.5.2) will soon be dropped.
Warning: Flutter support for your project's Kotlin version (2.0.21) will soon be dropped.
```

### 해결 방법

`android/settings.gradle`에서 버전 업그레이드:

```groovy
plugins {
    id "com.android.application" version "8.6.0" apply false  // 8.5.2 -> 8.6.0+
    id "org.jetbrains.kotlin.android" version "2.1.0" apply false  // 2.0.21 -> 2.1.0+
}
```

---

*최종 업데이트: 2024-12-30*
