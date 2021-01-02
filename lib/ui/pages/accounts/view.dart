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
  ProfileIcon profileIcon;

  @override
  Widget build(BuildContext context) {
    Student student = app.sync.users[widget.user.id] != null
        ? app.sync.users[widget.user.id].student.data
        : null;

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
          // User
          Padding(
            padding: EdgeInsets.only(top: 12.0, bottom: 4.0),
            child: ListTile(
              leading: GestureDetector(
                child: ProfileIcon(
                    name: widget.user.name,
                    size: 1.2,
                    image: widget.user.customProfileIcon),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => Center(
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
          ),

          // User Details
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
            child: student != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      widget.user.name != widget.user.realName
                          ? StudentDetail(I18n.of(context).studentRealName,
                              widget.user.realName)
                          : Container(),
                      student.school.name != ""
                          ? StudentDetail(I18n.of(context).studentSchool,
                              student.school.name)
                          : Container(),
                      student.birth != null
                          ? StudentDetail(I18n.of(context).studentBirth,
                              DateFormat("yyyy. MM. dd.").format(student.birth))
                          : Container(),
                      student.address != null
                          ? StudentDetail(
                              I18n.of(context).studentAddress, student.address)
                          : Container(),
                      student.parents != null
                          ? student.parents.length > 0
                              ? StudentDetail(I18n.of(context).studentParents,
                                  student.parents.join(", "))
                              : Container()
                          : Container(),
                    ],
                  )
                : app.debugMode
                    ? StudentDetail("UserID", widget.user.id)
                    : Container(),
          ),
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
          capitalize(title) + ":  ",
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
