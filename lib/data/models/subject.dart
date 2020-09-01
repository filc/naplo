import 'package:filcnaplo/data/models/type.dart';

class Subject {
  String id;
  Type category;
  String name;

  Subject(this.id, this.category, this.name);

  factory Subject.fromJson(Map json) {
    String id = json["Uid"] ?? "";
    Type category = Type.fromJson(json["Kategoria"]);
    String name = json["Nev"];

    return Subject(id, category, name);
  }
}
