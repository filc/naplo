import 'package:flutter/material.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/utils/format.dart';

class ToDoTile extends StatelessWidget {
  final String subject;
  final String description;
  final DateTime writeDate;

  ToDoTile(this.subject, this.description, this.writeDate);
  Widget build(BuildContext context) {
    List<String> days = [
      I18n.of(context).dateMonday,
      I18n.of(context).dateTuesday,
      I18n.of(context).dateWednesday,
      I18n.of(context).dateThursday,
      I18n.of(context).dateFriday,
      I18n.of(context).dateSaturday,
      I18n.of(context).dateSunday
    ];
    String details =
        capital(subject) + " (" + days[writeDate.weekday - 1] + ")";
    TextPainter painter = TextPainter(
        text: TextSpan(text: details), textDirection: TextDirection.ltr);
    painter.layout();

    return Padding(child: Column(
      children: [
        Row(
          children: [
            Flexible(
              child: Text(escapeHtml(description),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
            )
          ]
        ),
        Text(details)
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    ), padding: EdgeInsets.symmetric(vertical: 8));
  }
}
