import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:filcnaplo/data/models/lesson.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';

class ExportSettings extends StatefulWidget {
  @override
  _ExportSettingsState createState() => _ExportSettingsState();
}

class _ExportSettingsState extends State<ExportSettings> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Column(
          children: <Widget>[
            AppBar(
              centerTitle: true,
              leading: BackButton(),
              title: Text('Export'), // TODO: i18n
              shadowColor: Colors.transparent,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            ListTile(
              leading: Icon(FeatherIcons.share),
              title: Text('Export timetable'), // TODO: i18n
              onTap: () async {
                var myTheme = pw.Theme.withFont(
            base: pw.Font.ttf(
              await rootBundle.load("assets/Roboto-Regular.ttf")),
              );
                final pdf = pw.Document(theme: myTheme);
                var containerElements = <pw.Widget>[];
                List<Lesson> lessons = app.user.sync.timetable.data;
                // process
                for(int i = 1; i<=5;i++){
                  var lessonChildren = <pw.Widget>[];
                  for(var lesson in lessons){
                    if(lesson.date.weekday == i && lesson.subject != null){
                      lessonChildren.add(pw.Text(lesson.lessonIndex + ".: " + lesson.subject.name));
                    }
                  }

                  var dayColumn = pw.Column(children: lessonChildren);
                  containerElements.add(dayColumn);
                }

                var debug_decor = pw.BoxDecoration(border: pw.BoxBorder(color: PdfColor.fromHex('#808080'), left: true, right:true, top:true, bottom:true));
                var rows = pw.Column(children:<pw.Widget>[pw.Row(children: containerElements), pw.Row(children:<pw.Widget>[pw.Text('filcnaplo.hu')])]);
                var container = pw.Container(alignment: pw.Alignment.center, child: rows);
                pdf.addPage(pw.Page(
                    pageFormat: PdfPageFormat.a4.landscape,
                    
                    build: (pw.Context context) => container)); // Page
                final output = await getTemporaryDirectory();
                
                // USE THIS IN PRODUCTION !!! V
                //var outPath = output.path + '/tmp.pdf';

                // debug
                var outPath = "/sdcard/filc_example2.pdf";

                final file = File(outPath);
                await file.writeAsBytes(pdf.save());
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text(
                        outPath,
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.green[700],
                    ));
                

              },
            ),
          ],
        ),
      ),
    );
  }
}
