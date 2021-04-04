import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/helpers/bithelper.dart';
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
                value: app.settings.enableNotifications,
                onChanged: (bool value) {
                  setState(() {
                    app.settings.enableNotifications = value;
                  });

                  app.storage.storage.update("settings", {
                    "notifications": (app.settings.enableNotifications ? 1 : 0)
                  });
                },
              ),
            ),
            ExpansionTile(
              title: Text(I18n.of(context).settingsNotificationsCategories),
              leading: Icon(FeatherIcons.folder),
              children: [
                NotificationCategory(
                    1, I18n.of(context).settingsNotificationsGrades),
                NotificationCategory(
                    2, I18n.of(context).settingsNotificationsNotesEvents),
                NotificationCategory(
                    3, I18n.of(context).settingsNotificationsInbox),
                NotificationCategory(
                    4, I18n.of(context).settingsNotificationsLessons),
                NotificationCategory(
                    5, I18n.of(context).settingsNotificationsAbsences),
                NotificationCategory(
                    6, I18n.of(context).settingsNotificationsExamHomework),
                NotificationCategory(
                    8, I18n.of(context).settingsNotificationsPersistent),
                NotificationCategory(
                    9, I18n.of(context).settingsNotificationsNewsletter),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                I18n.of(context).notImplemented,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red[300],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationCategory extends StatefulWidget {
  final int categoryId;
  final String name;

  const NotificationCategory(this.categoryId, this.name);

  @override
  _NotificationCategoryState createState() => _NotificationCategoryState();
}

class _NotificationCategoryState extends State<NotificationCategory> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
          BitHelper.isBitSet(app.settings.notificationMask, widget.categoryId)
              ? FeatherIcons.bell
              : FeatherIcons.bellOff),
      title: Text(widget.name),
      trailing: Switch(
          activeColor: app.settings.appColor,
          value: BitHelper.isBitSet(
              app.settings.notificationMask, widget.categoryId),
          onChanged: app.settings.enableNotifications
              ? (_) {
                  setState(() {
                    app.settings.notificationMask = BitHelper.toogleSingleBit(
                        app.settings.notificationMask, widget.categoryId);
                  });
                  app.storage.storage.update("settings",
                      {"notificationMask": app.settings.notificationMask});
                  print(app.settings.notificationMask);
                }
              : null),
    );
  }
}
