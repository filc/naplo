import 'package:filcnaplo/data/models/evaluation.dart';

class Type {
  String id;
  String description;
  String name;

  Type(this.id, this.description, this.name);

  factory Type.fromJson(Map json) {
    String id = json["Uid"] ?? "";
    String description = json["Leiras"] != "Na" ? json["Leiras"] ?? "" : "";
    String name = json["Nev"] != "Na" ? json["Nev"] ?? "" : "";

    return Type(id, description, name);
  }

  static EvaluationType getEvalType(String string) {
    return <String, EvaluationType>{
      "evkozi_jegy_ertekeles": EvaluationType.midYear,
      "I_ne_jegy_ertekeles": EvaluationType.firstQ,
      "II_ne_jegy_ertekeles": EvaluationType.secondQ,
      "felevi_jegy_ertekeles": EvaluationType.halfYear,
      "III_ne_jegy_ertekeles": EvaluationType.thirdQ,
      "IV_ne_jegy_ertekeles": EvaluationType.fourthQ,
      "evvegi_jegy_ertekeles": EvaluationType.endYear,
      "osztalyozo_vizsga": EvaluationType.levelExam
    }[string];
  }
}
