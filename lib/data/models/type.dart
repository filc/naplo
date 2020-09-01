class Type {
  String id;
  String description;
  String name;

  Type(this.id, this.description, this.name);

  factory Type.fromJson(Map json) {
    String id = json["Uid"] ?? "";
    String description = json["Leiras"] ?? "";
    String name = json["Nev"] ?? "";

    return Type(id, description, name);
  }
}
