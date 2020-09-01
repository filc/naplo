import 'package:filcnaplo/data/context/theme.dart';
import 'package:filcnaplo/data/state/tab.dart';
import 'package:filcnaplo/kreta/api.dart';
import 'package:filcnaplo/data/models/user.dart';
import 'package:filcnaplo/data/controllers/settings.dart';
import 'package:filcnaplo/data/controllers/storage.dart';
import 'package:filcnaplo/data/controllers/sync.dart';
import 'package:filcnaplo/data/controllers/search.dart';

AppContext app = AppContext();

/// Globally stored runtime app data

class AppContext {
  // Change this to enable debug mode
  bool debugVersion = false;
  bool debugUser = false;
  bool firstStart = false;

  String appDataPath;

  String currentAppVersion = "unknown";
  int selectedTimetablePage = 0;
  int selectedMessagePage = 0;
  int selectedEvalPage = 0;
  int selectedPage = 0;
  int evalSortBy = 0;

  TabState tabState = TabState();
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
}
