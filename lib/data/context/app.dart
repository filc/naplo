import 'package:filcnaplo/data/context/page.dart';
import 'package:filcnaplo/data/context/theme.dart';
import 'package:filcnaplo/kreta/api.dart';
import 'package:filcnaplo/data/models/user.dart';
import 'package:filcnaplo/data/controllers/settings.dart';
import 'package:filcnaplo/data/controllers/storage.dart';
import 'package:filcnaplo/data/controllers/sync.dart';
import 'package:filcnaplo/data/controllers/search.dart';
import 'package:flutter/cupertino.dart';

AppContext app = AppContext();

/// Globally stored runtime app data

class AppContext {
  // Change this to enable debug mode
  bool debugMode = false;
  bool debugUser = false;
  bool firstStart = false;

  String appDataPath;
  final GlobalKey<NavigatorState> frame = GlobalKey<NavigatorState>();

  String currentAppVersion = "unknown";
  String platform = "unknown";

  ThemeContext theme = ThemeContext();

  // Users
  List<User> users = [];
  int selectedUser = 0;
  CurrentUser get user {
    try {
      return CurrentUser(
        app.kretaApi.users[users[selectedUser].id],
        app.storage.users[users[selectedUser].id],
        app.sync.users[users[selectedUser].id],
      );
    } catch (error) {
      if (debugMode)
        print("[ERROR] data.context.app.AppContext: " + error.toString());
      return null;
    }
  }

  // Kreta API
  final KretaAPI kretaApi = KretaAPI();

  // Controllers
  final SettingsController settings = SettingsController();
  final StorageController storage = StorageController();
  final SyncController sync = SyncController();
  final SearchController search = SearchController();

  PageContext _pageContext = PageContext();

  void gotoPage(PageType page, {PageContext pageContext}) {
    if (pageContext != null)
      _pageContext = pageContext;
    else
      _pageContext = PageContext();

    switch (page) {
      case PageType.home:
        frame.currentState.pushReplacementNamed("home");
        break;
      case PageType.evaluations:
        frame.currentState.pushReplacementNamed("evaluations");
        break;
      case PageType.planner:
        frame.currentState.pushReplacementNamed("planner");
        break;
      case PageType.messages:
        frame.currentState.pushReplacementNamed("messages");
        break;
      case PageType.absences:
        frame.currentState.pushReplacementNamed("absences");
        break;
    }
  }

  PageContext get pageContext => _pageContext;
}
