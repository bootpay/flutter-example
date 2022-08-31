import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pg_test_flutter/authentication_payment.dart';
import 'package:pg_test_flutter/password_payment.dart';
import 'package:pg_test_flutter/password_web_payment.dart';
import 'package:pg_test_flutter/subscription_payment.dart';
import 'package:pg_test_flutter/total_payment.dart';
import 'package:pg_test_flutter/webapp_payment.dart';

import 'bio_payment.dart';
import 'default_payment.dart';
import 'subscription_bootpay_payment.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '부트페이 결제 데모 프로젝트'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0),
          child: Column(
            children: [
              TextButton(
                  onPressed: () => Get.to(DefaultPayment()),
                  child: const Text('1. PG일반 결제 테스트', style: TextStyle(fontSize: 16.0))
              ),
              TextButton(
                  onPressed: () => Get.to(TotalPayment()),
                  child: const Text('2. 통합결제 테스트', style: TextStyle(fontSize: 16.0))
              ),
              TextButton(
                  onPressed: () => Get.to(SubscriptionPayment()),
                  child: const Text('3. 카드자동 결제 테스트(인증)', style: TextStyle(fontSize: 16.0))
              ),
              TextButton(
                  onPressed: () => Get.to(SubscriptionBootpayPayment()),
                  child: const Text('4. 카드자동 결제 테스트 (비인증)', style: TextStyle(fontSize: 16.0))
              ),
              TextButton(
                  onPressed: () => Get.to(AuthenticationPayment()),
                  child: const Text('5. 본인인증 테스트', style: TextStyle(fontSize: 16.0))
              ),
              TextButton(
                  onPressed: () => Get.to(BioPayment()),
                  child: const Text('6. 생체인증 결제 테스트', style: TextStyle(fontSize: 16.0))
              ),
              TextButton(
                  onPressed: () => Get.to(PasswordPayment()),
                  child: const Text('7. 비밀번호 결제 테스트', style: TextStyle(fontSize: 16.0))
              ),
              // TextButton(
              //     onPressed: () => Get.to(PasswordWebPayment()),
              //     child: const Text('7. 비밀번호 결제 테스트 - BootpayUI', style: TextStyle(fontSize: 16.0))
              // ),
              TextButton(
                  onPressed: () => Get.to(WebAppPayment()),
                  child: const Text('8. 웹앱으로 연동하기', style: TextStyle(fontSize: 16.0))
              ),
            ],
          ),
        ),
      ),
    );
  }
}
