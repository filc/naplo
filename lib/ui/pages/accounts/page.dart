import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/models/user.dart';
import 'package:filcnaplo/ui/pages/login.dart';
import 'package:filcnaplo/ui/profile_icon.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/ui/pages/settings/page.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/pages/accounts/view.dart';
import 'package:filcnaplo/ui/pages/accounts/dkt.dart';

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
    Navigator.pop(context);
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
      body: Container(
        child: Column(
          children: <Widget>[
            AppBar(
              leading: Container(),
              title: Text(I18n.of(context).accountTitle),
              centerTitle: true,
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: IconButton(
                    icon: Icon(FeatherIcons.x),
                    onPressed: () {
                      Navigator.pop(context);
                    },
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

                    app.users.length > 1 ? Divider() : Container(),

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

            // Settings
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
    );
  }
}

class AccountTile extends StatefulWidget {
  final User user;
  final Function onSelect;
  final Function onDelete;

  AccountTile(this.user, {this.onSelect, this.onDelete});

  @override
  _AccountTileState createState() => _AccountTileState();
}

class _AccountTileState extends State<AccountTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14.0),
      child: FlatButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          widget.onSelect(app.users.indexOf(widget.user));
        },
        onLongPress: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => AccountView(widget.user, callback: setState),
            backgroundColor: Colors.transparent,
          ).then((deleted) {
            if (deleted == true) widget.onDelete();
          });
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
        child: ListTile(
          leading: ProfileIcon(
              name: widget.user.name,
              size: 0.85,
              image: widget.user.customProfileIcon),
          //cannot reuse the default profile icon because of size differences
          title: Text(
            widget.user.name ?? I18n.of(context).unknown,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              RaisedButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(FeatherIcons.grid),
                    ),
                    Text("DKT"),
                  ],
                ),
                color: app.settings.theme.backgroundColor,
                colorBrightness: app.settings.theme.brightness,
                shape: StadiumBorder(),
                onPressed: () {
                  app.kretaApi.users[widget.user.id]
                      .refreshLogin()
                      .then((success) {
                    if (success) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DKTPage(widget.user)));
                    } else {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(I18n.of(context).loginError),
                        duration: Duration(seconds: 5),
                      ));
                    }
                  });
                },
              ),
              IconButton(
                icon: Icon(FeatherIcons.moreVertical),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) =>
                        AccountView(widget.user, callback: setState),
                    backgroundColor: Colors.transparent,
                  ).then((deleted) {
                    if (deleted == true) widget.onDelete();
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
