import 'dart:convert';

import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class StorageController {
  String appPath;
  Database storage;
  Map<String, Database> users = {};
  DatabaseFactory dbffi;
  Future createSettingsTable(Database db) async {
    await db.execute(
        "create table settings (language TEXT, app_color TEXT, theme TEXT, background_color INTIGER, notifications INTIGER, selected_user INTIGER, render_html INTIGER, debug_mode INTIGER, default_page INTIGER, news_show INTIGER, news_len INTIGER, config TEXT, round_up INTIGER, pre_updates INTIGER)");
  }

  Future init() async {
    sqfliteFfiInit();
    dbffi = databaseFactoryFfi;

    String databasesPath = await dbffi.getDatabasesPath();
    appPath = join(databasesPath, 'app.db');
    storage = await dbffi.openDatabase(appPath);
    app.appDataPath = (await getApplicationDocumentsDirectory()).path;
  }

  Future create() async {
    await destroy(appPath);

    storage = await dbffi.openDatabase(
      appPath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (Database db, int version) async {
          // Create Users
          await db.execute("create table users (id TEXT, name TEXT)");

          // Create Settings
          createSettingsTable(db);
          await db.insert("settings", {
            "language": "auto",
            "app_color": "default",
            "theme": SchedulerBinding.instance.window.platformBrightness ==
                    Brightness.dark
                ? 'dark'
                : 'light',
            "background_color": 1,
            "notifications": 1,
            "selected_user": 0,
            "render_html": 0,
            "debug_mode": 0,
            "default_page": 0,
            "news_show": 1,
            "news_len": 0,
            "config": jsonEncode(Config.defaults.json),
            "round_up": 5,
            "pre_updates": 0,
          });

          // Create Eval Colors
          await db.execute(
              "create table eval_colors (color1 TEXT, color2 TEXT, color3 TEXT, color4 TEXT, color5 TEXT)");
          await db.insert("eval_colors", {
            "color1": "#f44336",
            "color2": "#ffa000",
            "color3": "#fdd835",
            "color4": "#8bc34a",
            "color5": "#43a047",
          });
        },
      ),
    );
  }

  Future destroy(String path) async => await dbffi.deleteDatabase(path);

  Future addUser(String userID) async {
    if (userID != "debug") {
      String databasesPath = await dbffi.getDatabasesPath();
      String userPath = join(databasesPath, userID + ".db");

      if (users[userID] == null)
        users[userID] = await dbffi.openDatabase(userPath);
    }

    app.sync.addUser(userID);
    app.kretaApi.addUser(userID);
  }

  Future createUser(String userID) async {
    String databasesPath = await dbffi.getDatabasesPath();
    String userPath = join(databasesPath, userID + ".db");

    await destroy(userPath);

    users[userID] = await dbffi.openDatabase(
      userPath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(
              "create table settings (custom_profile_icon TEXT, nickname TEXT)");
          await db.insert("settings", {
            "custom_profile_icon": "",
            "nickname": "",
          });

          // Create Kreta details
          await db.execute(
              "create table kreta (username TEXT, password TEXT, institute_code TEXT)");
          await db.insert("kreta", {
            "username": "",
            "password": "",
            "institute_code": "",
          });

          // Create Offline Storage
          await db.execute("create table student (json TEXT)");
          await db.execute("create table evaluations (json TEXT)");
          await db.execute("create table messages_inbox (json TEXT)");
          await db.execute("create table messages_sent (json TEXT)");
          await db.execute("create table messages_trash (json TEXT)");
          await db.execute("create table messages_draft (json TEXT)");
          await db.execute("create table kreta_notes (json TEXT)");
          await db.execute("create table kreta_events (json TEXT)");
          await db.execute("create table kreta_absences (json TEXT)");
          await db.execute("create table kreta_exams (json TEXT)");
          await db.execute("create table kreta_homeworks (json TEXT)");
          await db.execute("create table kreta_lessons (json TEXT)");
        },
      ),
    );
  }

  Future deleteUser(String userID) async {
    users[userID] = null;
    String databasesPath = await dbffi.getDatabasesPath();
    await destroy(join(databasesPath, userID + ".db"));
    await storage.delete("users", where: "id='" + userID + "'");
    if (app.debugMode) print("DEBUG: Deleted User: " + userID);
  }

  static Future<bool> writeFile(String path, List<int> data) async {
    try {
      if (await Permission.storage.request().isGranted) {
        await File(path).writeAsBytes(data);
        return true;
      } else {
        if (await Permission.storage.isPermanentlyDenied) {
          openAppSettings();
        }
        return false;
      }
    } catch (error) {
      print("ERROR: writeFile: " + error.toString());
      return false;
    }
  }
}
