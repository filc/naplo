import 'package:filcnaplo/data/context/app.dart';

class Config {
  Map json;
  String userAgent;

  Config(this.userAgent, {this.json});

  factory Config.fromJson(Map json) {
    String userAgent = json["user_agent"] ?? defaults.userAgent;
    userAgent = userAgent.replaceFirst("\$0", app.currentAppVersion);
    userAgent = userAgent.replaceFirst("\$1", app.platform);
    userAgent = userAgent.replaceFirst("\$2", '0');

    return Config(userAgent, json: json);
  }

  static Config defaults = Config(
      "hu.filc.naplo/0/0/0",
      json: {"user_agent": "hu.filc.naplo/\$0/\$1/\$2"});
}
