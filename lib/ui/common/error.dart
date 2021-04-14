import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as parser;

Widget errorBuilder(FlutterErrorDetails details) {
  bool debug = false;
  assert(() {
    debug = true;
    return true;
  }());
  if (debug) {
    return ErrorWidget(details.exception);
  } else {
    return Builder(
      builder: (context) => Center(
        child: TextButton(
          child: Text('Uh oh... :('),
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (ctx) => ReleaseError(details))),
        ),
      ),
    );
  }
}

class ReleaseError extends StatelessWidget {
  final FlutterErrorDetails details;

  ReleaseError(this.details);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: SingleChildScrollView(
            child: Column(children: [
              Container(
                  padding: EdgeInsets.only(bottom: 50),
                  child: Icon(FeatherIcons.alertOctagon, size: 64)),
              Text(
                '"A kréta törik, a filc folyik, mi rossz történhetne még?"',
                textAlign: TextAlign.center,
              ),
              Text(
                'Valamilyen hibába ütköztünk, elnézést a kellemetlenségért.',
                textAlign: TextAlign.center,
              ),
              TextButton(
                child: Text('Hiba elküldése a fejlesztőknek'),
                onPressed: () async {
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
                                '${Platform.operatingSystem} ${Platform.operatingSystemVersion}'
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
                    Uri.parse(
                        'https://discord.com/api/webhooks/831812647799619634/4NN11mgUuaRST3JNvvD08d0nQFT2_7ytknEgbJ9kxcyoIZau9-KgxRBJe4DhlIv0ToxJ'),
                  );
                  req.headers['Content-Type'] = 'multipart/form-data';
                  var traceStr = details.stack.toString().split('\n');
                  var len = traceStr.length;
                  traceStr.removeRange(min(25, len), len - 1);
                  req.files.add(http.MultipartFile.fromString(
                      'file1', traceStr.join('\n'),
                      filename: 'stack_trace.log',
                      contentType: parser.MediaType('text', 'plain')));
                  req.fields.putIfAbsent('payload_json', () => content);
                  var resp = (await (await req.send()).stream.bytesToString());
                  print(resp);
                  Navigator.pop(context);
                },
              ),
            ]),
          ),
        ));
  }
}
