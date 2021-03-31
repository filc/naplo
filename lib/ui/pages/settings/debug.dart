import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/helpers/debug.dart';
import 'package:filcnaplo/modules/printing/main.dart';
import 'package:filcnaplo/ui/common/custom_snackbar.dart';
import 'package:filcnaplo/ui/common/label.dart';
import 'package:filcnaplo/ui/pages/login/page.dart';
import 'package:filcnaplo/ui/pages/planner/timetable/builder.dart';
import 'package:filcnaplo/ui/pages/planner/timetable/week.dart';
import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/generated/i18n.dart';

class DebugSettings extends StatefulWidget {
  @override
  _DebugSettingsState createState() => _DebugSettingsState();
}

class _DebugSettingsState extends State<DebugSettings> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Column(children: [
          AppBar(
            leading: BackButton(color: app.settings.appColor),
            centerTitle: true,
            title: Text(
              I18n.of(context).settingsDebugTitle,
              style: TextStyle(fontSize: 18.0),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Switch(
                  activeColor: app.settings.appColor,
                  value: app.debugMode,
                  onChanged: (value) => setState(() {
                    app.debugMode = value;

                    app.storage.storage.update("settings", {
                      "debug_mode": value ? 1 : 0,
                    });
                  }),
                ),
              ),
            ],
            shadowColor: Colors.transparent,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          ListTile(
            leading: Icon(FeatherIcons.downloadCloud),
            title: Text(
              "Előzetes verziók keresése",
              style: TextStyle(
                color: app.debugMode ? null : Colors.grey,
              ),
            ),
            onTap: app.debugMode
                ? () {
                    app.user.sync.release.sync(allowPrerelease: true).then(
                        (_) => ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackBar(
                                message: "Legfrissebb (előzetes) verzió: " +
                                    app.user.sync.release.latestRelease
                                        .version)));
                  }
                : null,
          ),
          ListTile(
            leading: Icon(FeatherIcons.trash2),
            title: Text(
              I18n.of(context).settingsDebugDelete,
              style: TextStyle(
                color: app.debugMode ? null : Colors.grey,
              ),
            ),
            onTap: app.debugMode
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
                      message: I18n.of(context).settingsDebugDeleteSuccess,
                      color: Colors.red,
                    ));

                    DebugHelper().eraseData(context).then((_) {
                      Navigator.of(context, rootNavigator: true)
                          .pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (_) => false,
                      );
                    });
                  }
                : null,
          ),
          ListTile(
            leading: Icon(FeatherIcons.code),
            title: Text(I18n.of(context).settingsBehaviorRenderHTML,
                style: TextStyle(
                  color: app.debugMode ? null : Colors.grey,
                )),
            trailing: Switch(
              activeColor: app.settings.appColor,
              value: app.debugMode && app.settings.renderHtml,
              onChanged: (bool value) {
                setState(() => app.settings.renderHtml = value);

                app.storage.storage.update("settings", {
                  "render_html": value ? 1 : 0,
                });
              },
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Label(I18n.of(context).settingsDebugExperimental),
          ),
          ListTile(
            leading: Icon(FeatherIcons.printer),
            title: Text(
              I18n.of(context).settingsExportExportTimetable,
              style: TextStyle(
                color: app.debugMode ? null : Colors.grey,
              ),
            ),
            onTap: app.debugMode
                ? () {
                    // sync before doing anything
                    final _timetableBuilder = TimetableBuilder();
                    Week currentWeek = _timetableBuilder
                        .getWeek(_timetableBuilder.getCurrentWeek());

                    app.user.sync.timetable.from = currentWeek.start;
                    app.user.sync.timetable.to = currentWeek.end;

                    app.user.sync.timetable.sync().then((_) =>
                        TimetablePrinter().printPDF(_scaffoldKey, context));
                  }
                : null,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              I18n.of(context).settingsDebugDisclamer,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          )
        ]),
      ),
    );
  }
}
