import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/homework.dart';
import 'package:filcnaplo/ui/pages/planner/homeworks/view.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class HomeworkTile extends StatelessWidget {
  final Homework homework;
  final bool isPast;
  final Function(Homework) onDismissed;

  HomeworkTile(this.homework, this.isPast, this.onDismissed);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            isPast ? FeatherIcons.check : FeatherIcons.home,
            color: isPast ? Colors.green : app.settings.appColor,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(capital(homework.subjectName)),
            ),
            Text(formatDate(context,
                homework.deadline ?? homework.lessonDate ?? homework.date)),
          ],
        ),
        subtitle: homework.content != ""
            ? Text(
                escapeHtml(homework.content),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        onTap: () => showSlidingBottomSheet(
          context,
          useRootNavigator: true,
          builder: (context) => homeworkView(homework, context),
        ),
      ),
    );
  }
}
