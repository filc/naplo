import 'package:filcnaplo/data/models/type.dart';

class Exam {
  Map? json;
  DateTime? date;
  DateTime? writeDate;
  Type? mode;
  int subjectIndex;
  String subjectName;
  String teacher;
  String description;
  String group;
  String id;

  Exam(
    this.date,
    this.writeDate,
    this.mode,
    this.subjectIndex,
    this.subjectName,
    this.teacher,
    this.description,
    this.group,
    this.id, {
    this.json,
  });

  factory Exam.fromJson(Map json) {
    DateTime? date = json["BejelentesDatuma"] != null
        ? DateTime.parse(json["BejelentesDatuma"]).toLocal()
        : null;
    DateTime? writeDate =
        json["Datum"] != null ? DateTime.parse(json["Datum"]).toLocal() : null;
    Type? mode = json["Modja"] != null ? Type.fromJson(json["Modja"]) : null;
    int subjectIndex = json["OrarendiOraOraszama"];
    String subjectName = json["TantargyNeve"] ?? "";
    String teacher = json["RogzitoTanarNeve"] ?? "";
    String description = (json["Temaja"] ?? "").trim();
    String group =
        json["OsztalyCsoport"] != null ? json["OsztalyCsoport"]["Uid"] : null;
    String id = json["Uid"];

    return Exam(
      date,
      writeDate,
      mode,
      subjectIndex,
      subjectName,
      teacher,
      description,
      group,
      id,
      json: json,
    );
  }
}
