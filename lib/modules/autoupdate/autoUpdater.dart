import 'dart:io';

import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/pages/settings/page.dart';
import 'package:filcnaplo/modules/autoupdate/releaseSync.dart';
//import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class AutoUpdater extends StatefulWidget {
  @override
  _AutoUpdaterState createState() => _AutoUpdaterState();
}

class _AutoUpdaterState extends State<AutoUpdater> {
  Widget progressDisplay;

  Function downloadCallback(Widget progressDisplay) {
    setState(() {
      this.progressDisplay = progressDisplay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
          color: Color(0xFF236A5B),
        ),
        margin: EdgeInsets.only(top: 64.0),
        padding: EdgeInsets.all(15),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Image.asset("assets/icon.png"),
                        width: 50,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 7),
                        child: Text(
                          "Frissítés",
                          style: TextStyle(fontSize: 25),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                          decoration: ShapeDecoration(
                            shape: StadiumBorder(),
                            color: Colors.white.withAlpha(25),
                          ),
                          child: Text(
                            app.user.sync.release.latestRelease.version,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        Text(
                          "Jelenlegi verzió: " + app.currentAppVersion,
                          style: TextStyle(color: Colors.white.withAlpha(180)),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    app.user.sync.release.latestRelease.notes,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
              MaterialButton(
                color:
                    textColor(Theme.of(context).backgroundColor).withAlpha(25),
                elevation: 0,
                highlightElevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(FeatherIcons.download),
                  title: progressDisplay ?? Text("Letöltés"),
                ),
                onPressed: () {
                  if (progressDisplay == null) installUpdate(downloadCallback);
                },
              ),
            ]));
  }

  void installUpdate(Function updateDisplay) async {
    var httpClient = HttpClient();

    updateDisplay(LinearProgressIndicator(
      backgroundColor: Colors.white.withAlpha(40),
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withAlpha(210)),
    ));

    String dir = (await getApplicationDocumentsDirectory()).path;
    String filename =
        "filcnaplo-" + app.user.sync.release.latestRelease.version + ".apk";
    File apk = File("$dir/$filename");

    if (!apk.existsSync()) {
      var request = await httpClient
          .getUrl(Uri.parse(app.user.sync.release.latestRelease.url));

      var response = await request.close();

      var rawBytes = await consolidateHttpClientResponseBytes(response);

      await apk.writeAsBytes(rawBytes);
    }

    updateDisplay(Text("Telepítés..."));
    OpenFile.open(apk.path);

    updateDisplay(Text("Telepítés elindítva"));

    /*var client = http.Client();

    print("### Downloading file");

    updateDisplay(LinearProgressIndicator(
      backgroundColor: Colors.white.withAlpha(40),
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withAlpha(210)),
    ));

    var uri = Uri.parse(app.user.sync.release.latestRelease.url);

    var response = await client.get(uri);
    var rawData = response.bodyBytes;

    updateDisplay(Text("Mentés..."));

    String path = (await getApplicationDocumentsDirectory()).path;
    File apk = new File('$path/filc-update.apk');
    await apk.writeAsBytes(rawData);*/
  }
}

class AutoUpdateButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.0),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 14.0),
        child: MaterialButton(
          color: textColor(Theme.of(context).backgroundColor).withAlpha(25),
          elevation: 0,
          highlightElevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(FeatherIcons.download, color: app.settings.appColor),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Frissítés elérhető!"),
                Text(
                  app.user.sync.release.latestRelease.version,
                  style: TextStyle(
                      color: app.settings.appColor,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          onPressed: () {
            showModalBottomSheet(
                useRootNavigator: true,
                context: context,
                backgroundColor: Colors.transparent,
                builder: (BuildContext context) => AutoUpdater());
          },
        ),
      ),
    );
  }
}
