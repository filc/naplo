import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListTile(
          //cannot reuse the default profile icon because of size differences
          leading: ProfileIcon(
              name: widget.user.name,
              size: 0.85,
              image: widget.user.customProfileIcon),
          title: Text(
            widget.user.name ?? I18n.of(context).unknown,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
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
    );
  }
}
