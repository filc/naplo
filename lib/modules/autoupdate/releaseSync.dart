import 'package:filcnaplo/ui/pages/messages/message/attachment.dart';
import 'package:http/http.dart' as http;
import 'package:filcnaplo/data/context/app.dart';

class ReleaseSync {
  Release latestRelease;

  Future sync() async {
    var latestReleaseJson = await app.user.kreta.getLatestRelease();
    latestRelease = Release.fromJson(latestReleaseJson);

    //TODO Removeme
    print("\n#######################\nRelease sync!\nVersion: " +
        latestRelease.version +
        "\nNotes: " +
        latestRelease.notes +
        "\nLink: " +
        latestRelease.url);
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
