import "package:filcnaplo/data/models/type.dart";
import "package:filcnaplo/data/models/subject.dart";

class Absence {
  Map json;
  String id;
  DateTime date;
  int delay;
  DateTime submitDate;
  String teacher;
  Justification state;
  Type justification;
  Type type;
  Type mode;
  Subject subject;
  DateTime lessonStart;
  DateTime lessonEnd;
  int lessonIndex;
  String group;

  Absence(
    this.id,
    this.date,
    this.delay,
    this.submitDate,
    this.teacher,
    this.state,
    this.justification,
    this.type,
    this.mode,
    this.subject,
    this.lessonStart,
    this.lessonEnd,
    this.lessonIndex,
    this.group, {
    this.json,
  });

  String get stateString => state == Justification.Justified
      ? "Igazolt"
      : state == Justification.Pending
          ? "Igazolandó"
          : "Igazolatlan";
  factory Absence.fromJson(Map json) {
    String id = json["Uid"];
    DateTime date =
        json["Datum"] != null ? DateTime.parse(json["Datum"]).toLocal() : null;
    int delay = json["KesesPercben"] ?? 0;
    DateTime submitDate = json["KeszitesDatuma"] != null
        ? DateTime.parse(json["KeszitesDatuma"]).toLocal()
        : null;
    String teacher = json["RogzitoTanarNeve"] ?? "";
    Justification state = json["IgazolasAllapota"] == "Igazolt"
        ? Justification.Justified
        : json["IgazolasAllapota"] == "Igazolando"
            ? Justification.Pending
            : Justification.Unjustified;
    Type justification = json["IgazolasTipusa"] != null
        ? Type.fromJson(json["IgazolasTipusa"])
        : null;
    Type type = json["Tipus"] != null ? Type.fromJson(json["Tipus"]) : null;
    Type mode = json["Mod"] != null ? Type.fromJson(json["Mod"]) : null;
    Subject subject =
        json["Tantargy"] != null ? Subject.fromJson(json["Tantargy"]) : null;

    DateTime lessonStart;
    DateTime lessonEnd;
    int lessonIndex;
    if (json["Ora"] != null) {
      lessonStart = json["Ora"]["KezdoDatum"] != null
          ? DateTime.parse(json["Ora"]["KezdoDatum"]).toLocal()
          : null;
      lessonEnd = json["Ora"]["VegDatum"] != null
          ? DateTime.parse(json["Ora"]["VegDatum"]).toLocal()
          : null;
      lessonIndex = json["Ora"]["Oraszam"];
    }

    String group =
        json["OsztalyCsoport"] != null ? json["OsztalyCsoport"]["Uid"] : null;

    return Absence(
      id,
      date,
      delay,
      submitDate,
      teacher,
      state,
      justification,
      type,
      mode,
      subject,
      lessonStart,
      lessonEnd,
      lessonIndex,
      group,
      json: json,
    );
  }
}

enum Justification { Justified, Unjustified, Pending }
