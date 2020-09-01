import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/profile_icon.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/data/models/absence.dart';
import 'package:intl/intl.dart';

class DelayView extends StatelessWidget {
  final Absence delay;

  DelayView(this.delay);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 14.0),
      decoration: BoxDecoration(
        color: app.settings.theme.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: ProfileIcon(name: delay.teacher),
            title: Row(
              children: [
                Expanded(
                  child: Text(delay.teacher, overflow: TextOverflow.ellipsis),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Text(formatDate(context, delay.date)),
                ),
              ],
            ),
            subtitle: Text(
              capital(delay.subject.name),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Absence Details
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DelayDetail(
                  I18n.of(context).delayAmount,
                  delay.delay.toString() + " " + I18n.of(context).timeMinute,
                ),
                DelayDetail(
                  I18n.of(context).delayLesson,
                  delay.lessonIndex.toString() +
                      ". (" +
                      DateFormat("HH:mm").format(delay.lessonStart) +
                      " - " +
                      DateFormat("HH:mm").format(delay.lessonEnd) +
                      ")",
                ),
                DelayDetail(
                  I18n.of(context).delayMode,
                  delay.mode.description,
                ),
                DelayDetail(
                  I18n.of(context).delayState,
                  delay.state.toString(),
                ),
                DelayDetail(
                  I18n.of(context).administrationTime,
                  formatDate(context, delay.submitDate, showTime: true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DelayDetail extends StatelessWidget {
  final String title;
  final String value;

  DelayDetail(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      children: <Widget>[
        Text(
          capital(title) + ":  ",
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
