import 'package:filcnaplo/data/models/exam.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/common/bottom_card.dart';
import 'package:filcnaplo/ui/common/profile_icon.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';

class ExamView extends StatelessWidget {
  final Exam exam;

  ExamView(this.exam);

  @override
  Widget build(BuildContext context) {
    return BottomCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: ProfileIcon(name: exam.teacher),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    exam.teacher != null
                        ? capitalize(exam.teacher)
                        : I18n.of(context).unknown,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                  ),
                ),
                Text(formatDate(context, exam.date))
              ],
            ),
            subtitle: Text(capital(exam.subjectName)),
          ),

          // Test details
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              exam.description != ""
                  ? TestDetail(
                      I18n.of(context).evaluationDescription,
                      exam.description,
                    )
                  : Container(),
              exam.writeDate != null
                  ? TestDetail(
                      I18n.of(context).evaluationWriteDate,
                      formatDate(context, exam.writeDate),
                    )
                  : Container(),
              exam.mode != null
                  ? TestDetail(
                      I18n.of(context).evaluationType,
                      exam.mode.description,
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }
}

class TestDetail extends StatelessWidget {
  final String title;
  final String value;

  TestDetail(this.title, this.value);

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
          softWrap: false,
          overflow: TextOverflow.fade,
        ),
      ],
    );
  }
}
