import 'package:filcnaplo/data/models/school.dart';
import 'package:filcnaplo/utils/format.dart';

class Student {
  String id;
  String name;
  Map? json;
  School school;
  DateTime? birth;
  String yearId;
  String address;
  String? groupId;
  List<String> parents;
  String? className;

  Student(
    this.id,
    this.name,
    this.school,
    this.birth,
    this.yearId,
    this.address,
    this.parents, {
    this.json,
  });

  factory Student.fromJson(Map json) {
    String name = json["Nev"] ?? json["SzuletesiNev"] ?? "";
    School school = School(
      json["IntezmenyAzonosito"] ?? "",
      json["IntezmenyNev"] ?? "",
      "",
    );
    String id = json["Uid"];
    DateTime? birth = json["SzuletesiDatum"] != null
        ? DateTime.parse(json["SzuletesiDatum"]).toLocal()
        : null;
    String yearId = json["TanevUid"] ?? "";
    String address = json["Cimek"] != null
        ? json["Cimek"].length > 0 ? json["Cimek"][0] : null
        : null;
    List<String> parents = [];

    if (json["AnyjaNeve"] != null) {
      [
        [capitalize(json["AnyjaNeve"])],
        json["Gondviselok"]
            .map((e) => capitalize(e["Nev"]))
            .toList()
            .where((name) => !name.contains(json["AnyjaNeve"]))
      ].expand((x) => x).forEach((e) => parents.add(e));
    }

    return Student(
      id,
      name,
      school,
      birth,
      yearId,
      address,
      parents,
      json: json,
    );
  }
}
