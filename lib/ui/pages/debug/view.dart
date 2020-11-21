import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/kreta/api.dart';
import 'package:filcnaplo/ui/empty.dart';
import 'package:filcnaplo/ui/pages/debug/debug.dart';
import 'package:flutter/material.dart';

enum DebugViewClass { evalutaions, planner, messages, absences }

class DebugViewStruct {
  String title;
  List<DebugEndpoint> endpoints;
}

class DebugViewEvaluations implements DebugViewStruct {
  String title = "ui.pages.evaluations.debug.view";
  List<DebugEndpoint> endpoints = [
    DebugEndpoint(
      host: BaseURL.kreta(app.user.kreta.instituteCode),
      uri: KretaEndpoints.evaluations,
    ),
    DebugEndpoint(
      host: BaseURL.kreta(app.user.kreta.instituteCode),
      uri: KretaEndpoints.classAverages,
    )
  ];
}

class DebugViewPlanner implements DebugViewStruct {
  String title = "ui.pages.planner.debug.view";
  List<DebugEndpoint> endpoints;
}

class DebugViewMessages implements DebugViewStruct {
  String title = "ui.pages.messages.debug.view";
  List<DebugEndpoint> endpoints;
}

class DebugViewAbsences implements DebugViewStruct {
  String title = "ui.pages.absences.debug.view";
  List<DebugEndpoint> endpoints;
}

class DebugView extends StatefulWidget {
  final DebugViewClass type;

  DebugView({@required this.type});

  @override
  _DebugViewState createState() => _DebugViewState();
}

class _DebugViewState extends State<DebugView> {
  DebugViewStruct debug;

  @override
  void initState() {
    switch (widget.type) {
      case DebugViewClass.evalutaions:
        debug = DebugViewEvaluations();
        break;

      case DebugViewClass.planner:
        debug = DebugViewPlanner();
        break;

      case DebugViewClass.messages:
        debug = DebugViewMessages();
        break;

      case DebugViewClass.absences:
        debug = DebugViewAbsences();
        break;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(),
        title: Text(debug.title),
        shadowColor: Colors.transparent,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Container(child: ListView(children: debug.endpoints ?? [Empty()])),
    );
  }
}
