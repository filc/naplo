import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/lesson.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/common/bottom_card.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimetableView extends StatelessWidget {
  final Lesson lesson;

  TimetableView(this.lesson);

  @override
  Widget build(BuildContext context) {
    return BottomCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.only(left: 4.0),
            leading: Container(
              child: Text(
                lesson.lessonIndex + (lesson.lessonIndex != "+" ? "." : ""),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 42.0,
                  height: 1.15,
                  color: app.settings.appColor,
                ),
              ),
            ),
            title: Text(
              lesson.subject != null
                  ? capital(lesson.subject!.name)
                  : I18n.of(context).unknown,
            ),
            subtitle: Text(
              capitalize(lesson.substituteTeacher != ""
                  ? lesson.substituteTeacher
                  : lesson.teacher),
              softWrap: false,
              overflow: TextOverflow.fade,
            ),
            trailing: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                DateFormat("HH:mm").format(lesson.start!) +
                    "\n" +
                    DateFormat("HH:mm").format(lesson.end!),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Lesson Details
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              lesson.room != ""
                  ? TimetableDetail(I18n.of(context).lessonRoom, lesson.room)
                  : Container(),
              lesson.groupName != null
                  ? TimetableDetail(
                      I18n.of(context).lessonGroup, lesson.groupName ?? "")
                  : Container(),
              lesson.description != ""
                  ? TimetableDetail(
                      I18n.of(context).evaluationDescription,
                      lesson.description,
                    )
                  : Container(),
              lesson.lessonYearIndex != null
                  ? TimetableDetail(
                      I18n.of(context).timetableYearly,
                      lesson.lessonYearIndex.toString() + ".",
                    )
                  : Container(),
              lesson.status!.name != "Naplozott"
                  ? TimetableDetail(
                      I18n.of(context).state,
                      lesson.status!.description,
                    )
                  : Container(),
              lesson.substituteTeacher != ""
                  ? TimetableDetail(
                      I18n.of(context).substituteTeacher,
                      lesson.substituteTeacher,
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }
}

class TimetableDetail extends StatelessWidget {
  final String title;
  final String value;

  TimetableDetail(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      children: [
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
