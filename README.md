# Bootpay Flutter 공식 예제

부트페이에서 지원하는 공식 Flutter 예제입니다.

## 지원 플랫폼
- Android (API 16+)
- iOS (9.0+)
- Web

## 의존성

```yaml
dependencies:
  bootpay: ^5.0.22         # PG 결제
  bootpay_bio: ^5.0.14     # 생체인증 결제
  get: ^4.6.5              # 라우팅
```

## 테스트 메뉴

| 메뉴 | 설명 | 사용 메서드 |
|------|------|------------|
| PG일반 결제 테스트 | 일반 PG 결제 | `requestPayment()` |
| 통합결제 테스트 | 여러 결제수단 통합 | `requestPayment()` |
| 카드자동 결제 테스트(인증) | 정기결제 빌링키 발급 | `requestSubscription()` |
| 카드자동 결제 테스트(비인증) | 비인증 정기결제 | `requestSubscription()` |
| 본인인증 테스트 | 휴대폰 본인인증 | `requestAuthentication()` |
| 생체인증 결제 테스트 | 지문/Face ID 결제 | `bootpay_bio` 패키지 |
| 비밀번호 결제 테스트 | 비밀번호 간편결제 | `bootpay_bio` 패키지 |
| 웹앱으로 연동하기 | WebView 기반 연동 | WebView |

## 기본 사용법

### 1. Application ID 설정

[부트페이 관리자](https://admin.bootpay.co.kr)에서 Application ID를 발급받으세요.

```dart
String webApplicationId = '발급받은_WEB_APPLICATION_ID';
String androidApplicationId = '발급받은_ANDROID_APPLICATION_ID';
String iosApplicationId = '발급받은_IOS_APPLICATION_ID';
```

### 2. PG 일반 결제 (requestPayment)

```dart
import 'package:bootpay/bootpay.dart';
import 'package:bootpay/model/extra.dart';
import 'package:bootpay/model/item.dart';
import 'package:bootpay/model/payload.dart';
import 'package:bootpay/model/user.dart';

void bootpayTest(BuildContext context) {
  Payload payload = Payload();

  // Application ID 설정
  payload.webApplicationId = webApplicationId;
  payload.androidApplicationId = androidApplicationId;
  payload.iosApplicationId = iosApplicationId;

  // 결제 정보
  payload.pg = '스마트로';  // PG사 선택
  payload.orderName = "테스트 상품";
  payload.price = 1000.0;
  payload.orderId = DateTime.now().millisecondsSinceEpoch.toString();

  // 상품 정보
  Item item = Item();
  item.name = "상품명";
  item.qty = 1;
  item.id = "ITEM_CODE";
  item.price = 1000;
  payload.items = [item];

  // 구매자 정보
  User user = User();
  user.username = "사용자 이름";
  user.email = "user@example.com";
  user.phone = "010-1234-5678";
  user.addr = "서울시 강남구";
  payload.user = user;

  // 결제 옵션
  Extra extra = Extra();
  extra.appScheme = 'bootpayFlutterExample';  // iOS 앱스킴
  extra.cardQuota = '3';  // 할부 개월수
  payload.extra = extra;

  // 결제 요청
  Bootpay().requestPayment(
    context: context,
    payload: payload,
    showCloseButton: false,
    onCancel: (String data) {
      print('------- onCancel: $data');
    },
    onError: (String data) {
      print('------- onError: $data');
    },
    onClose: () {
      print('------- onClose');
      Bootpay().dismiss(context);
    },
    onIssued: (String data) {
      print('------- onIssued: $data');
    },
    onConfirm: (String data) {
      // 클라이언트 승인
      Bootpay().transactionConfirm();
      return false;

      // 또는 바로 승인: return true;
      // 또는 서버 승인: return false; (서버에서 승인 API 호출)
    },
    onDone: (String data) {
      print('------- onDone: $data');
    },
  );
}
```

### 3. 본인인증 (requestAuthentication)

```dart
void bootpayAuthentication(BuildContext context) {
  Payload payload = Payload();

  payload.webApplicationId = webApplicationId;
  payload.androidApplicationId = androidApplicationId;
  payload.iosApplicationId = iosApplicationId;

  payload.pg = '다날';
  payload.method = '본인인증';
  payload.orderName = "본인인증";
  payload.authenticationId = DateTime.now().millisecondsSinceEpoch.toString();

  User user = User();
  user.username = "사용자 이름";
  user.phone = "010-1234-5678";
  payload.user = user;

  Extra extra = Extra();
  extra.appScheme = 'bootpayFlutterExample';
  // extra.carrier = "SKT,KT,LGT";  // 통신사 제한
  // extra.ageLimit = 20;  // 최소 나이 제한
  payload.extra = extra;

  Bootpay().requestAuthentication(
    context: context,
    payload: payload,
    showCloseButton: false,
    onCancel: (String data) { print('onCancel: $data'); },
    onError: (String data) { print('onError: $data'); },
    onClose: () { Bootpay().dismiss(context); },
    onDone: (String data) { print('onDone: $data'); },
  );
}
```

### 4. 정기결제 빌링키 발급 (requestSubscription)

```dart
void bootpaySubscription(BuildContext context) {
  Payload payload = Payload();

  payload.webApplicationId = webApplicationId;
  payload.androidApplicationId = androidApplicationId;
  payload.iosApplicationId = iosApplicationId;

  payload.pg = '토스페이먼츠';
  payload.method = '카드자동';
  payload.orderName = "정기결제 등록";
  payload.price = 1000.0;  // 0원이면 빌링키만 발급
  payload.subscriptionId = DateTime.now().millisecondsSinceEpoch.toString();

  User user = User();
  user.username = "사용자 이름";
  user.email = "user@example.com";
  user.phone = "010-1234-5678";
  payload.user = user;

  Extra extra = Extra();
  extra.appScheme = 'bootpayFlutterExample';
  extra.subscribeTestPayment = payload.price != 0;  // 테스트 결제 여부
  payload.extra = extra;

  Bootpay().requestSubscription(
    context: context,
    payload: payload,
    showCloseButton: false,
    onCancel: (String data) { print('onCancel: $data'); },
    onError: (String data) { print('onError: $data'); },
    onClose: () { Bootpay().dismiss(context); },
    onDone: (String data) { print('onDone: $data'); },
  );
}
```

## 콜백 함수 설명

| 콜백 | 설명 |
|------|------|
| `onCancel` | 사용자가 결제를 취소한 경우 |
| `onError` | 결제 진행 중 에러 발생 |
| `onClose` | 결제창이 닫힐 때 (dismiss 호출 필요) |
| `onIssued` | 가상계좌 발급 완료 시 |
| `onConfirm` | 결제 승인 전 확인 (true: 바로 승인, false: 수동 승인) |
| `onDone` | 결제 완료 |

## iOS 설정

### Info.plist - 앱스킴 등록

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>bootpayFlutterExample</string>
    </array>
  </dict>
</array>
```

### Info.plist - 외부 앱 실행 허용

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>itms-apps</string>
  <string>kakao</string>
  <string>kakaokompassauth</string>
  <string>kakaolink</string>
  <!-- 기타 필요한 앱스킴 -->
</array>
```

## Android 설정

### AndroidManifest.xml - 인터넷 권한

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

### AndroidManifest.xml - 앱스킴 등록

```xml
<activity ...>
  <intent-filter>
    <action android:name="android.intent.action.VIEW"/>
    <category android:name="android.intent.category.DEFAULT"/>
    <category android:name="android.intent.category.BROWSABLE"/>
    <data android:scheme="bootpayFlutterExample"/>
  </intent-filter>
</activity>
```

## 웹 설정 (Web)

```dart
if (kIsWeb) {
  payload.extra?.openType = "popup";  // 또는 "iframe"
}
```

## 실행 방법

```bash
# 의존성 설치
flutter pub get

# Android
flutter run -d <android_device_id>

# iOS
cd ios && pod install && cd ..
flutter run -d <ios_device_id>

# Web
flutter run -d chrome
```

## 문서 및 지원

- [부트페이 개발매뉴얼](https://docs.bootpay.co.kr/)
- [기술문의 채팅](https://bootpay.channel.io/)

## License

[MIT License](https://opensource.org/licenses/MIT)
