import 'dart:io';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:math';

class NotificationController {
  FlutterLocalNotificationsPlugin _plugin;
  Future onTap(String payload) async {
    print(payload);
  }

  Future<bool> iosRequestPermission() async {
    return await _plugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            ) ??
        false;
  }

  Future init() async {
    _plugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_stat_splash_logo');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    await _plugin.initialize(initializationSettings,
        onSelectNotification: onTap);

    final bool result = await iosRequestPermission();
    if (!result && Platform.isIOS) {
      // turn off notifications
    }
  }

  Future<int> show({
    String title,
    String body,
    bool autoCancel = true,
    String payload = "",
    int id,
    DateTime date,
  }) async {
    if (Platform.isIOS) {
      title = escapeHtml(title);
      body = escapeHtml(body);
    }

    if (date == null) date = DateTime.now();

    if (id == null) {
      var random = Random();
      random.nextInt(10000000);
    }

    var androidSettings = AndroidNotificationDetails(
      '0',
      'Notifications',
      '',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      showWhen: true,
      when: date.millisecondsSinceEpoch,
      color: Colors.teal,
      styleInformation: DefaultStyleInformation(true, true),
      autoCancel: autoCancel,
    );

    var iosSettings = IOSNotificationDetails();

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidSettings, iOS: iosSettings);

    await _plugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );

    return id;
  }
}
