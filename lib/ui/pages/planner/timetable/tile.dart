import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/homework.dart';
import 'package:filcnaplo/data/models/lesson.dart';
import 'package:filcnaplo/data/models/exam.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/pages/planner/timetable/view.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';

class LessonTile extends StatelessWidget {
  final Lesson lesson;

  LessonTile(this.lesson);

  @override
  Widget build(BuildContext context) {
    Homework homework;
    List<Exam> exams = [];

    if (lesson.homeworkId != null) {
      homework = app.user.sync.homework.data
          .firstWhere((h) => h.id == lesson.homeworkId, orElse: () => null);
    }

    lesson.exams.forEach((exam) => exams.add(
          app.user.sync.exam.data
              .firstWhere((t) => t.id == exam, orElse: () => null),
        ));

    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: app.settings.theme.backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(14.0)),
          boxShadow: app.settings.theme.brightness == Brightness.light
              ? [
                  BoxShadow(
                      blurRadius: 6.0,
                      spreadRadius: -2.0,
                      color: Colors.black26),
                ]
              : [],
          border: accentColor != null
              ? Border.all(color: accentColor, width: 2)
              : null,
        ),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Text(
                lesson.lessonIndex,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                  height: 1.15,
                  color: accentColor,
                ),
              ),
              title: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Text(
                      capital(lesson.subject != null
                          ? lesson.subject.name
                          : lesson.isEmpty
                              ? I18n.of(context).lessonEmpty
                              : I18n.of(context).unknown),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          lesson.isEmpty ? TextStyle(color: Colors.grey) : null,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      lesson.room,
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(formatTime(lesson.start)),
                  Text(formatTime(lesson.end)),
                ],
              ),
            ),
            homework != null
                ? Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 12.0),
                    child: Row(
                      children: <Widget>[
                        Icon(FeatherIcons.home),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              homework.content != ""
                                  ? escapeHtml(homework.content)
                                  : homework.teacher,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
            exams.length > 0
                ? Column(
                    children: exams
                        .map((exam) => Padding(
                              padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 12.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(FeatherIcons.edit),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        exam.description != ""
                                            ? exam.description
                                            : exam.mode.description,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  )
                : Container()
          ],
        ),
      ),
      onTap: () => lesson.isEmpty
          ? null
          : showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) => TimetableView(lesson, homework, exams),
            ),
    );
  }

  get accentColor {
    if (lesson.status?.name == "Elmaradt") return Colors.red[400];
    if (lesson.substituteTeacher != "") return Colors.yellow[600];
    if (lesson.isEmpty) return Colors.grey;
    return null;
  }

  String formatTime(DateTime time) => time != null
      ? time.hour.toString() + ":" + time.minute.toString().padLeft(2, "0")
      : '';
}

class SpecialDateTile extends LessonTile {
  final Lesson lesson;

  SpecialDateTile(this.lesson) : super(lesson);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          margin: EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 8.0),
          constraints:
              //haxx
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 24),
          decoration: BoxDecoration(
            color: app.settings.theme.backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(45.0)),
            boxShadow: app.settings.theme.brightness == Brightness.light
                ? [
                    BoxShadow(
                        blurRadius: 6.0,
                        spreadRadius: -2.0,
                        color: Colors.black26),
                  ]
                : [],
          ),
          child: Text(
            lesson.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
