import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/user.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/helpers/account.dart';
import 'package:filcnaplo/ui/common/profile_icon.dart';
import 'package:flutter/material.dart';

class EditAccountTile extends StatefulWidget {
  final User user;
  final Function()? callback;
  final Function()? updateCallback;

  EditAccountTile({required this.user, this.callback, this.updateCallback});

  @override
  _EditAccountTileState createState() => _EditAccountTileState();
}

class _EditAccountTileState extends State<EditAccountTile> {
  late TextEditingController _userNameController;
  bool editProfileI = false;

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController();
    _userNameController.text = widget.user.name??"?";
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
                  children: [
                    if (editProfileI)
                      ProfileIcon(
                          name: widget.user.name ?? "?",
                          size: 1.7,
                          image: widget.user.customProfileIcon!)
                    else
                      ProfileIcon(
                          name: widget.user.name ?? "?",
                          size: 1.3,
                          image: widget.user.customProfileIcon!),
                    Container(
                      width: 48 * 1.3,
                      height: 48 * 1.3,
                      decoration: BoxDecoration(
                        color:
                            editProfileI ? Colors.transparent : Colors.black26,
                        shape: BoxShape.circle,
                      ),
                    ),
                    if (!editProfileI)
                      Icon(FeatherIcons.camera, color: Colors.white, size: 32.0)
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
                        cursorColor: app.settings.appColor,
                        autofocus: true,
                        controller: _userNameController,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: app.settings.appColor))),
                        onSubmitted: (name) {
                          AccountHelper(
                            user: widget.user,
                            callback: widget.updateCallback,
                          ).updateName(name, context);
                        },
                      ),
                    )
                  : Expanded(
                      child: Wrap(
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
                                      callback: widget.updateCallback)
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
              AccountHelper(
                user: widget.user,
                callback: widget.updateCallback,
              ).updateName(_userNameController.text, context);
              widget.callback!();
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
