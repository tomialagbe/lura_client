import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void openLinkInNewWindow(BuildContext context, String link) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (_) => LuraWebView(url: link)));
}

class LuraWebView extends StatelessWidget {
  final String url;

  const LuraWebView({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: const CloseButton(),
      ),
      body: SafeArea(
        child: WebView(
          initialUrl: url,
        ),
      ),
    );
  }
}
