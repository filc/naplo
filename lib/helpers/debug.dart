import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:filcnaplo/data/context/app.dart';

class DebugHelper {
  Future<void> eraseData(context) async {
    await Future.forEach(app.storage.users.keys, (user) async {
      try {
        await app.storage.deleteUser(user);
      } catch (error) {
        print("ERROR: storage.deleteUser: " + error.toString());
      }
    });

    await app.storage.create();
    app.users = [];
    app.debugUser = false;
    app.sync.users = {};
    app.kretaApi.users = {};
    app.settings.update();

    app.selectedPage = 0;
    app.selectedEvalPage = 0;
    app.selectedMessagePage = 0;
    app.selectedTimetablePage = 0;

    DynamicTheme.of(context)
        .setThemeData(app.theme.light(app.settings.appColor));
  }
}
