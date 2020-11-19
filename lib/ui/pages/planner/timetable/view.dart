import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/homework.dart';
import 'package:filcnaplo/data/models/lesson.dart';
import 'package:filcnaplo/data/models/exam.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/bottom_card.dart';
import 'package:filcnaplo/ui/pages/planner/homeworks/view.dart';
import 'package:filcnaplo/ui/pages/planner/exams/view.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimetableView extends StatelessWidget {
  final Lesson lesson;
  final Homework homework;
  final List<Exam> exams;

  TimetableView(this.lesson, this.homework, this.exams);

  @override
  Widget build(BuildContext context) {
    return BottomCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
                ),
              ),
            ),
            title: Text(
              lesson.subject != null
                  ? capital(lesson.subject.name)
                  : I18n.of(context).unknown,
            ),
            subtitle: Text(
              capitalize(lesson.substituteTeacher != ""
                  ? lesson.substituteTeacher
                  : lesson.teacher),
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                DateFormat("HH:mm").format(lesson.start) +
                    "\n" +
                    DateFormat("HH:mm").format(lesson.end),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Lesson Details
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              lesson.room != ""
                  ? TimetableDetail(I18n.of(context).lessonRoom, lesson.room)
                  : Container(),
              lesson.groupName != null
                  ? TimetableDetail(
                      I18n.of(context).lessonGroup, lesson.groupName)
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
              lesson.status.name != "Naplozott"
                  ? TimetableDetail(
                      I18n.of(context).state,
                      lesson.status.description,
                    )
                  : Container(),
              lesson.substituteTeacher != ""
                  ? TimetableDetail(
                      I18n.of(context).substituteTeacher,
                      lesson.substituteTeacher,
                    )
                  : Container(),
              homework != null ? homeworkButton(context) : Container(),
              exams.length > 0
                  ? Column(
                      children: exams
                          .map((exam) => examButton(context, exam))
                          .toList(),
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }

  Widget homeworkButton(BuildContext context) {
    return FlatButton(
      onPressed: () => showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => HomeworkView(homework),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
      padding: EdgeInsets.symmetric(horizontal: 6.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(FeatherIcons.home, color: app.settings.appColor),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              capital(I18n.of(context).homework),
              style: TextStyle(fontSize: 18.0, color: app.settings.appColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget examButton(BuildContext context, Exam exam) {
    return FlatButton(
      onPressed: () => showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => ExamView(exam),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
      padding: EdgeInsets.symmetric(horizontal: 6.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(FeatherIcons.edit, color: app.settings.appColor),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              I18n.of(context).exam,
              style: TextStyle(fontSize: 18.0, color: app.settings.appColor),
            ),
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
