import 'package:filcnaplo/data/controllers/search.dart';
import 'package:filcnaplo/data/models/type.dart';
import 'package:filcnaplo/data/models/subject.dart';

class Evaluation {
  Map? json;
  String id;
  DateTime? date;
  EvaluationValue value;
  String teacher;
  String description;
  EvaluationType type;
  String groupId;
  Subject? subject;
  Type? evaluationType;
  Type? mode;
  DateTime? writeDate;
  DateTime? seenDate;
  String form;

  Evaluation(
    this.id,
    this.date,
    this.value,
    this.teacher,
    this.description,
    this.type,
    this.groupId,
    this.subject,
    this.evaluationType,
    this.mode,
    this.writeDate,
    this.seenDate,
    this.form, {
    this.json,
  });

  factory Evaluation.fromJson(Map json) {
    String id = json["Uid"];
    DateTime? writeDate = json["RogzitesDatuma"] != null
        ? DateTime.parse(json["RogzitesDatuma"]).toLocal()
        : null;
    EvaluationValue value = EvaluationValue(
      json["SzamErtek"] ?? 0,
      json["SzovegesErtek"] ?? "",
      json["SzovegesErtekelesRovidNev"] ?? "",
      json["SulySzazalekErteke"] ?? 0,
    );
    String teacher = json["ErtekeloTanarNeve"] ?? "";
    String description = json["Tema"] ?? "";
    EvaluationType type = json["Tipus"] != null
        ? Type.getEvalType(json["Tipus"]["Nev"])
        : EvaluationType.unknown;
    String groupId = json["OsztalyCsoport"]["Uid"] ?? "";
    Subject? subject =
        json["Tantargy"] != null ? Subject.fromJson(json["Tantargy"]) : null;
    Type? evaluationType =
        json["ErtekFajta"] != null ? Type.fromJson(json["ErtekFajta"]) : null;
    Type? mode = json["Mod"] != null ? Type.fromJson(json["Mod"]) : null;
    DateTime? date = json["KeszitesDatuma"] != null
        ? DateTime.parse(json["KeszitesDatuma"]).toLocal()
        : null;
    DateTime? seenDate = json["LattamozasDatuma"] != null
        ? DateTime.parse(json["LattamozasDatuma"]).toLocal()
        : null;
    String form = json["Jelleg"] != "Na" ? json["Jelleg"] : null;

    return Evaluation(
      id,
      date,
      value,
      teacher,
      description,
      type,
      groupId,
      subject,
      evaluationType,
      mode,
      writeDate,
      seenDate,
      form,
      json: json,
    );
  }

  bool compareTo(dynamic other) {
    if (this.runtimeType != other.runtimeType) return false;

    if (this.id == other.id && this.seenDate == other.seenDate) {
      return true;
    }

    return false;
  }
}

class EvaluationValue {
  int value;
  String valueName;
  String shortName;
  int weight;

  EvaluationValue(this.value, this.valueName, this.shortName, this.weight) {
    String _valueName = SearchController.specialChars(valueName.toLowerCase());

    if (value == 0 &&
        ["peldas", "jo", "valtozo", "rossz", "hanyag"].contains(_valueName)) {
      weight = 0;

      value = {
        "peldas": 5,
        "jo": 4,
        "valtozo": 3,
        "rossz": 2,
        "hanyag": 2
      }[_valueName] ?? 0;
    }
  }
}

enum EvaluationType {
  midYear,
  firstQ,
  secondQ,
  halfYear,
  thirdQ,
  fourthQ,
  endYear,
  levelExam,
  unknown
}
