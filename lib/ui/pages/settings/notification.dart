import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:flutter/material.dart';

class NotificationSettings extends StatefulWidget {
  @override
  _NotificationSettingsState createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            AppBar(
              centerTitle: true,
              leading: BackButton(color: app.settings.appColor),
              title: Text(I18n.of(context).settingsNotificationsTitle),
              shadowColor: Colors.transparent,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            ListTile(
              leading: Icon(FeatherIcons.mail),
              title: Text(I18n.of(context).settingsNotificationsNews),
              trailing: Switch(
                activeColor: app.settings.appColor,
                value: app.settings.enableNews,
                onChanged: (bool value) {
                  setState(() {
                    app.settings.enableNews = value;
                  });

                  app.storage.storage.update("settings",
                      {"news_show": (app.settings.enableNews ? 1 : 0)});
                },
              ),
            ),
            ListTile(
              leading: Icon(app.settings.enableNotifications
                  ? FeatherIcons.bell
                  : FeatherIcons.bellOff),
              title: Text(I18n.of(context).settingsNotificationsTitle),
              trailing: Switch(
                activeColor: app.settings.appColor,
                value: false,
                onChanged: null, //Sorry for potential conflicts :))
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                I18n.of(context).settingsNotImplemented,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),

            // todo: Notification categories
          ],
        ),
      ),
    );
  }
}
