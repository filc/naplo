import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/exam.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';

class ExamTile extends StatelessWidget {
  final Exam exam;

  ExamTile(this.exam);

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
              size: 30)),
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              exam.mode.description,
              overflow: TextOverflow.ellipsis,
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
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
