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
import 'package:filcnaplo/data/models/lesson.dart';

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
                    var containerElements = <pw.Widget>[];

                    // sync indicator
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text(
                        I18n.of(context).syncTimetable,
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.grey,
                    ));
                    print('sync started');
                    // sync before doing anything
                    await app.user.sync.timetable.sync();
                    List<Lesson> lessons = app.user.sync.timetable.data;

                    print('sync finished');
                    // process
                    var totalLessonCounter = 0;
                    for (int i = 1; i <= 5; i++) {
                      var lessonChildren = <pw.Widget>[];
                      for (var lesson in lessons) {
                        if (lesson.date.weekday == i &&
                            lesson.subject != null) {
                          lessonChildren.add(pw.Text(lesson.lessonIndex +
                              ".: " +
                              lesson.subject.name));
                          totalLessonCounter++;
                        }
                      }

                      var dayColumn = pw.Column(
                          children: lessonChildren,
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          mainAxisSize: pw.MainAxisSize.min,
                          mainAxisAlignment: pw.MainAxisAlignment.end);
                      containerElements.add(pw.Padding(
                          padding: pw.EdgeInsets.all(5), child: dayColumn));
                    }

                    /* var debug_decor = pw.BoxDecoration(
                        border: pw.BoxBorder(
                            color: PdfColor.fromHex('#808080'),
                            left: true,
                            right: true,
                            top: true,
                            bottom: true)); */

                    var lessonCountLocal =
                        I18n.of(context).settingsExportLessonCount;
                    var rows = pw.Align(
                        alignment: pw.Alignment.topCenter,
                        child: pw.Column(
                            mainAxisSize: pw.MainAxisSize.min,
                            children: <pw.Widget>[
                              pw.Header(
                                  text: app.user.name +
                                      I18n.of(context)
                                          .settingsExportTimeTableOf),
                              pw.Row(children: containerElements),
                              pw.Padding(
                                  padding: pw.EdgeInsets.all(5),
                                  child: pw.Footer(
                                      leading: pw.Text(
                                          "$totalLessonCounter $lessonCountLocal"),
                                      trailing: pw.Text('filcnaplo.hu')))
                            ]));

                    pdf.addPage(pw.Page(
                        pageFormat: PdfPageFormat.a4,
                        build: (pw.Context context) => rows)); // Page

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
