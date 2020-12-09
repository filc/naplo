//import '../context/app.dart';

class Homework {
  Map json;
  DateTime date;
  DateTime lessonDate;
  DateTime deadline;
  bool byTeacher;
  bool homeworkEnabled;
  String teacher;
  String content;
  String subjectName;
  String group;
  List<HomeworkAttachment> attachments;
  String id;

  Homework(
    this.date,
    this.lessonDate,
    this.deadline,
    this.byTeacher,
    this.homeworkEnabled,
    this.teacher,
    this.content,
    this.subjectName,
    this.group,
    this.attachments,
    this.id, {
    this.json,
  });

  factory Homework.fromJson(Map json) {
    DateTime date = json["RogzitesIdopontja"] != null
        ? DateTime.parse(json["RogzitesIdopontja"]).toLocal()
        : null;
    DateTime lessonDate = json["FeladasDatuma"] != null
        ? DateTime.parse(json["FeladasDatuma"]).toLocal()
        : null;
    DateTime deadline = json["HataridoDatuma"] != null
        ? DateTime.parse(json["HataridoDatuma"]).toLocal()
        : null;
    bool byTeacher = json["IsTanarRogzitette"] ?? true;
    bool homeworkEnabled = json["IsTanuloHaziFeladatEnabled"] ?? false;
    String teacher = json["RogzitoTanarNeve"] ?? "";
    String content = (json["Szoveg"] ?? "").trim();
    String subjectName = json["TantargyNeve"] ?? "";
    String group =
        json["OsztalyCsoport"] != null ? json["OsztalyCsoport"]["Uid"] : null;
    List<HomeworkAttachment> attachments = [];
    // Elvileg nem kéne nullnak lennie, de just in case
    if (json["Csatolmanyok"] != null) {
       json["Csatolmanyok"].forEach((json) {
       attachments.add(HomeworkAttachment.fromJson(json));
      });
    }
    String id = json["Uid"];
    return Homework(
      date,
      lessonDate,
      deadline,
      byTeacher,
      homeworkEnabled,
      teacher,
      content,
      subjectName,
      group,
      attachments,
      id,
      json: json,
    );
  }
}

class HomeworkAttachment {
Map json;
int id;
String name;
String type;

HomeworkAttachment(this.id, this.name, this.type, this.json);

factory HomeworkAttachment.fromJson(Map json) {
  int id = int.parse(json["Uid"]);
  String name = json["Nev"];
  String type = json["Tipus"];

  return HomeworkAttachment(
    id,
    name,
    type,
    json
  );
}

}
