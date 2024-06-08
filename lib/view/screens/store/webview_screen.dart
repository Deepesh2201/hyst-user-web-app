import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {
  final String? title;
  final String? url;

  // Define a constructor that accepts the title and URL as parameters
  const WebViewScreen({Key? key, this.title, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 32.0), // Adjust the top margin as needed
        child: WebView(
          initialUrl: url ?? 'https://backend.hyst.uk', // Use the provided URL or a default value
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
