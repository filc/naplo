class Homework {
  Map json;
  DateTime date;
  DateTime lessonDate;
  DateTime deadline;
  bool byTeacher;
  bool homeworkEnabled;
  bool isSolved;
  String teacher;
  String content;
  String subjectName;
  String group;
  List attachments;
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
    this.id,
    this.isSolved, {
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
    List attachments = json["Csatolmanyok"];
    String id = json["Uid"];
    bool isSolved = json["IsMegoldva"] ?? false;

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
      isSolved,
      json: json,
    );
  }
}
