import 'package:bootpay/model/item.dart';
import 'package:bootpay/model/user.dart';
import 'package:bootpay_bio/bootpay_bio.dart';
import 'package:bootpay_bio/models/bio_extra.dart';
import 'package:bootpay_bio/models/bio_payload.dart';
import 'package:bootpay_bio/models/bio_price.dart';
import 'package:flutter/material.dart';

import 'config/bootpay_env.dart';
import 'deprecated/api_provider.dart';

class BioPayment extends StatelessWidget {
  BioPayment({super.key});

  final String webApplicationId = BootpayEnvConfig.webApplicationId;
  final String androidApplicationId = BootpayEnvConfig.androidApplicationId;
  final String iosApplicationId = BootpayEnvConfig.iosApplicationId;

  final ApiProvider _provider = ApiProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: TextButton(
            onPressed: () => goBootpayBio(context),
            child: const Text(
              '생체인증 결제 테스트',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> goBootpayBio(BuildContext context) async {
    final String userToken = await _getUserToken();
    if (!context.mounted) return;
    _bootpayBio(context, userToken);
  }

  Future<String> _getUserToken() async {
    final String restApplicationId = BootpayEnvConfig.restApplicationId;
    final String pk = BootpayEnvConfig.privateKey;

    var res = await _provider.getRestToken(restApplicationId, pk);
    res = await _provider.getEasyPayUserToken(
      res.body['access_token'],
      _generateUser(),
    );
    return res.body['user_token'];
  }

  void _bootpayBio(BuildContext context, String userToken) {
    final BioPayload payload = _getBioPayload(userToken);

    BootpayBio().requestPaymentBio(
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
        BootpayBio().dismiss(context);
      },
      onIssued: (String data) {
        print('------- onIssued: $data');
      },
      onConfirm: (String data) {
        print('------- onConfirm: $data');
        return true;
      },
      onDone: (String data) {
        print('------- onDone: $data');
      },
    );
  }

  User _generateUser() {
    final user = User();
    user.id = '12aaa2123';
    user.gender = 1;
    user.email = 'test1234@gmail.com';
    user.phone = '01012345678';
    user.birth = '19880610';
    user.username = '홍길동';
    user.area = '서울';
    return user;
  }

  BioPayload _getBioPayload(String userToken) {
    final payload = BioPayload();

    final item1 = Item()
      ..name = "미키 '마우스"
      ..qty = 1
      ..id = 'ITEM_CODE_MOUSE'
      ..price = 500;

    final item2 = Item()
      ..name = '키보드'
      ..qty = 1
      ..id = 'ITEM_CODE_KEYBOARD'
      ..price = 500;

    payload.webApplicationId = webApplicationId;
    payload.androidApplicationId = androidApplicationId;
    payload.iosApplicationId = iosApplicationId;

    payload.userToken = userToken;
    payload.pg = '나이스페이';
    payload.method = '카드간편';
    payload.orderName = '테스트 상품';
    payload.price = 1000.0;
    payload.orderId = DateTime.now().millisecondsSinceEpoch.toString();

    payload.metadata = {
      'callbackParam1': 'value12',
      'callbackParam2': 'value34',
      'callbackParam3': 'value56',
      'callbackParam4': 'value78',
    };
    payload.items = [item1, item2];

    final extra = BioExtra()
      ..appScheme = 'bootpayFlutterExample'
      ..separatelyConfirmed = true;

    payload.user = _generateUser();
    payload.extra = extra;

    payload.names = ['블랙 (COLOR)', '55 (SIZE)'];
    payload.prices = [
      BioPrice(name: '상품가격', price: 89000),
      BioPrice(name: '쿠폰적용', price: -25000),
      BioPrice(name: '배송비', price: 2500),
    ];

    return payload;
  }
}
