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
                    String nameFormatter(String input) {
                      var newString = '';
                      input.split(' ').forEach((element) {
                        newString += element[0];
                      });
                      return newString;
                    }

                    // pdf theme (for unicode support)
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
                    await app.user.sync.timetable.sync();

                    // get a builder and build current week
                    var timetableBuilder = TimetableBuilder();
                    timetableBuilder.build(timetableBuilder.getCurrentWeek());

                    var minLessonIndex = 1;
                    var maxLessonIndex = 1;
                    var weekDays = timetableBuilder.week.days;

                    weekDays.forEach((day) {
                      var lessonIntMin = int.parse(day.lessons[0].lessonIndex);
                      if (lessonIntMin < minLessonIndex) {
                        minLessonIndex = lessonIntMin;
                      }
                      if (day.lessons.length + 1 > maxLessonIndex) {
                        maxLessonIndex = day.lessons.length + 1;
                      }
                    });

                    String days(BuildContext context, int i) => [
                          I18n.of(context).dateMondayShort,
                          I18n.of(context).dateTuesdayShort,
                          I18n.of(context).dateWednesdayShort,
                          I18n.of(context).dateThursdayShort,
                          I18n.of(context).dateFridayShort,
                          I18n.of(context).dateSaturdayShort,
                          I18n.of(context).dateSundayShort
                        ][i - 1];

                    var rows = <pw.TableRow>[];

                    // build header row
                    List<pw.Widget> headerChildren = <pw.Widget>[pw.Text('')];
                    weekDays.forEach((day) {
                      headerChildren.add(pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Center(
                              child:
                                  pw.Text(days(context, day.date.weekday)))));
                    });
                    pw.TableRow headerRow = pw.TableRow(
                        children: headerChildren,
                        verticalAlignment:
                            pw.TableCellVerticalAlignment.middle);
                    rows.add(headerRow);

                    // build timetable
                    for (var i = minLessonIndex; i <= maxLessonIndex; i++) {
                      List<pw.Widget> thisChildren = <pw.Widget>[];

                      // lesson index at the start of the row
                      thisChildren.add(pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Center(child: pw.Text('$i. '))));

                      weekDays.forEach((day) {
                        day.lessons.forEach((lesson) {
                          if (int.parse(lesson.lessonIndex) == i) {
                            String name = lesson.subject.name ?? '';
                            String room = lesson.room ?? '';
                            thisChildren.add(pw.Padding(
                                padding: pw.EdgeInsets.fromLTRB(5, 10, 5, 5),
                                child: pw.Column(children: <pw.Widget>[
                                  pw.Align(
                                      child: pw.Text('$name'),
                                      alignment: pw.Alignment.center),
                                  pw.Footer(
                                      leading: pw.Text('$room'),
                                      trailing: pw.Text(
                                          nameFormatter(lesson.teacher))),
                                ])));
                          }

                          if (thisChildren.isEmpty) {
                            thisChildren.add(pw.Text(''));
                          }
                        });
                      });
                      pw.TableRow thisRow = pw.TableRow(
                          children: thisChildren,
                          verticalAlignment:
                              pw.TableCellVerticalAlignment.middle);
                      rows.add(thisRow);
                    }

                    // add timetable to pdf
                    pw.Table table = pw.Table(
                        children: rows,
                        border: pw.TableBorder(
                            bottom: true, top: true, left: true, right: true),
                        defaultVerticalAlignment:
                            pw.TableCellVerticalAlignment.middle);

                    // header and footer
                    pw.Footer footer =
                        pw.Footer(trailing: pw.Text('filcnaplo.hu'));
                    String className = app.user.sync.student.data.className;

                    pw.Footer header = pw.Footer(
                        margin: pw.EdgeInsets.only(bottom: 5),
                        leading: pw.Center(child: pw.Text(app.user.name)),
                        title: pw.Align(
                            alignment: pw.Alignment.topCenter,
                            child: pw.Text(className,
                                style: pw.TextStyle(fontSize: 30))),
                        trailing: pw.Center(
                            child: pw.Text(
                                app.user.sync.student.data.school.name)));
                    pdf.addPage(pw.Page(
                        pageFormat: PdfPageFormat.a4
                            .landscape, // so the page looks normal both in portrait and landscape
                        orientation: pw.PageOrientation.landscape,
                        build: (pw.Context context) => pw.Column(
                            children: <pw.Widget>[header, table, footer])));

                    // print pdf
                    await Printing.layoutPdf(
                        onLayout: (format) async => pdf.save());

                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text(
                        I18n.of(context).settingsExportExportTimetableSuccess,
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
