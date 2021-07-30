import 'package:at_event/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OpenAtSignWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: kColorStyle1,
        title: Text(
          'What is The @ Company?',
          style: kNormalTextStyle,
        ),
      ),
      body: SafeArea(
        child: WebView(
          initialUrl: 'https://atsign.com/manifesto',
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
