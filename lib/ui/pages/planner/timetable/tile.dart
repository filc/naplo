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
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          boxShadow: app.settings.theme.brightness == Brightness.light
              ? [
                  BoxShadow(
                      blurRadius: 6.0,
                      spreadRadius: -2.0,
                      color: Colors.black26),
                ]
              : [],
          border:
              lesson.status.name == "Elmaradt" || lesson.substituteTeacher != ""
                  ? Border.all(
                      color: lesson.status.name == "Elmaradt"
                          ? Colors.red[400]
                          : lesson.substituteTeacher != ""
                              ? Colors.yellow[600]
                              : null,
                      width: 2)
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
                  color: lesson.status.name == "Elmaradt"
                      ? Colors.red[400]
                      : lesson.substituteTeacher != ""
                          ? Colors.yellow[600]
                          : null,
                ),
              ),
              title: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      capital(lesson.subject != null
                          ? lesson.subject.name
                          : I18n.of(context).unknown),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    lesson.room,
                    style: TextStyle(color: Colors.grey),
                  )
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
      onTap: () => showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => TimetableView(lesson, homework, exams),
      ),
    );
  }

  String formatTime(DateTime time) =>
      time.hour.toString() + ":" + time.minute.toString().padLeft(2, "0");
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
