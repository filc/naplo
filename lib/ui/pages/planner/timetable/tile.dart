import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/homework.dart';
import 'package:filcnaplo/data/models/lesson.dart';
import 'package:filcnaplo/data/models/exam.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/custom_chip.dart';
import 'package:filcnaplo/ui/pages/planner/exams/view.dart';
import 'package:filcnaplo/ui/pages/planner/homeworks/view.dart';
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

    lesson.exams.forEach(
      (exam) => exams.add(
        app.user.sync.exam.data
            .firstWhere((t) => t.id == exam, orElse: () => null),
      ),
    );

    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(14.0)),
          border: accentColor != null
              ? Border.all(color: accentColor, width: 2.5)
              : null,
        ),
        child: Column(
          children: <Widget>[
            ListTile(
              dense: true,
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    lesson.lessonIndex,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                      height: 1.35,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
              title: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Text(
                      capital(
                        lesson.subject != null
                            ? lesson.subject.name
                            : lesson.isEmpty
                                ? I18n.of(context).lessonEmpty
                                : I18n.of(context).unknown,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: lesson.isEmpty ? Colors.grey : Colors.white,
                        fontSize: 16.0,
                      ),
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
              subtitle: lesson.description != ""
                  ? Text(
                      lesson.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14.0),
                    )
                  : null,
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(formatTime(lesson.start)),
                  Text(formatTime(lesson.end)),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 70.0),
              margin: EdgeInsets.only(bottom: 5.0),
              child: Wrap(
                alignment: WrapAlignment.start,
                runSpacing: 1.0,
                children: <Widget>[
                      homework != null
                          ? chip(
                              iconData: FeatherIcons.home,
                              textString: escapeHtml(homework.content)
                                  .replaceAll("\n", " "),
                              onTap: () => showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                builder: (context) => HomeworkView(homework),
                              ),
                            )
                          : Container(),
                      Container(), // DON'T DELETE, IT BREAKS ALIGNMENT SOMEHOW
                    ] +
                    exams
                        .map(
                          (exam) => chip(
                            iconData: FeatherIcons.edit2,
                            textString: exam.description != null
                                ? exam.description.replaceAll("\n", " ")
                                : exam.mode.description,
                            onTap: () => showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) => ExamView(exam),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
          ],
        ),
      ),
      onTap: () => lesson.isEmpty
          ? null
          : showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) => TimetableView(lesson),
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
            borderRadius: BorderRadius.all(Radius.circular(45.0)),
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
