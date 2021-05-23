class Recipient {
  int id;
  String studentId; // oktatasi azonosito
  int kretaId;
  String name;
  RecipientCategory category;
  Map? json;

  Recipient(
    this.id,
    this.studentId,
    this.name,
    this.kretaId,
    this.category, {
    this.json,
  });

  factory Recipient.fromJson(Map json) {
    int id = json["azonosito"];
    int kretaId = json["kretaAzonosito"];
    String name = json["nev"];
    RecipientCategory category = RecipientCategory.fromJson(json["tipus"]);

    return Recipient(
      id,
      "",
      name,
      kretaId,
      category,
      json: json,
    );
  }
}

class RecipientCategory {
  int id;
  String code;
  String shortName;
  String name;
  String description;
  Map? json;

  RecipientCategory(
    this.id,
    this.code,
    this.shortName,
    this.name,
    this.description, {
    this.json,
  });

  factory RecipientCategory.fromJson(Map json) {
    int id = json["azonosito"];
    String code = json["kod"];
    String shortName = json["rovidNev"];
    String name = json["nev"];
    String description = json["leiras"];

    return RecipientCategory(
      id,
      code,
      shortName,
      name,
      description,
      json: json,
    );
  }
}
