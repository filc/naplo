import 'package:filcnaplo/data/models/absence.dart';
import 'package:filcnaplo/data/models/homework.dart';
import 'package:filcnaplo/data/models/lesson.dart';
import 'package:filcnaplo/data/models/exam.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/controllers/sync.dart';
import 'package:filcnaplo/data/models/evaluation.dart';
import 'package:filcnaplo/data/models/note.dart';
import 'package:filcnaplo/data/models/event.dart';
import 'package:filcnaplo/data/models/message.dart';
import 'package:filcnaplo/data/models/student.dart';
import 'package:filcnaplo/data/context/theme.dart';
import 'package:filcnaplo/data/models/user.dart';
import 'package:filcnaplo/ui/profile_icon.dart';
import 'package:sqflite/sqflite.dart';

import 'package:filcnaplo/modules/now/period.dart';
class SettingsController {
  String language;
  String deviceLanguage;
  ThemeData theme;
  Color appColor;
  int backgroundColor;
  bool enableNotifications;
  bool renderHtml;
  int defaultPage;
  int eveningStartHour;
  Set<Period> studyingPeriods = Set();
  get locale {
    List<String> lang = (language == "auto"
            ? deviceLanguage != null ? deviceLanguage : "hu_HU"
            : language)
        .split("_");
    return Locale(lang[0], lang[1]);
  }

  Color colorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  Future update({bool login = true, Map<String, dynamic> settings}) async {
    settings = settings ?? (await app.storage.storage.query("settings"))[0];
    language = settings["language"];
    appColor = ThemeContext.colors[settings["app_color"]];
    backgroundColor = settings["background_color"];

    eveningStartHour = settings["evening_start_hour"];
    
    int studyingPeriodsBitfield = settings["studying_periods_bitfield"];
    for (int i = 0; i < Period.values.length; i++) {
      if ((studyingPeriodsBitfield & (1 << i)) > 0) {
        studyingPeriods.add(Period.values[i]);
      }
    }

    defaultPage = settings["default_page"];
    theme = {
      "light": ThemeContext().light(app.settings.appColor),
      "tinted": ThemeContext().tinted(),
      "dark": ThemeContext()
          .dark(app.settings.appColor, app.settings.backgroundColor)
    }[settings["theme"]];
    app.debugMode = settings["debug_mode"] == 1;

    List evalColorsI = await app.storage.storage.query("eval_colors");

    app.theme.evalColors[0] = colorFromHex(evalColorsI[0]["color1"]);
    app.theme.evalColors[1] = colorFromHex(evalColorsI[0]["color2"]);
    app.theme.evalColors[2] = colorFromHex(evalColorsI[0]["color3"]);
    app.theme.evalColors[3] = colorFromHex(evalColorsI[0]["color4"]);
    app.theme.evalColors[4] = colorFromHex(evalColorsI[0]["color5"]);

    enableNotifications = settings["notifications"] == 1;
    renderHtml = settings["render_html"] == 1;

    List usersInstance = await app.storage.storage.query("users");

    if (app.debugMode)
      print("Loading " + usersInstance.length.toString() + " users");

    for (int i = 0; i < usersInstance.length; i++) {
      Map instance = usersInstance[i];

      if (instance["id"].isNotEmpty && instance["name"].isNotEmpty) {
        await app.storage.addUser(instance["id"]);

        List kretaInstance;

        try {
          kretaInstance =
              await app.storage.users[instance["id"]].query("kreta");
        } catch (error) {
          print("ERROR: SettingsController.update: " + error.toString());
          await app.storage.deleteUser(instance["id"]);
          app.storage.users.remove(instance["id"]);
          continue;
        }

        User user = User(
          instance["id"],
          kretaInstance[0]["username"],
          kretaInstance[0]["password"],
          kretaInstance[0]["institute_code"],
        );

        user.name = instance["name"];
        user.realName = instance["name"];

        if (!app.users.map((e) => e.id).toList().contains(user.id))
          app.users.add(user);

        await loadData(user);

        if (app.debugMode)
          print("DEBUG: User loaded " + user.name + "<" + user.id + ">");
      }
    }

    if (login && !app.debugUser) {
      await Future.forEach(
        app.users.where((user) => user.loginState == false),
        (user) async {
          await apiLogin(user);
        },
      );
    }

    print("INFO: Updated local settings");
  }
}

Future apiLogin(User user) async {
  if (!app.debugUser) {
    if (await app.kretaApi.users[user.id].login(user))
      app.users.firstWhere((search) => search.id == user.id).loginState = true;
    else
      app.users.firstWhere((search) => search.id == user.id).loginState = false;
  } else {
    app.users.firstWhere((search) => search.id == user.id).loginState = true;
  }
}

Future loadData(User user) async {
  Database userStorage = app.storage.users[user.id];
  User globalUser = app.users.firstWhere((search) => search.id == user.id);
  SyncUser globalSync = app.sync.users[user.id];

  List student = await userStorage.query("student");
  List settings = await userStorage.query("settings");

  if (settings[0]["nickname"] != "") globalUser.name = settings[0]["nickname"];

  globalUser.customProfileIcon = settings[0]["custom_profile_icon"];
  if (globalUser.customProfileIcon != null &&
      globalUser.customProfileIcon != "") {
    if (app.debugMode)
      print("DEBUG: User profileIcon: " + globalUser.customProfileIcon);

    globalUser.profileIcon = ProfileIcon(
        name: globalUser.name, size: 0.7, image: globalUser.customProfileIcon);
  } else {
    globalUser.profileIcon = ProfileIcon(name: globalUser.name, size: 0.7);
  }

  if (student.length > 0) {
    globalSync.student.data = Student.fromJson(jsonDecode(student[0]["json"]));
  }

  List evaluations = await userStorage.query("evaluations");

  globalSync.evaluation.data = [[], []];
  globalSync.evaluation.data[0] = <Evaluation>[];

  evaluations.forEach((evaluation) {
    globalSync.evaluation.data[0]
        .add(Evaluation.fromJson(jsonDecode(evaluation["json"])));
  });

  List notes = await userStorage.query("kreta_notes");

  globalSync.note.data = [];
  notes.forEach((note) {
    globalSync.note.data.add(Note.fromJson(jsonDecode(note["json"])));
  });

  List events = await userStorage.query("kreta_events");

  globalSync.event.data = [];
  events.forEach((event) {
    globalSync.event.data.add(Event.fromJson(jsonDecode(event["json"])));
  });

  List messagesInbox = await userStorage.query("messages_inbox");

  globalSync.messages.received = [];
  messagesInbox.forEach((message) {
    globalSync.messages.received
        .add(Message.fromJson(jsonDecode(message["json"])));
  });

  List messagesSent = await userStorage.query("messages_sent");

  globalSync.messages.sent = [];
  messagesSent.forEach((message) {
    globalSync.messages.sent
        .add(Message.fromJson(jsonDecode(message["json"])));
  });

  List messagesDraft = await userStorage.query("messages_draft");

  globalSync.messages.received = [];
  messagesDraft.forEach((message) {
    globalSync.messages.received
        .add(Message.fromJson(jsonDecode(message["json"])));
  });

  List messagesTrash = await userStorage.query("messages_trash");

  globalSync.messages.archived = [];
  messagesTrash.forEach((message) {
    globalSync.messages.archived
        .add(Message.fromJson(jsonDecode(message["json"])));
  });

  List absences = await userStorage.query("kreta_absences");

  globalSync.absence.data = [];
  absences.forEach((absence) {
    globalSync.absence.data.add(Absence.fromJson(jsonDecode(absence["json"])));
  });

  List exams = await userStorage.query("kreta_exams");

  globalSync.exam.data = [];
  exams.forEach((exam) {
    globalSync.exam.data.add(Exam.fromJson(jsonDecode(exam["json"])));
  });

  List homeworks = await userStorage.query("kreta_homeworks");

  globalSync.homework.data = [];
  homeworks.forEach((homework) {
    globalSync.homework.data
        .add(Homework.fromJson(jsonDecode(homework["json"])));
  });

  List lessons = await userStorage.query("kreta_lessons");

  globalSync.timetable.data = [];
  lessons.forEach((lesson) {
    globalSync.timetable.data.add(Lesson.fromJson(jsonDecode(lesson["json"])));
  });
}
