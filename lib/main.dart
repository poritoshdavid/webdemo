import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  PullToRefreshController? pullToRefreshController;
  InAppWebViewController? webViewController;
  String url = "https://centerastera.si";

  @override
  void initState() {

    super.initState();
    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
      onRefresh: () async {
        if (defaultTargetPlatform == TargetPlatform.android) {
          webViewController?.reload();
        } else if (defaultTargetPlatform == TargetPlatform.iOS) {
          webViewController?.loadUrl(
              urlRequest:
              URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(top:MediaQuery.of(context).size.height*0.01),
      child: InAppWebView(

        initialUrlRequest: URLRequest(url: Uri.parse(url)),
          pullToRefreshController: pullToRefreshController,
          onWebViewCreated: (InAppWebViewController controller) {
            webViewController = controller;
          },
        onLoadStop: (controller, url) {
          pullToRefreshController?.endRefreshing();
        },
        onProgressChanged: (controller, progress) {
          if (progress == 100) {
            pullToRefreshController?.endRefreshing();
          }
        },
      ),
    );
  }
}
