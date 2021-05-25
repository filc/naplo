class Event {
  Map? json;
  String id;
  DateTime? start;
  DateTime? end;
  String title;
  String content;

  Event(
    this.id,
    this.start,
    this.end,
    this.title,
    this.content, {
    this.json,
  });

  factory Event.fromJson(Map json) {
    String id = json["Uid"];
    DateTime? start = json["ErvenyessegKezdete"] != null
        ? DateTime.parse(json["ErvenyessegKezdete"]).toLocal()
        : null;
    DateTime? end = json["ErvenyessegVege"] != null
        ? DateTime.parse(json["ErvenyessegVege"]).toLocal()
        : null;
    String title = json["Cim"] ?? "";
    String content =
        json["Tartalom"] != null ? json["Tartalom"].replaceAll("\r", "") : "";

    return Event(
      id,
      start,
      end,
      title,
      content,
      json: json,
    );
  }
}
