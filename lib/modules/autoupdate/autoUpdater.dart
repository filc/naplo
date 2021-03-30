import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/pages/settings/page.dart';
import 'package:filcnaplo/modules/autoupdate/releaseSync.dart';

class AutoUpdater extends StatefulWidget {
  @override
  _AutoUpdaterState createState() => _AutoUpdaterState();
}

class _AutoUpdaterState extends State<AutoUpdater> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 9),
      decoration: BoxDecoration(
        color: textColor(Theme.of(context).backgroundColor).withAlpha(25),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Theme(
          data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              accentColor: Theme.of(context).textTheme.bodyText1.color),
          child: ExpansionTile(
            leading: Container(
                width: 40.0,
                height: 40.0,
                alignment: Alignment.center,
                child: Icon(FeatherIcons.download,
                    color: app.settings.theme.accentColor)),
            title: Text("Frissítés elérhető!"),
            subtitle: Text(app.currentAppVersion +
                " ▶ " +
                app.user.sync.release.latestRelease.version),
            children: [
              Text("123"),
              Text("123"),
              Text("123"),
              Text("123"),
              Text("123"),
            ],
          )),
    );

    /*Container(
        color: Colors.grey,
        child: ListTile(
            leading: Icon(FeatherIcons.alertCircle),
            title: Text("Frissítés elérhető!"),
            subtitle: Text(app.currentAppVersion +
                " ▶ " +
                app.user.sync.release.latestRelease.version)));*/
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
                context: context,
                builder: (BuildContext context) => AutoUpdater());
          },
        ),
      ),
    );
  }
}
