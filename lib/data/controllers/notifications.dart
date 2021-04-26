import 'dart:math';

import 'package:filcnaplo/data/context/theme.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationChannel {
  final String id;
  final String title;
  final String description;

  const NotificationChannel(this.id, this.title, this.description);
}

class NotificationDisplay {
  int id;
  String title;
  String body;
  String payload;
  NotificationChannel channel;
  bool displayTime;

  NotificationDisplay({
    this.id = -1,
    this.title = "",
    this.body = "",
    this.payload = "",
    this.channel = const NotificationChannel(
        "default", "Default", "General notifications"),
    this.displayTime = true,
  }) {
    if (this.id == -1) {
      this.id = Random().nextInt(99999999);
    }
  }
}

class NotificationController {
  FlutterLocalNotificationsPlugin plugin;

  Future init() async {
    plugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_stat_splash_logo');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    await plugin.initialize(initializationSettings,
        onSelectNotification: (_) async {});
  }

  Future<bool> permission() async =>
      await Permission.notification.request() == PermissionStatus.granted;

  Future show(NotificationDisplay notification) async {
    var androidDetails = AndroidNotificationDetails(
      notification.channel.id,
      notification.channel.title,
      notification.channel.description,
      showWhen: notification.displayTime,
      color: ThemeContext.filcGreen,
    );
    var iosDetails = IOSNotificationDetails();
    var specs = NotificationDetails(android: androidDetails, iOS: iosDetails);
    await plugin.show(
      notification.id,
      notification.title,
      notification.body,
      specs,
      payload: notification.payload,
    );
  }
}
