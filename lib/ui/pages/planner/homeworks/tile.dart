import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/models/homework.dart';
import 'package:filcnaplo/ui/pages/planner/homeworks/view.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';

class HomeworkTile extends StatelessWidget {
  final Homework homework;
  final bool isPast;
  final Function(Homework) onDismissed;

  HomeworkTile(this.homework, this.isPast, this.onDismissed);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Dismissible(
        key: Key(homework.isSolved ? "s" : "u" + homework.id),
        secondaryBackground: Container(
          color: homework.isSolved ? Colors.red : Colors.green[600],
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 24.0),
          child: Icon(
            homework.isSolved ? FeatherIcons.x : FeatherIcons.check,
            color: Colors.white,
          ),
        ),
        background: Container(
          color: homework.isSolved ? Colors.red : Colors.green[600],
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 24.0),
          child: Icon(
            homework.isSolved ? FeatherIcons.x : FeatherIcons.check,
            color: Colors.white,
          ),
        ),
        onDismissed: (_) => onDismissed(homework),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                isPast
                    ? homework.isSolved ? FeatherIcons.check : FeatherIcons.x
                    : FeatherIcons.home,
                color: isPast
                    ? homework.isSolved ? Colors.green : Colors.red
                    : homework.isSolved ? Colors.green : Colors.yellow,
              ),
            ),
            title: Row(
              children: <Widget>[
                Expanded(
                  child: Text(capital(homework.subjectName)),
                ),
                Text(formatDate(context, homework.lessonDate ?? homework.date)),
              ],
            ),
            subtitle: homework.content != ""
                ? Text(
                    escapeHtml(homework.content),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : null,
          ),
        ),
      ),
      onTap: () => showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => HomeworkView(homework, onDismissed),
      ),
    );
  }
}
