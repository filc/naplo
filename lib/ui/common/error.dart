import 'dart:convert';
import 'dart:io';

import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as parser;
import 'package:filcnaplo/generated/i18n.dart';

bool errorShown = false;
String lastException = '';

Widget errorBuilder(FlutterErrorDetails details) {
  return Builder(builder: (context) {
    if (Navigator.of(context).canPop()) Navigator.pop(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!errorShown && details.exceptionAsString() != lastException) {
        errorShown = true;
        lastException = details.exceptionAsString();
        Navigator.of(context, rootNavigator: true)
            .push(MaterialPageRoute(builder: (ctx) => ReleaseError(details)))
            .then((_) => errorShown = false);
      }
    });
    return Container();
  });
}

class ReleaseError extends StatelessWidget {
  final FlutterErrorDetails details;

  ReleaseError(this.details);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            children: [
              Align(
                child: BackButton(),
                alignment: Alignment.topLeft,
              ),
              Spacer(),
              Icon(
                FeatherIcons.alertTriangle,
                size: 100,
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Text(
                  I18n.of(context).errorReportUhoh,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                I18n.of(context).errorReportDesc,
                style: TextStyle(
                  color: Colors.white.withOpacity(.95),
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              Container(
                height: 110.0,
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.black.withOpacity(.2)),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Text(
                    details.exceptionAsString(),
                    style: TextStyle(fontFamily: 'SpaceMono'),
                  ),
                ),
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: 14.0)),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                    ),
                  ),
                  child: Text(
                    I18n.of(context).errorReportSubmit,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () =>
                      app.settings.config.config.errorReport != null
                          ? reportProblem(context)
                          : null,
                ),
              ),
              SizedBox(height: 32.0)
            ],
          ),
        ),
      ),
    );
  }

  Future reportProblem(BuildContext context) async {
    var content = json.encode({
      'content': null,
      "embeds": [
        {
          "title": "New Bug Report",
          "color": 3708004,
          "fields": [
            {
              'name': 'OS',
              'value':
                  '`${Platform.operatingSystem} ${Platform.operatingSystemVersion}`',
            },
            {
              'name': 'Version',
              'value': '`${app.currentAppVersion}`',
            },
            {
              'name': 'Error',
              'value': '```log\n${details.exceptionAsString()}```'
            }
          ]
        }
      ]
    });

    var req = http.MultipartRequest(
      'POST',
      Uri.parse(app.settings.config.config.errorReport),
    );
    req.headers['Content-Type'] = 'multipart/form-data';
    String traceLog = details.toString();
    req.files.add(http.MultipartFile.fromString('file1', traceLog,
        filename: 'stack_trace.log',
        contentType: parser.MediaType('text', 'plain')));
    req.fields.putIfAbsent('payload_json', () => content);
    await (await req.send()).stream.bytesToString();
    Navigator.pop(context);
  }
}
