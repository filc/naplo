import 'package:filcnaplo/data/models/note.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo/ui/profile_icon.dart';
import 'package:flutter/material.dart';

class NoteTile extends StatelessWidget {
  final Note note;

  NoteTile(this.note);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 46.0,
        height: 46.0,
        alignment: Alignment.center,
        child: ProfileIcon(name: note.teacher)
      ),
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              note.teacher,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(formatDate(context, note.date)),
          ),
        ],
      ),
      subtitle: Text(
        note.title + "\n" + escapeHtml(note.content),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
