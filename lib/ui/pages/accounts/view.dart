import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/helpers/account.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/student.dart';
import 'package:filcnaplo/data/models/user.dart';
import 'package:filcnaplo/ui/profile_icon.dart';
import 'package:intl/intl.dart';
import 'package:filcnaplo/generated/i18n.dart';

class AccountView extends StatefulWidget {
  final User user;
  final callback;

  AccountView(this.user, {this.callback});

  @override
  _AccountViewState createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  bool edit = false;
  bool editName = false;
  bool editProfileI = false;
  bool nameChanged = false;
  bool profileIChanged = false;
  ProfileIcon profileIcon;
  TextEditingController _userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (!nameChanged) {
      _userNameController.text = widget.user.name;
      nameChanged = true;
    }

    if (!profileIChanged) {
      profileIcon = ProfileIcon(
          name: widget.user.name,
          size: 3.0,
          image: widget.user.customProfileIcon);
      profileIChanged = true;
    }

    List<Widget> actionButtons = <Widget>[
      Material(
        color: Colors.transparent,
        child: InkWell(
          radius: 100.0,
          borderRadius: BorderRadius.circular(6.0),
          highlightColor: Colors.transparent,
          onTap: () {
            AccountHelper(user: widget.user).deleteAccount(context);
          },
          child: SizedBox(
            width: 75,
            height: 60,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(FeatherIcons.trash2),
                ),
                Text(
                  capital(I18n.of(context).actionDelete),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
      Material(
        color: Colors.transparent,
        child: InkWell(
          radius: 100.0,
          borderRadius: BorderRadius.circular(6.0),
          highlightColor: Colors.transparent,
          onTap: () {
            setState(() {
              edit = !edit;
              editName = false;
              editProfileI = false;
              nameChanged = false;
            });
          },
          child: SizedBox(
            width: 75,
            height: 60,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    FeatherIcons.edit,
                    color: edit ? app.settings.appColor : null,
                  ),
                ),
                Text(
                  capital(I18n.of(context).actionEdit),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: edit ? app.settings.appColor : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ];

    if (app.debugVersion)
      actionButtons.add(Material(
        color: Colors.transparent,
        child: InkWell(
          radius: 100.0,
          borderRadius: BorderRadius.circular(6.0),
          highlightColor: Colors.transparent,
          onTap: () {
            // Export Action
            // Navigator.of(context).push(MaterialPageRoute(
            //  builder: (context) => ExportUser(user),
            // ));
          },
          child: SizedBox(
            width: 75,
            height: 60,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(FeatherIcons.externalLink),
                ),
                Text("Export"),
              ],
            ),
          ),
        ),
      ));

    Student student = app.sync.users[widget.user.id] != null
        ? app.sync.users[widget.user.id].student.data
        : null;
    // todo: if student is null get student (future builder)

    return Container(
      decoration: BoxDecoration(
        color: app.settings.theme.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: actionButtons,
            ),
          ),

          // User
          !edit
              ? Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
                  child: ListTile(
                    leading: GestureDetector(
                      child: ProfileIcon(
                          name: widget.user.name,
                          size: 1.2,
                          image: widget.user.customProfileIcon),
                      onTap: () {
                        showDialog(
                          context: context,
                          child: Center(
                            child: ProfileIcon(
                                name: widget.user.name,
                                size: 4.2,
                                image: widget.user.customProfileIcon),
                          ),
                        );
                      },
                    ),
                    title: Text(
                      widget.user.name,
                      style: TextStyle(fontSize: 18.0),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      widget.user.username,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              : Container(),

          // User Details
          !edit
              ? Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
                  child: student != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            widget.user.name != widget.user.realName
                                ? StudentDetail(
                                    I18n.of(context).studentRealName,
                                    widget.user.realName)
                                : Container(),
                            student.school.name != ""
                                ? StudentDetail(I18n.of(context).studentSchool,
                                    student.school.name)
                                : Container(),
                            student.birth != null
                                ? StudentDetail(
                                    I18n.of(context).studentBirth,
                                    DateFormat("yyyy. MM. dd.")
                                        .format(student.birth))
                                : Container(),
                            student.address != null
                                ? StudentDetail(I18n.of(context).studentAddress,
                                    student.address)
                                : Container(),
                            student.parents != null
                                ? student.parents.length > 0
                                    ? StudentDetail(
                                        I18n.of(context).studentParents,
                                        student.parents.join(", "))
                                    : Container()
                                : Container(),
                          ],
                        )
                      : app.debugVersion
                          ? StudentDetail("UserID", widget.user.id)
                          : Container(),
                )
              : Container(),

          // Edit View
          edit
              ? Padding(
                  padding: editName
                      ? EdgeInsets.symmetric(horizontal: 24.0)
                      : EdgeInsets.all(24.0),
                  child: Column(
                    children: <Widget>[
                      !editName
                          ? GestureDetector(
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
                                              size: 3.0,
                                              image:
                                                  widget.user.customProfileIcon)
                                          : profileIcon,
                                    ),
                                  ),
                                  !editProfileI
                                      ? Icon(FeatherIcons.camera,
                                          color: Colors.white, size: 42.0)
                                      : Container(),
                                ],
                              ),
                              onTap: () => setState(() {
                                editProfileI = true;
                                profileIChanged = false;
                              }),
                            )
                          : Container(),
                      !editProfileI
                          ? Padding(
                              padding: editName
                                  ? EdgeInsets.zero
                                  : EdgeInsets.only(top: 24.0),
                              child: TextField(
                                autofocus: editName,
                                controller: _userNameController,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w500,
                                ),
                                onChanged: (_) =>
                                    setState(() => editName = true),
                                onTap: () => setState(() => editName = true),
                              ),
                            )
                          : Container(),

                      // Confirm Name Edit
                      editName
                          ? Padding(
                              padding: EdgeInsets.only(top: 12.0),
                              child: Row(
                                children: <Widget>[
                                  FlatButton(
                                    child: Text(I18n.of(context)
                                        .dialogCancel
                                        .toUpperCase()),
                                    onPressed: () {
                                      setState(() {
                                        nameChanged = false;
                                        editName = false;
                                      });
                                    },
                                  ),
                                  Spacer(),
                                  FlatButton(
                                      child: Text(
                                        I18n.of(context)
                                            .dialogDone
                                            .toUpperCase(),
                                        style: TextStyle(
                                          color: app.settings.appColor,
                                        ),
                                      ),
                                      onPressed: () {
                                        AccountHelper(
                                                user: widget.user,
                                                callback: widget.callback)
                                            .updateName(
                                                _userNameController.text,
                                                context);
                                        setState(() => editName = false);
                                      }),
                                ],
                              ))
                          : Container(),

                      // Edit Profile Icon
                      editProfileI
                          ? Padding(
                              padding: EdgeInsets.only(top: 12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  FlatButton(
                                    child: Text(I18n.of(context)
                                        .actionChange
                                        .toUpperCase()),
                                    onPressed: () {
                                      AccountHelper(
                                              user: widget.user,
                                              callback: widget.callback)
                                          .changeProfileI(context)
                                          .then((ProfileIcon result) {
                                        if (result != null)
                                          setState(() => profileIcon = result);
                                      });
                                    },
                                  ),
                                  FlatButton(
                                    child: Text(
                                      I18n.of(context)
                                          .actionDelete
                                          .toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() => profileIChanged = false);
                                      AccountHelper(
                                              user: widget.user,
                                              callback: widget.callback)
                                          .deleteProfileI();
                                    },
                                  ),
                                  FlatButton(
                                    child: Text(
                                      I18n.of(context).dialogDone.toUpperCase(),
                                      style: TextStyle(
                                        color: app.settings.appColor,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() => editProfileI = false);
                                    },
                                  ),
                                ],
                              ),
                            )
                          : Container()
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

class StudentDetail extends StatelessWidget {
  final String title;
  final String value;

  StudentDetail(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      children: <Widget>[
        Text(
          title +
              ":  ", //Had to change it the have the second word capital for german grammar. Adjuster i18n files accordingly.
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 16.0),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
