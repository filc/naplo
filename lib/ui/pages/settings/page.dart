import 'package:filcnaplo/ui/pages/settings/tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo/ui/pages/settings/debug.dart';
import 'package:filcnaplo/ui/pages/settings/notification.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/ui/pages/about/page.dart';
import 'package:filcnaplo/ui/pages/settings/appearance.dart';
import 'package:filcnaplo/ui/pages/settings/general.dart';
import 'package:filcnaplo/ui/pages/settings/privacy.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              centerTitle: true,
              leading: BackButton(color: app.settings.appColor),
              title: Text(
                I18n.of(context).settingsTitle,
                //style: TextStyle(fontSize: 22.0),
              ),
              shadowColor: Colors.transparent,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),

            // Settings
            SettingTile(
                color: Colors.blueAccent,
                description: capitalize(
                  I18n.of(context).settingsGeneralLanguage +
                      ", " +
                      I18n.of(context).settingsGeneralStartPage +
                      ", " +
                      I18n.of(context).settingsGeneralRound,
                ),
                title: I18n.of(context).settingsGeneralTitle,
                icon: FeatherIcons.settings,
                page: GeneralSettings()),
            SettingTile(
                color: Colors.pinkAccent,
                description: capital(I18n.of(context).settingsAppearanceTheme) +
                    ", " +
                    capital(I18n.of(context).settingsAppearanceColor),
                title: I18n.of(context).settingsAppearanceTitle,
                icon: app.settings.theme.brightness == Brightness.light
                    ? FeatherIcons.sun
                    : FeatherIcons.moon,
                page: AppearanceSettings()),
            SettingTile(
                color: Colors.greenAccent,
                description: capital(I18n.of(context).settingsPrivacySeen),
                title: I18n.of(context).settingsPrivacyTitle,
                icon: FeatherIcons.lock,
                page: PrivacySettings()),
            SettingTile(
                color: Colors.indigoAccent,
                description:
                    capital(I18n.of(context).settingsNotificationsTitle) +
                        ", " +
                        I18n.of(context).settingsNotificationsNews,
                title: I18n.of(context).settingsNotificationsTitle,
                icon: FeatherIcons.bell,
                page: NotificationSettings()),
            SettingTile(
                color: Colors.red[400],
                description: capital(I18n.of(context).settingsDebugDelete),
                title: I18n.of(context).settingsDebugTitle,
                icon: FeatherIcons.terminal,
                page: DebugSettings()),
            SettingTile(
                color: Colors.lime,
                description: capital(I18n.of(context).aboutLinks) +
                    ", " +
                    capital(I18n.of(context).aboutLicenses) +
                    ", " +
                    capital(I18n.of(context).aboutSupporters),
                title: I18n.of(context).aboutTitle,
                icon: FeatherIcons.info,
                page: AboutPage()),
          ],
        ),
      ),
    );
  }
}
