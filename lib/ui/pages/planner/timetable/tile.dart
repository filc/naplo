import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/homework.dart';
import 'package:filcnaplo/data/models/lesson.dart';
import 'package:filcnaplo/data/models/exam.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/common/custom_chip.dart';
import 'package:filcnaplo/ui/pages/planner/exams/view.dart';
import 'package:filcnaplo/ui/pages/planner/homeworks/view.dart';
import 'package:filcnaplo/ui/pages/planner/timetable/view.dart';
import 'package:filcnaplo/utils/colors.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class LessonTile extends StatelessWidget {
  final Lesson lesson;

  LessonTile(this.lesson);

  @override
  Widget build(BuildContext context) {
    Homework homework;
    List<Exam> exams = [];

    if (lesson.homeworkId != null) {
      homework = app.user.sync.homework.homework
          .firstWhere((h) => h.id == lesson.homeworkId, orElse: () => null);
    }

    lesson.exams.forEach(
      (exam) => exams.add(
        app.user.sync.exam.exams
            .firstWhere((t) => t.id == exam, orElse: () => null),
      ),
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.0),
      child: MaterialButton(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
          side: accentColor != null && !lesson.isEmpty
              ? BorderSide(color: accentColor, width: 2.5)
              : BorderSide(color: Colors.transparent),
        ),
        child: Column(
          children: [
            ListTile(
              leading: Text(
                lesson.lessonIndex,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                  height: 1.35,
                  color: accentColor,
                ),
              ),
              title: Row(
                children: [
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
                        color: lesson.isEmpty
                            ? Colors.grey
                            : textColor(Theme.of(context).backgroundColor),
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      lesson.room,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.0,
                      ),
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
                children: [
                  Text(formatTime(lesson.start)),
                  Text(formatTime(lesson.end)),
                ],
              ),
            ),
            if (homework != null || exams.isNotEmpty)
              Container(
                padding: EdgeInsets.only(left: 70.0),
                margin: EdgeInsets.only(bottom: 5.0),
                child: Wrap(
                  alignment: WrapAlignment.start,
                  runSpacing: 1.0,
                  children: [
                        homework != null
                            ? CustomChip(
                                color: textColor(
                                    Theme.of(context).backgroundColor),
                                icon: FeatherIcons.home,
                                text: escapeHtml(homework.content)
                                    .replaceAll("\n", " "),
                                onTap: () => showSlidingBottomSheet(
                                  context,
                                  useRootNavigator: true,
                                  builder: (context) =>
                                      homeworkView(homework, context),
                                ),
                              )
                            : Container(),
                        Container(), // DON'T DELETE, IT BREAKS ALIGNMENT SOMEHOW
                      ] +
                      exams
                          .map(
                            (exam) => CustomChip(
                              color:
                                  textColor(Theme.of(context).backgroundColor),
                              icon: FeatherIcons.edit2,
                              text: exam.description != null
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
        onPressed: () => lesson.isEmpty
            ? null
            : showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) => TimetableView(lesson),
              ),
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
      children: [
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
