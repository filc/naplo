import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/homework.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/ui/pages/planner/homeworks/view.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class HomeworkTile extends StatelessWidget {
  final Homework homework;

  HomeworkTile(this.homework);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showSlidingBottomSheet(
          context,
          useRootNavigator: true,
          builder: (context) => homeworkView(homework, context),
        );
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 46.0,
          height: 46.0,
          alignment: Alignment.center,
          child: Icon(FeatherIcons.home, color: app.settings.appColor),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                capital(homework.subjectName),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(formatDate(context, homework.date)),
            ),
          ],
        ),
        subtitle: Text(
          escapeHtml(homework.content).replaceAll("\n", " "),
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
