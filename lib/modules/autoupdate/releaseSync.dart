import 'dart:io';
import 'package:filcnaplo/data/context/app.dart';

class ReleaseSync {
  Release latestRelease;
  bool isNew = false;

  Future sync({bool allowPrerelease = false}) async {
    var releasesJson = await app.user.kreta.getReleases();
    if (!allowPrerelease) {
      for (Map r in releasesJson) {
        if (!r["prerelease"]) {
          latestRelease = Release.fromJson(r);
          break;
        }
      }
    } else {
      List<Map> releases = [];
      latestRelease = Release.fromJson(releasesJson.first);
    }

    //TODO removeme
    print("Found release " + latestRelease.version);

    if (Platform.isAndroid) {
      isNew = compareVersions(latestRelease.version, app.currentAppVersion);
    } else
      isNew = false;
  }

  bool compareVersions(String gitHub, String existing) {
    try {
      bool stableGitHub = false;
      List<String> gitHubPartsStrings = gitHub.split(RegExp(r"[.-]"));
      List<int> gitHubParts = [];

      for (String s in gitHubPartsStrings) {
        if (s.startsWith("beta")) {
          s = s.replaceAll("beta", "");
        } else if (s.startsWith("pre")) {
          //! pre versions have lower priority than beta
          s = s.replaceAll("pre", "");
          gitHubParts.add(0);
        } else {
          stableGitHub = true;
        }
        try {
          gitHubParts.add(int.parse(s));
        } catch (e) {
          print(
              "ERROR: releaseSync.dart compareVersions gitHubParts failed to parse version part! " +
                  e.toString());
        }
      }
      if (stableGitHub) gitHubParts.add(1000);

      bool stableExisting = false;
      List<String> existingPartsStrings = existing.split(RegExp(r"[.-]"));
      List<int> existingParts = [];

      for (String s in existingPartsStrings) {
        if (s.startsWith("beta")) {
          s = s.replaceAll("beta", "");
        } else if (s.startsWith("pre")) {
          //! pre versions have lower priority than beta
          s = s.replaceAll("pre", "");
          existingParts.add(0);
        } else {
          stableExisting = true;
        }
        try {
          existingParts.add(int.parse(s));
        } catch (e) {
          print(
              "ERROR: releaseSync.dart compareVersions existingParts failed to parse version part!" +
                  e.toString());
        }
      }
      if (stableExisting) existingParts.add(1000);

      int i = 0;
      for (var gitHubPart in gitHubParts) {
        if (gitHubPart > existingParts[i])
          return true;
        else if (existingParts[i] > gitHubPart) return false;
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
