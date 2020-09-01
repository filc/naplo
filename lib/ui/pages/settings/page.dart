import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo/ui/pages/settings/debug.dart';
import 'package:filcnaplo/ui/pages/settings/notification.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/ui/pages/about/page.dart';
import 'package:filcnaplo/ui/pages/settings/appearance.dart';
import 'package:filcnaplo/ui/pages/settings/general.dart';
import 'package:filcnaplo/ui/pages/settings/privacy.dart';
import 'package:tinycolor/tinycolor.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AppBar(
              centerTitle: true,
              leading: BackButton(),
              title: Text(I18n.of(context).settingsTitle),
              shadowColor: Colors.transparent,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),

            // Settings
            SettingTile(
                color: Colors.blue,
                description: capital(I18n.of(context).settingsGeneralLanguage),
                title: I18n.of(context).settingsGeneralTitle,
                icon: FeatherIcons.settings,
                page: GeneralSettings()),
            SettingTile(
                color: Colors.pink,
                description: capital(I18n.of(context).settingsAppearanceTheme) +
                    ", " +
                    capital(I18n.of(context).settingsAppearanceColor),
                title: I18n.of(context).settingsAppearanceTitle,
                icon: app.settings.theme.brightness == Brightness.light
                    ? FeatherIcons.sun
                    : FeatherIcons.moon,
                page: AppearanceSettings()),
            SettingTile(
                color: Colors.green,
                description: capital(I18n.of(context).settingsPrivacySeen),
                title: I18n.of(context).settingsPrivacyTitle,
                icon: FeatherIcons.lock,
                page: PrivacySettings()),
            SettingTile(
                color: Colors.indigo[400],
                description:
                    capital(I18n.of(context).settingsNotificationsTitle),
                title: I18n.of(context).settingsNotificationsTitle,
                icon: FeatherIcons.bell,
                page: NotificationSettings()),
            SettingTile(
                color: Colors.red,
                description: capital(I18n.of(context).settingsDebugDelete),
                title: I18n.of(context).settingsDebugTitle,
                icon: FeatherIcons.terminal,
                page: DebugSettings()),
            SettingTile(
                color: Colors.yellow,
                description: capital(I18n.of(context).aboutLinks) +
                    ", " +
                    capital(I18n.of(context).aboutLicenses) +
                    ", " +
                    capital(I18n.of(context).aboutSupporters),
                title: I18n.of(context).aboutTitle,
                icon: FeatherIcons.info,
                page: AboutPage()),

            // Spacer(),
            // Container(
            //   padding: EdgeInsets.fromLTRB(16, 0, 8, 4),
            //   child: Row(
            //     children: <Widget>[
            //       Text(
            //         "Filc Napló " + app.currentAppVersion,
            //         style: TextStyle(fontSize: 16.0),
            //       ),
            //       Spacer(),
            //       IconButton(
            //         icon: Icon(FeatherIcons.info, color: app.settings.appColor),
            //         onPressed: () {
            //           Navigator.push(context,
            //               MaterialPageRoute(builder: (context) => AboutPage()));
            //         },
            //       )
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

class SettingTile extends StatelessWidget {
  final String title;
  final String description;
  final Color color;
  final IconData icon;
  final Widget page;

  SettingTile({this.title, this.icon, this.page, this.color, this.description});

  @override
  Widget build(BuildContext context) {
    dynamic accentColor = TinyColor(color).spin(-20).saturate(100);

    if (Theme.of(context).brightness == Brightness.light) {
      accentColor = accentColor.darken(10);
    }

    accentColor = accentColor.color;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.0),
      child: FlatButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: ListTile(
            contentPadding: EdgeInsets.only(left: 0.0),
            title: Text(capital(title)),
            leading: Container(
              height: 45.0,
              width: 45.0,
              decoration: BoxDecoration(
                color: Color.fromARGB(
                  Theme.of(context).brightness == Brightness.light ? 60 : 30,
                  accentColor.red,
                  accentColor.green,
                  accentColor.blue,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accentColor),
            ),
            subtitle: Text(description)),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));
        },
      ),
    );
  }
}
