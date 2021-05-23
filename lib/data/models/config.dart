import 'package:filcnaplo/data/context/app.dart';

class Config {
  Map? json;
  String userAgent;
  String? errorReport;

  Config(
    this.userAgent,
    this.errorReport, {
    this.json,
  });

  factory Config.fromJson(Map json) {
    String userAgent = json["user_agent"] ?? defaults.userAgent;
    userAgent = userAgent.replaceFirst("\$0", app.currentAppVersion);
    userAgent = userAgent.replaceFirst("\$1", app.platform);
    userAgent = userAgent.replaceFirst("\$2", '0');
    String errorReport = json["error_report"];

    return Config(
      userAgent,
      errorReport,
      json: json,
    );
  }

  static Config defaults = Config("hu.filc.naplo/0/0/0", null,
      json: {"user_agent": "hu.filc.naplo/\$0/\$1/\$2"});
}
