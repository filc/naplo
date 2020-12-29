import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/pages/accounts/dkt.dart';
import 'package:filcnaplo/utils/colors.dart';
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: ListTile(
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
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: Material(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: Icon(FeatherIcons.grid),
                    color: textColor(app.settings.theme.backgroundColor),
                    onPressed: () {
                      app.kretaApi.users[widget.user.id]
                          .refreshLogin()
                          .then((success) {
                        if (success) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DKTPage(widget.user)));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(I18n.of(context).loginError),
                            duration: Duration(seconds: 5),
                          ));
                        }
                      });
                    },
                  ),
                ),
              ),
              ClipOval(
                child: Material(
                  color: Colors.transparent,
                  child: IconButton(
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
