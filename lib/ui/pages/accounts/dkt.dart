import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/user.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DKTPage extends StatelessWidget {
  final User user;

  DKTPage(this.user);

  @override
  Widget build(BuildContext context) {
    CookieManager().clearCookies();
    
    return Scaffold(
      body: SafeArea(
        child: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: "https://dkttanulo.e-kreta.hu/",
        ),
      ),
    );
  }
}
