import 'package:flutter/material.dart';
import 'package:new_glad_driver/model/user_data_singleton.dart';
import 'package:webview_flutter/webview_flutter.dart';


class HotSpotPage extends StatefulWidget {
  const HotSpotPage({super.key});

  @override
  State<HotSpotPage> createState() => _HotSpotPageState();
}

class _HotSpotPageState extends State<HotSpotPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("即時熱點"),),
      body: WebViewFragment(),
    );
  }
}

class WebViewFragment extends StatefulWidget {
  @override
  _WebViewFragmentState createState() => _WebViewFragmentState();
}

class _WebViewFragmentState extends State<WebViewFragment> {
  WebViewController controller = WebViewController();

  final String initialUrl =
      'https://taxi-v2.web.app/appHeatMap?token=${UserDataSingleton.instance.token}';

  @override
  void initState() {
    print("initialUrl $initialUrl");
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(initialUrl));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: controller);
  }
}
