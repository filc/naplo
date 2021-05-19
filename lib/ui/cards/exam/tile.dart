import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/exam.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/ui/pages/planner/exams/view.dart';

class ExamTile extends StatelessWidget {
  final Exam exam;

  ExamTile(this.exam);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) => ExamView(exam),
        );
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 46.0,
          height: 46.0,
          alignment: Alignment.center,
          child: Icon(
            exam.writeDate.isAfter(DateTime.now())
                ? FeatherIcons.edit
                : FeatherIcons.checkSquare,
            color: exam.writeDate.isAfter(DateTime.now())
                ? app.settings.appColor
                : Colors.green,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                exam.mode.description,
                softWrap: false,
                overflow: TextOverflow.fade,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(formatDate(context, exam.date)),
            ),
          ],
        ),
        subtitle: Text(
          capital(exam.subjectName) +
              "\n" +
              exam.description.replaceAll("\n", " "),
          maxLines: 2,
          softWrap: false,
          overflow: TextOverflow.fade,
        ),
      ),
    );
  }
}
