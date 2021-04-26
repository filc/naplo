import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/kreta/api.dart';
import 'package:filcnaplo/ui/pages/debug/view.dart';
import 'package:intl/intl.dart';

class DebugEndpoint {
  String host;
  String uri;
  String name;
  DebugEndpoint({this.host, this.uri, this.name});
}

class DebugError {
  String details;
  String parent;

  DebugError({
    this.details,
    this.parent,
  });
}

class DebugResponse {
  String response = "";
  List<DebugError> errors = [];
  int statusCode = 0;
  Map<String, String> headers;
}

class DebugViewStruct {
  final DebugViewClass type;
  String title;
  List<DebugEndpoint> endpoints;

  DebugViewStruct(this.type) {
    switch (this.type) {
      case DebugViewClass.evalutaions:
        title = "ui.pages.evaluations.debug.view";
        endpoints = [
          DebugEndpoint(
            host: BaseURL.kreta(app.user.instituteCode),
            uri: KretaEndpoints.evaluations,
            name: "Evaluations",
          ),
          DebugEndpoint(
            host: BaseURL.kreta(app.user.instituteCode),
            uri: KretaEndpoints.classAverages +
                "?oktatasiNevelesiFeladatUid=" +
                (app.user.sync.student.student != null
                    ? app.user.sync.student.student.groupId.toString()
                    : ""),
            name: "ClassAverages",
          )
        ];
        break;
      case DebugViewClass.planner:
        title = "ui.pages.planner.debug.view";
        endpoints = [
          DebugEndpoint(
            host: BaseURL.kreta(app.user.instituteCode),
            uri: KretaEndpoints.timetable +
                "?datumTol=" +
                DateFormat('yyyy-MM-dd').format(DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  0,
                  0,
                )) +
                "&datumIg=" +
                DateFormat('yyyy-MM-dd').format(DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day + 7,
                  0,
                  0,
                )),
            name: "Timetable",
          ),
          DebugEndpoint(
            host: BaseURL.kreta(app.user.instituteCode),
            uri: KretaEndpoints.homework +
                "?datumTol=" +
                DateTime.fromMillisecondsSinceEpoch(1).toIso8601String(),
            name: "Homework",
          ),
          DebugEndpoint(
            host: BaseURL.kreta(app.user.instituteCode),
            uri: KretaEndpoints.exams,
            name: "Exams",
          ),
        ];
        break;
      case DebugViewClass.messages:
        title = "ui.pages.messages.debug.view";
        endpoints = [
          DebugEndpoint(
            host: BaseURL.KRETA_ADMIN,
            uri: AdminEndpoints.messages("beerkezett"),
            name: "Messages (INBOX)",
          ),
          DebugEndpoint(
            host: BaseURL.kreta(app.user.instituteCode),
            uri: KretaEndpoints.notes,
            name: "Notes",
          ),
          DebugEndpoint(
            host: BaseURL.kreta(app.user.instituteCode),
            uri: KretaEndpoints.events,
            name: "Events",
          ),
        ];
        break;
      case DebugViewClass.absences:
        title = "ui.pages.absences.debug.view";
        endpoints = [
          DebugEndpoint(
            host: BaseURL.kreta(app.user.instituteCode),
            uri: KretaEndpoints.absences,
            name: "Absences",
          ),
        ];
        break;
    }
  }
}
