import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/helpers/account.dart';
import 'package:filcnaplo/ui/pages/accounts/dkt.dart';
import 'package:filcnaplo/ui/pages/accounts/edit.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/ui/common/profile_icon.dart';
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
                            Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DKTPage(widget.user)));
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
        updateCallback: () {
          setState(() {});
          widget.onDelete();
        },
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
    return Flexible(
      child: FlatButton(
        height: 50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
        onPressed: onPressed,
        child: Column(
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 20.0,
                color: app.settings.appColor,
              ),
            if (icon != null) SizedBox(height: 3.0),
            if (title != "")
              Text(
                capitalize(title),
                textAlign: TextAlign.center,
                overflow: TextOverflow.fade,
                softWrap: false,
              ),
          ],
        ),
      ),
    );
  }
}
