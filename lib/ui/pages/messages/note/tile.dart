import 'package:flutter/material.dart';
import 'package:filcnaplo/data/models/note.dart';
import 'package:filcnaplo/ui/profile_icon.dart';
import 'package:filcnaplo/ui/pages/messages/note/view.dart';
import 'package:filcnaplo/utils/format.dart';

class NoteTile extends StatelessWidget {
  final Note note;

  NoteTile(this.note);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        child: ListTile(
          leading: ProfileIcon(name: note.teacher),
          title: Row(
            children: <Widget>[
              Expanded(
                child: Text(note.teacher, overflow: TextOverflow.ellipsis),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(formatDate(context, note.date)),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                note.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                note.content,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (context) {
              return NoteView(note);
            },
          );
        },
      ),
    );
  }
}
