import 'package:filcnaplo/data/models/subject.dart';
import 'package:filcnaplo/data/models/type.dart';

class Lesson {
  Map json;
  Type status;
  DateTime date;
  Subject subject;
  String lessonIndex;
  int lessonYearIndex;
  String substituteTeacher;
  String teacher;
  bool homeworkEnabled;
  DateTime start;
  DateTime end;
  Type studentPresence;
  String homeworkId;
  List exams;
  String id;
  Type type;
  String description;
  String room;
  String groupName;
  String name;

  Lesson(
    this.status,
    this.date,
    this.subject,
    this.lessonIndex,
    this.lessonYearIndex,
    this.substituteTeacher,
    this.teacher,
    this.homeworkEnabled,
    this.start,
    this.end,
    this.studentPresence,
    this.homeworkId,
    this.exams,
    this.id,
    this.type,
    this.description,
    this.room,
    this.groupName,
    this.name, {
    this.json,
  });

  factory Lesson.fromJson(Map json) {
    Type status =
        json["Allapot"] != null ? Type.fromJson(json["Allapot"]) : null;
    DateTime date =
        json["Datum"] != null ? DateTime.parse(json["Datum"]).toLocal() : null;
    Subject subject =
        json["Tantargy"] != null ? Subject.fromJson(json["Tantargy"]) : null;
    String lessonIndex =
        json["Oraszam"] != null ? json["Oraszam"].toString() : "+";
    int lessonYearIndex = json["OraEvesSorszama"];
    String substituteTeacher = json["HelyettesTanarNeve"] ?? "";
    String teacher = json["TanarNeve"] ?? "";
    bool homeworkEnabled = json["IsTanuloHaziFeladatEnabled"] ?? false;
    DateTime start = json["KezdetIdopont"] != null
        ? DateTime.parse(json["KezdetIdopont"]).toLocal()
        : null;
    DateTime end = json["VegIdopont"] != null
        ? DateTime.parse(json["VegIdopont"]).toLocal()
        : null;
    Type studentPresence;
    String homeworkId = json["HaziFeladatUid"];
    List exams = json["BejelentettSzamonkeresUids"] != null
        ? json["BejelentettSzamonkeresUids"]
        : [];
    String id = json["Uid"];
    Type type = json["Tipus"] != null ? Type.fromJson(json["Tipus"]) : null;
    String description = json["Tema"] ?? "";
    String room = json["TeremNeve"] ?? "";
    String groupName =
        json["OsztalyCsoport"] != null ? json["OsztalyCsoport"]["Nev"] : null;
    String name = json["Nev"] ?? "";

    return Lesson(
      status,
      date,
      subject,
      lessonIndex,
      lessonYearIndex,
      substituteTeacher,
      teacher,
      homeworkEnabled,
      start,
      end,
      studentPresence,
      homeworkId,
      exams,
      id,
      type,
      description,
      room,
      groupName,
      name,
      json: json,
    );
  }
}
