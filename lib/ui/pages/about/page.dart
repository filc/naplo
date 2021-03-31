import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/pages/about/privacy.dart';
import 'package:filcnaplo/ui/pages/about/supporters/page.dart';
import 'package:filcnaplo/ui/pages/news/history.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF236A5B),
      body: Container(
        child: Stack(
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(top: 36.0, left: 12.0),
              child: IconButton(
                icon: Icon(FeatherIcons.arrowLeft, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hero Logo
                Container(
                  child: Image.asset("assets/icon.png"),
                  width: 164,
                ),
                Text(
                  "Filc Napló",
                  style: TextStyle(
                    fontSize: 32.0,
                    color: Colors.white,
                    fontFamily: "RedHatDisplay",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    app.currentAppVersion,
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 20.0,
                    ),
                  ),
                ),
                SizedBox(height: 32.0),
                AboutButton(
                  icon: FeatherIcons.lock,
                  text: I18n.of(context).aboutPrivacy,
                  onPressed: () {
                    showDialog(
                        context: context, builder: (context) => AboutPrivacy());
                  },
                ),
                AboutButton(
                  icon: FeatherIcons.award,
                  text: I18n.of(context).aboutLicenses,
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true)
                        .push(CupertinoPageRoute(
                      builder: (context) => LicensePage(
                        applicationName: "Filc Napló",
                        applicationVersion: app.currentAppVersion,
                        applicationIcon: SizedBox(
                          width: 100.0,
                          height: 100.0,
                          child: Image.asset("assets/icon.png"),
                        ),
                      ),
                    ));
                  },
                ),
                AboutButton(
                  icon: FeatherIcons.dollarSign,
                  text: I18n.of(context).aboutSupporters,
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                      CupertinoPageRoute(
                          builder: (context) => AboutSupporters()),
                    );
                  },
                ),
                AboutButton(
                  icon: FeatherIcons.mail,
                  text: capital(I18n.of(context).aboutNews),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                      CupertinoPageRoute(
                          builder: (context) => NewsHistoryView()),
                    );
                  },
                ),
                SizedBox(height: 32.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SocialButton(
                      icon: Icon(
                        FeatherIcons.github,
                        color: Colors.white,
                        size: 32.0,
                      ),
                      color: Color(0xFF24292E),
                      label: "Github",
                      onPressed: () {
                        FlutterWebBrowser.openWebPage(
                          url: "https://github.com/filcnaplo/filcnaplo",
                          customTabsOptions: CustomTabsOptions(
                            toolbarColor: app.settings.theme.backgroundColor,
                            showTitle: true,
                          ),
                          safariVCOptions: SafariViewControllerOptions(
                            dismissButtonStyle:
                                SafariViewControllerDismissButtonStyle.close,
                          ),
                        );
                      },
                    ),
                    SocialButton(
                      icon: Icon(
                        FeatherIcons.globe,
                        color: Colors.white,
                        size: 32.0,
                      ),
                      color: Color(0xFF1A4742),
                      label: "www.filcnaplo.hu",
                      onPressed: () {
                        FlutterWebBrowser.openWebPage(
                          url: "https://filcnaplo.hu/",
                          customTabsOptions: CustomTabsOptions(
                            toolbarColor: app.settings.theme.backgroundColor,
                            showTitle: true,
                          ),
                          safariVCOptions: SafariViewControllerOptions(
                            dismissButtonStyle:
                                SafariViewControllerDismissButtonStyle.close,
                          ),
                        );
                      },
                    ),
                    SocialButton(
                      icon: Icon(
                        FeatherIcons.atSign,
                        color: Colors.white,
                        size: 32.0,
                      ),
                      color: Color(0xFF7289DA),
                      label: "Discord",
                      onPressed: () {
                        FlutterWebBrowser.openWebPage(
                          url: "https://filcnaplo.hu/discord",
                          customTabsOptions: CustomTabsOptions(
                            toolbarColor: app.settings.theme.backgroundColor,
                            showTitle: true,
                          ),
                          safariVCOptions: SafariViewControllerOptions(
                            dismissButtonStyle:
                                SafariViewControllerDismissButtonStyle.close,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AboutButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function onPressed;

  AboutButton({this.text, this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250.0,
      child: MaterialButton(
        shape: StadiumBorder(),
        child: ListTile(
            leading: icon != null
                ? Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(icon, color: Colors.white))
                : Container(),
            title: Text(text,
                style: TextStyle(fontSize: 18.0, color: Colors.white))),
        onPressed: onPressed,
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final Color color;
  final Widget icon;
  final Function onPressed;
  final String label;

  SocialButton({this.color, this.icon, this.onPressed, this.label});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: SizedBox(
        width: 100.0,
        height: 64.0,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 2.0,
              )
            ],
          ),
          child: MaterialButton(
            shape: CircleBorder(),
            child: icon,
            color: color,
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
