import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Bootpay 환경 설정
///
/// 키는 모두 `.env` 에서 주입 — committed `.env` 가 단일 출처.
/// `BOOTPAY_ENV=development|production` 로 환경 토글 (기본 production).
class BootpayEnvConfig {
  static String _envOrEmpty(String key) {
    try {
      final value = (dotenv.maybeGet(key) ?? '').trim();
      if (value.isEmpty ||
          value == 'undefined' ||
          value == 'null' ||
          (value.startsWith(r'$(') && value.endsWith(')'))) {
        return '';
      }
      return value;
    } catch (_) {
      return '';
    }
  }

  static String get env {
    final value = _envOrEmpty('BOOTPAY_ENV');
    return value == 'development' ? 'development' : 'production';
  }

  static bool get isDevelopment => env == 'development';

  static String _resolve(String devKey, String prodKey) =>
      _envOrEmpty(isDevelopment ? devKey : prodKey);

  static String get webApplicationId => _resolve(
        'BOOTPAY_WEB_APPLICATION_ID_DEV',
        'BOOTPAY_WEB_APPLICATION_ID_PROD',
      );

  static String get androidApplicationId => _resolve(
        'BOOTPAY_ANDROID_APPLICATION_ID_DEV',
        'BOOTPAY_ANDROID_APPLICATION_ID_PROD',
      );

  static String get iosApplicationId => _resolve(
        'BOOTPAY_IOS_APPLICATION_ID_DEV',
        'BOOTPAY_IOS_APPLICATION_ID_PROD',
      );

  static String get restApplicationId => _resolve(
        'BOOTPAY_REST_APPLICATION_ID_DEV',
        'BOOTPAY_REST_APPLICATION_ID_PROD',
      );

  static String get serverKey => _resolve(
        'BOOTPAY_SERVER_KEY_DEV',
        'BOOTPAY_SERVER_KEY_PROD',
      );

  /// Legacy alias. 기존 예제/사용자 코드 호환을 위해 유지합니다.
  static String get privateKey => _resolve(
        'BOOTPAY_PRIVATE_KEY_DEV',
        'BOOTPAY_PRIVATE_KEY_PROD',
      );

  static String get clientKey => _resolve(
        'BOOTPAY_CLIENT_KEY_DEV',
        'BOOTPAY_CLIENT_KEY_PROD',
      );

  // ===== UI 환경 토글용 명시 게터 (특정 example 화면이 dev/prod 둘 다 직접 참조해야 할 때) =====
  static String get devClientKey => _envOrEmpty('BOOTPAY_CLIENT_KEY_DEV');

  static String get prodClientKey => _envOrEmpty('BOOTPAY_CLIENT_KEY_PROD');
}
