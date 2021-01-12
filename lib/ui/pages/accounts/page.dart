import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/ui/pages/about/page.dart';
import 'package:filcnaplo/ui/pages/accounts/tile.dart';
import 'package:filcnaplo/ui/pages/login.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/ui/pages/settings/page.dart';
import 'package:filcnaplo/generated/i18n.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  void selectCallback(int id) {
    setState(() {
      if (app.selectedUser != id) {
        app.selectedMessagePage = 0;
        app.selectedEvalPage = 0;
        app.evalSortBy = 0;
      }
      app.selectedUser = id;
    });
    app.sync.updateCallback();
    app.sync.fullSync();
    app.user.kreta.userAgent = app.settings.config.data.userAgent;
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
            children: <Widget>[
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
                          icon: Icon(FeatherIcons.x),
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
                    children: <Widget>[
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
                        child: FlatButton(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          child: ListTile(
                            leading: Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(
                                FeatherIcons.userPlus,
                                color: app.debugUser ? Colors.grey : null,
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
                                  Navigator.of(context).push(CupertinoPageRoute(
                                      builder: (context) => LoginPage()));
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(bottom: 14.0),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 14.0),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(FeatherIcons.settings),
                      title: Text(I18n.of(context).settingsTitle),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(CupertinoPageRoute(
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
