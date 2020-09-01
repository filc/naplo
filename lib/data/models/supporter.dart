class Supporter {
  String name;
  String amount;
  String platform;

  Supporter(this.name, this.amount, this.platform);

  factory Supporter.fromJson(Map json) {
    String name = json["name"];
    String amount = json["amount"];
    String platform = json["platform"];

    return Supporter(name, amount, platform);
  }
}
