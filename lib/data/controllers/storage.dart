import 'package:filcnaplo/data/context/app.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class StorageController {
  String appPath;
  Database storage;
  Map<String, Database> users = {};
  Future createSettingsTable(Database db) async {
    await db.execute(
        "create table settings (language TEXT, app_color TEXT, theme TEXT, background_color INTIGER, notifications INTIGER, selected_user INTIGER, render_html INTIGER, debug_mode INTIGER, default_page INTIGER)");
  }

  Future init() async {
    String databasesPath = await getDatabasesPath();
    appPath = join(databasesPath, 'app.db');
    storage = await openDatabase(appPath);
    app.appDataPath = (await getApplicationDocumentsDirectory()).path;
  }

  Future create() async {
    await destroy(appPath);

    storage = await openDatabase(
      appPath,
      version: 1,
      onCreate: (Database db, int version) async {
        // Create Users
        await db.execute("create table users (id TEXT, name TEXT)");

        // Create Settings
        createSettingsTable(db);
        await db.insert("settings", {
          "language": "auto",
          "app_color": "default",
          "theme": "light",
          "background_color": 0,
          "notifications": 1,
          "selected_user": 0,
          "render_html": 1,
          "debug_mode": 0,
          "default_page": 0
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

        // Tab States
        await db.execute(
            "create table tabs (messages INTIGER, evaluations INTIGER, absences INTIGER, timetable INTIGER)");
        await db.insert("tabs", {
          "messages": 0,
          "evaluations": 0,
          "absences": 0,
          "timetable": 0,
        });
      },
    );
  }

  Future destroy(String path) async => await deleteDatabase(path);

  Future addUser(String userID) async {
    if (userID != "debug") {
      String databasesPath = await getDatabasesPath();
      String userPath = join(databasesPath, userID + ".db");

      if (users[userID] == null) users[userID] = await openDatabase(userPath);
    }

    app.sync.addUser(userID);
    app.kretaApi.addUser(userID);
  }

  Future createUser(String userID) async {
    String databasesPath = await getDatabasesPath();
    String userPath = join(databasesPath, userID + ".db");

    await destroy(userPath);

    users[userID] = await openDatabase(
      userPath,
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
    );
  }

  Future deleteUser(String userID) async {
    users[userID] = null;
    String databasesPath = await getDatabasesPath();
    await destroy(join(databasesPath, userID + ".db"));
    await storage.delete("users", where: "id='" + userID + "'");
    if (app.debugVersion) print("DEBUG: Deleted User: " + userID);
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
