import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/exam.dart';
import 'package:filcnaplo/ui/pages/planner/exams/view.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';

class ExamTile extends StatelessWidget {
  final Exam exam;
  final bool isPast;

  ExamTile(this.exam, this.isPast);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Row(
          children: [
            Icon(
              isPast ? FeatherIcons.checkSquare : FeatherIcons.edit,
              color: isPast ? Colors.green : app.settings.appColor,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Text(
                  capital(exam.subjectName) +
                      " (" +
                      exam.subjectIndex.toString() +
                      ".)",
                  softWrap: false,
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
            Text(formatDate(context, exam.writeDate)),
          ],
        ),
      ),
      onTap: () => showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => ExamView(exam),
      ),
    );
  }
}
