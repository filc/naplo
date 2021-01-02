import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/helpers/account.dart';
import 'package:filcnaplo/ui/pages/accounts/dkt.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/ui/profile_icon.dart';
import 'package:filcnaplo/data/models/user.dart';
import 'package:filcnaplo/ui/pages/accounts/view.dart';

class AccountTile extends StatefulWidget {
  final User user;
  final Function onSelect;
  final Function onDelete;

  AccountTile(this.user, {this.onSelect, this.onDelete});

  @override
  _AccountTileState createState() => _AccountTileState();
}

class _AccountTileState extends State<AccountTile> {
  bool editMode = false;

  @override
  Widget build(BuildContext context) {
    bool isSelectedUser = app.selectedUser ==
        app.users.indexOf(app.users.firstWhere((u) => u.id == widget.user.id));

    if (!editMode) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 14.0),
        child: FlatButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            widget.onSelect(app.users.indexOf(widget.user));
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Column(
            children: [
              ListTile(
                leading: ProfileIcon(
                    name: widget.user.name,
                    size: 0.85,
                    image: widget.user.customProfileIcon),
                // cannot reuse the default profile icon because of size differences
                title: Text(
                  widget.user.name ?? I18n.of(context).unknown,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              isSelectedUser
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AccountTileButton(
                          icon: FeatherIcons.info,
                          title: I18n.of(context).accountInfo,
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => AccountView(widget.user,
                                  callback: () => setState(() {})),
                              backgroundColor: Colors.transparent,
                            ).then((deleted) {
                              if (deleted == true) widget.onDelete();
                            });
                          },
                        ),
                        AccountTileButton(
                          icon: FeatherIcons.edit2,
                          title: I18n.of(context).actionEdit,
                          onPressed: () => setState(() => editMode = true),
                        ),
                        AccountTileButton(
                          icon: FeatherIcons.grid,
                          title: "DKT",
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DKTPage(widget.user)));
                          },
                        ),
                        AccountTileButton(
                          icon: FeatherIcons.trash2,
                          title: I18n.of(context).actionDelete,
                          onPressed: () {
                            AccountHelper(user: widget.user)
                                .deleteAccount(context);
                            widget.onDelete();
                          },
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      );
    } else {
      return EditAccountTile(
        user: widget.user,
        updateCallback: widget.onDelete,
        callback: () => setState(() => editMode = false),
      );
    }
  }
}

class AccountTileButton extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final String title;

  AccountTileButton({this.onPressed, this.icon, this.title = ""});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64.0,
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
        onPressed: onPressed,
        child: Column(
          children: [
            icon != null
                ? Icon(
                    icon,
                    size: 20.0,
                  )
                : Container(),
            icon != null ? SizedBox(height: 3.0) : Container(),
            title != ""
                ? Text(
                    capitalize(title),
                    textAlign: TextAlign.center,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class EditAccountTile extends StatefulWidget {
  final User user;
  final Function callback;
  final Function updateCallback;

  EditAccountTile({@required this.user, this.callback, this.updateCallback});

  @override
  _EditAccountTileState createState() => _EditAccountTileState();
}

class _EditAccountTileState extends State<EditAccountTile> {
  var _userNameController;
  bool editProfileI = false;

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController();
    _userNameController.text = widget.user.name;
  }

  @override
  void dispose() {
    super.dispose();
    _userNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              GestureDetector(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: Opacity(
                        opacity: editProfileI ? 1.0 : 0.7,
                        child: !editProfileI
                            ? ProfileIcon(
                                name: widget.user.name,
                                size: 1.3,
                                image: widget.user.customProfileIcon)
                            : ProfileIcon(
                                name: widget.user.name,
                                size: 1.7,
                                image: widget.user.customProfileIcon),
                      ),
                    ),
                    !editProfileI
                        ? Icon(FeatherIcons.camera,
                            color: Colors.white, size: 32.0)
                        : Container(),
                  ],
                ),
                onTap: () {
                  if (!editProfileI) setState(() => editProfileI = true);
                },
              ),
              SizedBox(width: 16.0),
              !editProfileI
                  ? Expanded(
                      child: TextField(
                        autofocus: true,
                        controller: _userNameController,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w500,
                        ),
                        onSubmitted: (name) {
                          AccountHelper(
                            user: widget.user,
                            callback: widget.updateCallback,
                          ).updateName(name, context);
                        },
                      ),
                    )
                  : Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            child: Text(
                              I18n.of(context).actionReset.toUpperCase(),
                              style: TextStyle(
                                color: app.settings.theme.accentColor,
                              ),
                            ),
                            onPressed: () {
                              AccountHelper(
                                user: widget.user,
                                callback: widget.updateCallback,
                              ).deleteProfileI();
                            },
                          ),
                          TextButton(
                            child: Text(
                              I18n.of(context).actionChange.toUpperCase(),
                              style: TextStyle(
                                color: app.settings.theme.accentColor,
                              ),
                            ),
                            onPressed: () {
                              AccountHelper(
                                      user: widget.user,
                                      callback: widget.callback)
                                  .changeProfileI(context);
                            },
                          ),
                          TextButton(
                            child: Text(
                              I18n.of(context).dialogBack.toUpperCase(),
                              style: TextStyle(
                                color: app.settings.theme.accentColor,
                              ),
                            ),
                            onPressed: () =>
                                setState(() => editProfileI = false),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
          TextButton(
            onPressed: () {
              if (widget.callback != null) widget.callback();
            },
            child: Text(
              I18n.of(context).dialogDone,
              style: TextStyle(color: app.settings.theme.accentColor),
            ),
          )
        ],
      ),
    );
  }
}
