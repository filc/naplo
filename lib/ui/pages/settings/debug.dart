import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/helpers/debug.dart';
import 'package:filcnaplo/ui/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:filcnaplo/ui/pages/planner/timetable/day.dart';
import 'package:filcnaplo/ui/pages/planner/timetable/tile.dart';
import 'package:filcnaplo/ui/pages/planner/timetable/builder.dart';

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
        child: Column(children: <Widget>[
          AppBar(
            leading: BackButton(),
            centerTitle: true,
            title: Text(
              I18n.of(context).settingsDebugTitle,
              style: TextStyle(fontSize: 18.0),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Switch(
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
            leading: Icon(FeatherIcons.trash2),
            title: Text(
              I18n.of(context).settingsDebugDelete,
              style: TextStyle(
                color: app.debugMode ? null : Colors.grey,
              ),
            ),
            onTap: app.debugMode
                ? () {
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text(
                        I18n.of(context).settingsDebugDeleteSuccess,
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                    ));

                    DebugHelper().eraseData(context).then((_) {
                      Navigator.of(context).pushAndRemoveUntil(
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
              value: app.debugMode && app.settings.renderHtml,
              onChanged: (bool value) {
                setState(() => app.settings.renderHtml = value);

                app.storage.storage.update("settings", {
                  "render_html": value ? 1 : 0,
                });
              },
            ),
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
                ? () async {
                    var myTheme = pw.ThemeData.withFont(
                      base: pw.Font.ttf(
                          await rootBundle.load("assets/Roboto-Regular.ttf")),
                    );
                    final pdf = pw.Document(theme: myTheme);

                    // sync indicator
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text(
                        I18n.of(context).syncTimetable,
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.grey,
                    ));

                    // sync before doing anything
                    //await app.user.sync.timetable.sync();
                    // get a builder and build current week
                    var timetableBuilder = TimetableBuilder();
                    timetableBuilder.build(timetableBuilder.getCurrentWeek());

                    var minLessonIndex = 1;
                    var maxLessonIndex = 1;
                    var days = timetableBuilder.week.days;
                    days.forEach((day) {
                      var lessonIntMin = int.parse(day.lessons[0].lessonIndex);
                      if (lessonIntMin < minLessonIndex) {
                        minLessonIndex = lessonIntMin;
                      }
                      if (day.lessons.length + 1 > maxLessonIndex) {
                        maxLessonIndex = day.lessons.length + 1;
                      }
                    });

                    print('min: $minLessonIndex, max: $maxLessonIndex');
                    var rows = <pw.TableRow>[];
                    for (var i = minLessonIndex; i <= maxLessonIndex; i++) {
                      List<pw.Widget> thisChildren = <pw.Widget>[];
                      days.forEach((day) {
                        day.lessons.forEach((lesson) {
                          if (int.parse(lesson.lessonIndex) == i) {
                            print(lesson.subject.name);
                            String name = lesson.subject.name;

                            thisChildren.add(pw.Text('$name'));
                          }
                          thisChildren.add(pw.Text(
                              '')); // ha ezt kikommentelem nem megy, de miééééééééééééééért????????
                        });
                      });
                      pw.TableRow thisRow = pw.TableRow(children: thisChildren);
                      rows.add(thisRow);
                    }

                    pw.Table table = pw.Table(children: rows);
                    print(table);
                    print(rows);
                    pdf.addPage(pw.Page(
                        pageFormat: PdfPageFormat.a4,
                        build: (pw.Context context) =>
                            pw.Center(child: table)));

                    await Printing.layoutPdf(
                        onLayout: (format) async => pdf.save());

                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text(
                        'Printing complete',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.green[700],
                    ));
                  }
                : null,
          ),
        ]),
      ),
    );
  }
}
