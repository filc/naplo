import 'dart:io';
import 'dart:typed_data';

import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/ui/common/bottom_card.dart';
import 'package:filcnaplo/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:filcnaplo/data/context/theme.dart';

import '../../ui/common/custom_snackbar.dart';

enum InstallState { update, downloading, saving, installing }

class AutoUpdater extends StatefulWidget {
  @override
  _AutoUpdaterState createState() => _AutoUpdaterState();
}

class _AutoUpdaterState extends State<AutoUpdater> {
  bool buttonPressed = false;
  double progress;
  bool displayProgress = false;
  InstallState installState;

  void downloadCallback(
      double progress, bool displayProgress, InstallState installState) {
    if (mounted) {
      setState(() {
        this.progress = progress;
        this.displayProgress = displayProgress;
        this.installState = installState;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!buttonPressed) installState = InstallState.update;

    String buttonText;

    switch (installState) {
      case InstallState.update:
        buttonText = I18n.of(context).update;
        break;
      case InstallState.downloading:
        buttonText = I18n.of(context).updateDownloading;
        break;
      case InstallState.saving:
        buttonText = I18n.of(context).updateSaving;
        break;
      case InstallState.installing:
        buttonText = I18n.of(context).updateInstalling;
        break;
      default:
        buttonText = I18n.of(context).error;
    }

    return BottomCard(
      child: Padding(
        padding: EdgeInsets.only(top: 13),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ListTile(
                            contentPadding: EdgeInsets.only(left: 8.0),
                            title: Text(
                              I18n.of(context).updateNewVersion,
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              app.user.sync.release.latestRelease.version,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.asset(
                            "assets/logo.png",
                            width: 60,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            I18n.of(context).updateChanges + ":",
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            I18n.of(context).updateCurrentVersion +
                                ": " +
                                app.currentAppVersion,
                            style:
                                TextStyle(color: Colors.white.withAlpha(180)),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Builder(builder: (context) {
                            try {
                              return Markdown(
                                shrinkWrap: true,
                                data: app.user.sync.release.latestRelease.notes,
                                padding: EdgeInsets.all(0),
                                physics: BouncingScrollPhysics(),
                                styleSheet: MarkdownStyleSheet(
                                  p: TextStyle(
                                    fontSize: 15,
                                    color: app.settings.theme.textTheme
                                        .bodyText1.color,
                                  ),
                                ),
                              );
                            } catch (e) {
                              print(
                                  "ERROR: autoUpdater.dart failed to show markdown release notes: " +
                                      e.toString());
                              return Text(
                                  app.user.sync.release.latestRelease.notes);
                            }
                          })),
                    )
                  ],
                ),
              ),
              Stack(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                          icon: Icon(FeatherIcons.helpCircle),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => HelpDialog());
                          })
                    ],
                  ),
                  Center(
                    child: MaterialButton(
                      color: ThemeContext.filcGreen,
                      elevation: 0,
                      highlightElevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45.0)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 9),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (displayProgress)
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                height: 19,
                                width: 19,
                                child: CircularProgressIndicator(
                                  value: progress,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                  strokeWidth: 3.2,
                                ),
                              ),
                            Text(
                              buttonText.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      onPressed: () {
                        if (!buttonPressed)
                          installUpdate(context, downloadCallback);
                        buttonPressed = true;
                      },
                    ),
                  ),
                ],
              ),
            ]),
      ),
    );
  }

  Future installUpdate(BuildContext context, Function updateDisplay) async {
    updateDisplay(null, true, InstallState.downloading);

    String dir = (await getApplicationDocumentsDirectory()).path;
    String latestVersion = app.user.sync.release.latestRelease.version;
    String filename = "filcnaplo-$latestVersion.apk";
    File apk = File("$dir/$filename");

    var httpClient = http.Client();
    var request = new http.Request(
        'GET', Uri.parse(app.user.sync.release.latestRelease.url));
    var response = httpClient.send(request);

    List<List<int>> chunks = [];
    int downloaded = 0;

    response.asStream().listen((http.StreamedResponse r) {
      r.stream.listen((List<int> chunk) {
        // Display percentage of completion
        updateDisplay(
            downloaded / r.contentLength, true, InstallState.downloading);

        chunks.add(chunk);
        downloaded += chunk.length;
      }, onDone: () async {
        // Display percentage of completion
        updateDisplay(null, true, InstallState.saving);

        // Save the file
        final Uint8List bytes = Uint8List(r.contentLength);
        int offset = 0;
        for (List<int> chunk in chunks) {
          bytes.setRange(offset, offset + chunk.length, chunk);
          offset += chunk.length;
        }
        await apk.writeAsBytes(bytes);

        updateDisplay(null, true, InstallState.installing);
        if (mounted) {
          OpenFile.open(apk.path).then((result) {
            if (result.type != ResultType.done) {
              print("ERROR: installUpdate.openFile: " + result.message);
              ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
                message: I18n.of(context).error,
                color: Colors.red,
              ));
            }
            Navigator.pop(context);
          });
        }
      });
    });
  }
}

class HelpDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
            decoration: BoxDecoration(
              color: app.settings.theme.backgroundColor,
              borderRadius: BorderRadius.circular(4.0),
            ),
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            margin: EdgeInsets.all(32.0),
            child: Column(children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Icon(FeatherIcons.helpCircle),
                ),
              ),
              Expanded(
                child: Markdown(
                  shrinkWrap: true,
                  data: helpText,
                  padding: EdgeInsets.all(0),
                  physics: BouncingScrollPhysics(),
                  styleSheet: MarkdownStyleSheet(
                    p: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              MaterialButton(
                  child: Text(I18n.of(context).dialogDone),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ])));
  }
}

const String helpText =
    """A **FRISS??T??S** gombot megnyomva az app automatikusan let??lti a GitHubr??l a legfrissebb Filc telep??t??t.\\
Ez kb. 50 MB adatforgalommal j??r.\\
A let??lt??tt telep??t??t ezut??n megnyitja az app.

Telefonm??rk??t??l ??s Android verzi??t??l f??gg??en nagyon k??l??nb??z?? a telep??t??s folyamata, de ezekre figyelj:
 - Ha k??rdezi a telefon, **enged??lyezd a Filct??l sz??rmaz?? appok telep??t??s??t**, majd nyomd meg a vissza gombot.\\
 _(??jabb Android verzi??k)_
 - Ha sz??l a telefon hogy a k??ls?? appok telep??t??se biztons??gi okokb??l tiltott, a megjelen?? gombbal **ugorj a be??ll??t??sokba ??s kapcsold be az Ismeretlen forr??sok lehet??s??get.**\\
 _(R??gi Android verzi??k)_
 
A telep??t??s ut??n ??jra megny??lik az app, imm??r a legfrissebb verzi??val. Az ind??t??s sor??n t??rli a telep??t??shez haszn??lt .apk f??jlokat, ??gy a t??rhelyed miatt nem kell agg??dnod.
""";

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
                Flexible(
                    child: Text(
                  I18n.of(context).updateAvailable,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                )),
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
              context: context,
              backgroundColor: Colors.transparent,
              builder: (BuildContext context) => AutoUpdater(),
            );
          },
        ),
      ),
    );
  }
}
