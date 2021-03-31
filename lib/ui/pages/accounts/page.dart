import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/ui/pages/accounts/tile.dart';
import 'package:filcnaplo/ui/pages/login/page.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/ui/pages/settings/page.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/modules/autoupdate/autoUpdater.dart';
//import 'package:filcnaplo/modules/autoupdate/releaseSync.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  void selectCallback(int id) {
    setState(() {
      app.selectedUser = id;
    });
    app.sync.updateCallback();
    app.sync.fullSync();
    app.user.kreta.userAgent = app.settings.config.config.userAgent;

    app.user.sync.allPending();

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> users = [];

    for (int i = 0; i < app.users.length; i++) {
      if (i != app.selectedUser)
        users.add(AccountTile(
          app.users[i],
          onSelect: selectCallback,
          onDelete: () => setState(() {}),
        ));
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              AppBar(
                leading: Container(),
                title: Text(I18n.of(context).accountTitle),
                centerTitle: true,
                actions: [
                  Padding(
                    padding:
                        EdgeInsets.only(right: 12.0, top: 4.0, bottom: 4.0),
                    child: ClipOval(
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          icon: Icon(FeatherIcons.x,
                              color: app.settings.appColor),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
                shadowColor: Colors.transparent,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              ),

              // Users
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 12.0),
                  child: Column(
                    children: [
                      app.users.length > 0
                          ? AccountTile(
                              app.users[app.selectedUser],
                              onSelect: selectCallback,
                              onDelete: () => setState(() {}),
                            )
                          : Container(),

                      app.users.length > 1
                          ? Divider(thickness: 2.0)
                          : Container(),

                      app.users.length > 1
                          ? Flexible(
                              child: CupertinoScrollbar(
                                child: ListView(
                                  physics: BouncingScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  children: users,
                                ),
                              ),
                            )
                          : Container(),

                      // Add user
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 14.0),
                        child: MaterialButton(
                          elevation: 0,
                          highlightElevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          child: ListTile(
                            leading: Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(
                                FeatherIcons.userPlus,
                                color: app.debugUser
                                    ? Colors.grey
                                    : app.settings.appColor,
                              ),
                            ),
                            title: Text(
                              capitalize(I18n.of(context).accountAdd),
                              style: TextStyle(
                                color: app.debugUser ? Colors.grey : null,
                              ),
                            ),
                          ),
                          onPressed: !app.debugUser
                              ? () {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(CupertinoPageRoute(
                                          builder: (context) => LoginPage()));
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (app.user.sync.release.isNew) AutoUpdateButton(),

              Padding(
                padding: EdgeInsets.only(bottom: 14.0),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 14.0),
                  child: MaterialButton(
                    elevation: 0,
                    highlightElevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(FeatherIcons.settings,
                          color: app.settings.appColor),
                      title: Text(I18n.of(context).settingsTitle),
                    ),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).push(
                          CupertinoPageRoute(
                              builder: (context) => SettingsPage()));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
