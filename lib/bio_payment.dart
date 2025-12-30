// import 'package:bootpay/bootpay.dart';
// import 'package:bootpay/model/extra.dart';
// import 'package:bootpay/model/item.dart';
// import 'package:bootpay/model/payload.dart';
// import 'package:bootpay/model/stat_item.dart';
// import 'package:bootpay/model/user.dart';
// import 'package:bootpay_bio/bootpay_bio.dart';
// import 'package:bootpay_bio/models/bio_extra.dart';
// import 'package:bootpay_bio/models/bio_payload.dart';
// import 'package:bootpay_bio/models/bio_price.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
//
// import 'deprecated/api_provider.dart';
//
// class BioPayment extends StatelessWidget {
//   // You can ask Get to find a Controller that is being used by another page and redirect you to it.
//
//   String webApplicationId = '5b8f6a4d396fa665fdc2b5e7';
//   String androidApplicationId = '5b8f6a4d396fa665fdc2b5e8';
//   String iosApplicationId = '5b8f6a4d396fa665fdc2b5e9';
//
//   @override
//   Widget build(context) {
//     // Access the updated count variable
//     return Scaffold(
//         body: SafeArea(
//             child: Center(
//                 child: TextButton(
//                     onPressed: () => goBootpayPassword(context),
//                     child: const Text('생체인증 결제 테스트', style: TextStyle(fontSize: 16.0))
//                 )
//             )
//         )
//     );
//   }
//
//   ApiProvider _provider = ApiProvider();
//   goBootpayPassword(BuildContext context) async {
//     String userToken = await getUserToken(context);
//     bootpayTest(context, userToken);
//   }
//
//   Future<String> getUserToken(BuildContext context) async {
//     String restApplicationId = "5b8f6a4d396fa665fdc2b5ea";
//     String pk = "rm6EYECr6aroQVG2ntW0A6LpWnkTgP4uQ3H18sDDUYw=";
//     var res = await _provider.getRestToken(restApplicationId, pk);
//
//
//     res = await _provider.getEasyPayUserToken(res.body['access_token'], generateUser());
//     return res.body["user_token"];
//   }
//
//   void bootpayTest(BuildContext context, String userToken) {
//
//     BioPayload payload = getBioPayload(userToken);
//
//     BootpayBio().requestPaymentBio(
//       context: context,
//       payload: payload,
//       showCloseButton: false,
//       // closeButton: Icon(Icons.close, size: 35.0, color: Colors.black54),
//       onCancel: (String data) {
//         print('------- onCancel: $data');
//       },
//       onError: (String data) {
//         print('------- onCancel: $data');
//       },
//       onClose: () {
//         print('------- onClose');
//         BootpayBio().dismiss(context); //명시적으로 부트페이 뷰 종료 호출
//         //TODO - 원하시는 라우터로 페이지 이동
//       },
//       onIssued: (String data) {
//         print('------- onIssued: $data');
//       },
//       onConfirm: (String data) {
//         print('------- onConfirm: $data');
//         /**
//             1. 바로 승인하고자 할 때
//             return true;
//          **/
//         /***
//             2. 비동기 승인 하고자 할 때
//             checkQtyFromServer(data);
//             return false;
//          ***/
//         /***
//             3. 서버승인을 하고자 하실 때 (클라이언트 승인 X)
//             return false; 후에 서버에서 결제승인 수행
//          */
//         // checkQtyFromServer(data);
//         return true;
//       },
//       onDone: (String data) {
//         print('------- onDone: $data');
//       },
//     );
//   }
//
//   User generateUser() {
//     var user = User();
//     user.id = '12aaa2123';
//     user.gender = 1;
//     user.email = 'test1234@gmail.com';
//     user.phone = '01012345678';
//     user.birth = '19880610';
//     user.username = '홍길동';
//     user.area = '서울';
//     return user;
//   }
//
//   BioPayload getBioPayload(String userToken) {
//     BioPayload payload = BioPayload();
//     Item item1 = Item();
//     item1.name = "미키 '마우스"; // 주문정보에 담길 상품명
//     item1.qty = 1; // 해당 상품의 주문 수량
//     item1.id = "ITEM_CODE_MOUSE"; // 해당 상품의 고유 키
//     item1.price = 500; // 상품의 가격
//
//     Item item2 = Item();
//     item2.name = "키보드"; // 주문정보에 담길 상품명
//     item2.qty = 1; // 해당 상품의 주문 수량
//     item2.id = "ITEM_CODE_KEYBOARD"; // 해당 상품의 고유 키
//     item2.price = 500; // 상품의 가격
//     List<Item> itemList = [item1, item2];
//
//     payload.webApplicationId = webApplicationId; // web application id
//     payload.androidApplicationId = androidApplicationId; // android application id
//     payload.iosApplicationId = iosApplicationId; // ios application id
//
//
//     payload.userToken = userToken;
//     payload.pg = '나이스페이';
//     payload.method = '카드간편';
//     // payload.methods = ['card', 'phone', 'vbank', 'bank', 'kakao'];
//     payload.orderName = "테스트 상품"; //결제할 상품명
//     payload.price = 1000.0; //정기결제시 0 혹은 주석
//
//
//     payload.orderId = DateTime.now().millisecondsSinceEpoch.toString(); //주문번호, 개발사에서 고유값으로 지정해야함
//
//
//     payload.metadata = {
//       "callbackParam1" : "value12",
//       "callbackParam2" : "value34",
//       "callbackParam3" : "value56",
//       "callbackParam4" : "value78",
//     }; // 전달할 파라미터, 결제 후 되돌려 주는 값
//     payload.items = itemList; // 상품정보 배열
//     // payload.it
//
//
//     BioExtra extra = BioExtra(); // 결제 옵션
//     extra.appScheme = 'bootpayFlutterExample';
//     extra.separatelyConfirmed = true;
//     // extra.cardQuota = '3';
//     // extra.openType = 'popup';
//
//     // extra.carrier = "SKT,KT,LGT"; //본인인증 시 고정할 통신사명
//     // extra.ageLimit = 20; // 본인인증시 제한할 최소 나이 ex) 20 -> 20살 이상만 인증이 가능
//
//     payload.user = generateUser();
//     payload.extra = extra;
//
//     payload.names = ["블랙 (COLOR)", "55 (SIZE)"];
//     payload.prices = [
//       BioPrice(name: '상품가격', price: 89000),
//       BioPrice(name: '쿠폰적용', price: -25000),
//       BioPrice(name: '배송비', price: 2500),
//     ];
//
//     return payload;
//   }
// }
