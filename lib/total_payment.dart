import 'package:bootpay/bootpay.dart';
import 'package:bootpay/model/extra.dart';
import 'package:bootpay/model/item.dart';
import 'package:bootpay/model/payload.dart';
import 'package:bootpay/model/stat_item.dart';
import 'package:bootpay/model/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TotalPayment extends StatelessWidget {
  // You can ask Get to find a Controller that is being used by another page and redirect you to it.

  String webApplicationId = '5b8f6a4d396fa665fdc2b5e7';
  String androidApplicationId = '5b8f6a4d396fa665fdc2b5e8';
  String iosApplicationId = '5b8f6a4d396fa665fdc2b5e9';

  // String webApplicationId = '620513e2e38c30002515ea4d';
  // String androidApplicationId = '620513e2e38c30002515ea4e';
  // String iosApplicationId = '620513e2e38c30002515ea4f';

  @override
  Widget build(context) {
    // Access the updated count variable
    return Scaffold(
        body: SafeArea(
            child: Center(
                child: TextButton(
                    onPressed: () => bootpayTest(context),
                    child: const Text('통합결제 테스트', style: TextStyle(fontSize: 16.0))
                )
            )
        )
    );
  }

  void bootpayTest(BuildContext context) {

    Payload payload = getPayload();
    if(kIsWeb) {
      payload.extra?.openType = "iframe";
    }

    Bootpay().requestPayment(
      context: context,
      payload: payload,
      showCloseButton: false,
      // closeButton: Icon(Icons.close, size: 35.0, color: Colors.black54),
      onCancel: (String data) {
        print('------- onCancel: $data');
      },
      onError: (String data) {
        print('------- onError: $data');
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
        print('------- onConfirm: $data');
        /**
            1. 바로 승인하고자 할 때
            return true;
         **/
        /***
            2. 비동기 승인 하고자 할 때
            checkQtyFromServer(data);
            return false;
         ***/
        /***
            3. 서버승인을 하고자 하실 때 (클라이언트 승인 X)
            return false; 후에 서버에서 결제승인 수행
         */
        // checkQtyFromServer(data);
        return true;
      },
      onDone: (String data) {
        print('------- onDone: $data');
      },
    );
  }

  Payload getPayload() {
    Payload payload = Payload();
    Item item1 = Item();
    item1.name = "바나나(과테말라) 1송이(1.2Kg)"; // 주문정보에 담길 상품명
    item1.qty = 1; // 해당 상품의 주문 수량
    item1.id = "바나나-치키타"; // 해당 상품의 고유 키
    item1.price = 2900; // 상품의 가격
    item1.cat1 = '과일'; // 상품의 가격

    // Item item2 = Item();
    // item2.name = "키보드"; // 주문정보에 담길 상품명
    // item2.qty = 1; // 해당 상품의 주문 수량
    // item2.id = "ITEM_CODE_KEYBOARD"; // 해당 상품의 고유 키
    // item2.price = 500; // 상품의 가격
    List<Item> itemList = [item1];

    payload.webApplicationId = webApplicationId; // web application id
    payload.androidApplicationId = androidApplicationId; // android application id
    payload.iosApplicationId = iosApplicationId; // ios application id


    payload.pg = '나이스페이';
    // payload.method = '카드';
    payload.methods = ['card', 'phone', 'vbank', 'bank', 'kakao', 'npay'];
    payload.orderName = "바나나(과테말라) 1송이(1.2Kg)"; //결제할 상품명
    payload.price = 2900.0; //정기결제시 0 혹은 주석



    payload.orderId = "a9d1b5c626c057c76682c2c03445f19d3634b5a74bf8fb5cf816ad37eb29e5ca.4469490dd1a9062c83f55129054ed763";


    // payload.metadata = {
    //   "callbackParam1" : "value12",
    //   "callbackParam2" : "value34",
    //   "callbackParam3" : "value56",
    //   "callbackParam4" : "value78",
    // }; // 전달할 파라미터, 결제 후 되돌려 주는 값
    payload.items = itemList; // 상품정보 배열

    User user = User(); // 구매자 정보
    user.username = "맥북";
    // user.email = "user1234@gmail.com";
    // user.area = "서울";
    user.phone = "00011112222";
    // user.addr = '서울시 동작구 상도로 222';

    Extra extra = Extra(); // 결제 옵션
    extra.appScheme = 'bootpayFlutterExample';
    extra.cardQuota = '3';
    // extra.openType = 'popup';

    // extra.carrier = "SKT,KT,LGT"; //본인인증 시 고정할 통신사명
    // extra.ageLimit = 20; // 본인인증시 제한할 최소 나이 ex) 20 -> 20살 이상만 인증이 가능

    payload.user = user;
    payload.extra = extra;
    return payload;
  }
}
