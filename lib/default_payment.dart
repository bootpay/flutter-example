import 'package:bootpay/bootpay.dart';
import 'config/bootpay_env.dart';
import 'package:bootpay/model/extra.dart';
import 'package:bootpay/model/item.dart';
import 'package:bootpay/model/payload.dart';
import 'package:bootpay/model/user.dart';
import 'package:flutter/material.dart';

// ignore_for_file: avoid_print

enum PaymentAuthMode { clientKey, legacyApplicationId, missingKey }

class DefaultPayment extends StatelessWidget {
  DefaultPayment({super.key});

  // You can ask Get to find a Controller that is being used by another page and redirect you to it.

  final String webApplicationId = BootpayEnvConfig.webApplicationId;
  final String androidApplicationId = BootpayEnvConfig.androidApplicationId;
  final String iosApplicationId = BootpayEnvConfig.iosApplicationId;
  final String clientKey =
      BootpayEnvConfig.clientKey; // Commerce API client_key

  @override
  Widget build(context) {
    // Access the updated count variable
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () =>
                    bootpayTest(context, PaymentAuthMode.clientKey),
                child: const Text(
                  'PG 일반 결제 테스트 (client_key)',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              TextButton(
                onPressed: () =>
                    bootpayTest(context, PaymentAuthMode.legacyApplicationId),
                child: const Text(
                  '레거시 결제 테스트 (application_id)',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              TextButton(
                onPressed: () =>
                    bootpayTest(context, PaymentAuthMode.missingKey),
                child: const Text(
                  '키 없음 테스트 (NEED_CLIENT_KEY)',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void bootpayTest(BuildContext context, PaymentAuthMode authMode) {
    Payload payload = getPayload(authMode);
    // if(kIsWeb) {
    //   payload.extra?.openType = "popup";
    // }

    payload.extra?.openType = "iframe";

    // BootpayConfig.DISPLAY_WITH_HYBRID_COMPOSITION = true;
    Bootpay().requestPayment(
      context: context,
      payload: payload,
      showCloseButton: false,
      // userAgent: "mozilla/5.0 (iphone; cpu iphone os 15_0_1 like mac os x) applewebkit/605.1.15 (khtml, like gecko) version/15.0 mobile/15e148 safari/604.1",
      // closeButton: Icon(Icons.close, size: 35.0, color: Colors.black54),
      onCancel: (String data) {
        print('------- onCancel: $data');
      },
      onError: (String data) {
        print('------- onCancel: $data');
      },
      onClose: () {
        print('------- onClose');
        Bootpay().dismiss(context); //명시적으로 부트페이 뷰 종료 호출
        //TODO - 원하시는 라우터로 페이지 이동
      },
      onIssued: (String data) {
        print('------- onIssued: $data');
      },
      onConfirm: (String data) {
        /**
            1. 바로 승인하고자 할 때
            return true;
         **/
        /***
            2. 클라이언트 승인 하고자 할 때
            Bootpay().transactionConfirm();
            return false;
         ***/
        /***
            3. 서버승인을 하고자 하실 때 (클라이언트 승인 X)
            return false; 후에 서버에서 결제승인 수행
         */
        Bootpay().transactionConfirm();
        return false;
      },
      onDone: (String data) {
        print('------- onDone: $data');
      },
    );
  }

  Payload getPayload(PaymentAuthMode authMode) {
    Payload payload = Payload();
    Item item1 = Item();
    item1.name = "미키 '마우스"; // 주문정보에 담길 상품명
    item1.qty = 1; // 해당 상품의 주문 수량
    item1.id = "ITEM_CODE_MOUSE"; // 해당 상품의 고유 키
    item1.price = 500; // 상품의 가격

    Item item2 = Item();
    item2.name = "키보드"; // 주문정보에 담길 상품명
    item2.qty = 1; // 해당 상품의 주문 수량
    item2.id = "ITEM_CODE_KEYBOARD"; // 해당 상품의 고유 키
    item2.price = 500; // 상품의 가격
    List<Item> itemList = [item1, item2];

    applyAuth(payload, authMode);

    payload.pg = '토스';
    // payload.method = "카드자동";
    payload.method = '토스';
    // payload.methods = ['card', 'phone', 'vbank', 'bank', 'kakao'];
    payload.orderName = "테스트 상품"; //결제할 상품명
    payload.price = 1000.0; //정기결제시 0 혹은 주석

    payload.orderId = DateTime.now().millisecondsSinceEpoch
        .toString(); //주문번호, 개발사에서 고유값으로 지정해야함

    payload.metadata = {
      "callbackParam1": "value12",
      "callbackParam2": "value34",
      "callbackParam3": "value56",
      "callbackParam4": "value78",
    }; // 전달할 파라미터, 결제 후 되돌려 주는 값
    payload.items = itemList; // 상품정보 배열

    User user = User(); // 구매자 정보
    user.username = "사용자 이름";
    user.email = "user1234@gmail.com";
    user.area = "서울";
    user.phone = "010-4033-4678";
    user.addr = '서울시 동작구 상도로 222';

    Extra extra = Extra(); // 결제 옵션
    extra.appScheme = 'bootpayFlutterExample';
    extra.cardQuota = '3';
    // extra.directCardCompany = "국민"; //https://docs.bootpay.co.kr/?front=web&backend=nodejs#enum-card 참조
    // extra.directCardQuota = "00"; //directCardCompany 옵션 사용시 필수값,

    // extra.carrier = "SKT,KT,LGT"; //본인인증 시 고정할 통신사명
    // extra.ageLimit = 20; // 본인인증시 제한할 최소 나이 ex) 20 -> 20살 이상만 인증이 가능

    payload.user = user;
    payload.extra = extra;
    return payload;
  }

  void applyAuth(Payload payload, PaymentAuthMode authMode) {
    switch (authMode) {
      case PaymentAuthMode.clientKey:
        payload.clientKey = clientKey; // 권장: client_key
        break;
      case PaymentAuthMode.legacyApplicationId:
        payload.webApplicationId = webApplicationId;
        payload.androidApplicationId = androidApplicationId;
        payload.iosApplicationId = iosApplicationId;
        break;
      case PaymentAuthMode.missingKey:
        // NEED_CLIENT_KEY 검증용
        break;
    }
  }
}
