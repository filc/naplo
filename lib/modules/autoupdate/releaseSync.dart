import 'package:filcnaplo/ui/pages/messages/message/attachment.dart';
import 'package:http/http.dart' as http;
import 'package:filcnaplo/data/context/app.dart';

class ReleaseSync {
  Release latestRelease;
  bool isNew = false;

  Future sync() async {
    var latestReleaseJson = await app.user.kreta.getLatestRelease();
    latestRelease = Release.fromJson(latestReleaseJson);
    isNew = compareVersions(latestRelease.version, app.currentAppVersion);
  }

  bool compareVersions(String first, String second) {
    try {
      var firstParts = first.split(".");
      var secondParts = second.split(".");

      int i = 0;
      for (var firstPart in firstParts) {
        if (int.parse(firstPart) > int.parse(secondParts[i])) return true;
        i++;
      }
      return false;
    } catch (e) {
      print("ERROR in ReleaseSync.dart: " + e.toString());
      return false;
    }
  }
}

class Release {
  String version;
  String notes;
  String url;

  Release(this.version, this.notes, this.url);

  factory Release.fromJson(Map json) {
    List<Map> assets = [];
    json["assets"].forEach((json) {
      assets.add(json);
    });
    String url = assets[0]["browser_download_url"];

    return Release(json["tag_name"], json["body"], url);
  }
}
