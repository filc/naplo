import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/context/page.dart';

class DebugHelper {
  Future<void> eraseData(context) async {
    await Future.forEach(app.storage.users.keys, (String user) async {
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

    app.gotoPage(PageType.home);

    DynamicTheme.of(context)
        ?.setThemeData(app.theme.light(app.settings.appColor));
  }
}
