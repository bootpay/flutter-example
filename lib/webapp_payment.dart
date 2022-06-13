import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bootpay_webview_flutter/webview_flutter.dart';

class WebAppPayment extends StatelessWidget {
  // You can ask Get to find a Controller that is being used by another page and redirect you to it.
  final Completer<WebViewController> _controller = Completer<WebViewController>();


  @override
  Widget build(context) {
    print( MediaQuery.of(context).size.width);
    // MediaQuery
    // print(MediaQuery(data: data, child: child))
    // Access the updated count variable
    return WebView(
      initialUrl: 'https://d-cdn.bootapi.com/test/payment/',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _controller.complete(webViewController);
      },
      onProgress: (int progress) {
        print("WebView is loading (progress : $progress%)");
      },
      navigationDelegate: (NavigationRequest request) {
        if (request.url.startsWith('https://www.youtube.com/')) {
          print('blocking navigation to $request}');
          return NavigationDecision.prevent;
        }
        print('allowing navigation to $request');
        return NavigationDecision.navigate;
      },
      onPageStarted: (String url) {
        print('Page started loading: $url');
      },
      onPageFinished: (String url) {
        print('Page finished loading: $url');
      },
      gestureNavigationEnabled: true,
    );
  }

}
