import 'package:filcnaplo/data/models/note.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo/ui/profile_icon.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/ui/cards/miss/tile.dart';
import 'package:filcnaplo/ui/pages/messages/note/view.dart';

class NoteTile extends StatelessWidget {
  final Note note;

  NoteTile(this.note);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: (note.type.name == "HaziFeladatHiany" ||
              note.type.name == "Felszereleshiany")
          ? MissTile(note)
          : ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                  width: 46.0,
                  height: 46.0,
                  alignment: Alignment.center,
                  child: ProfileIcon(name: note.teacher)),
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
                note.title +
                    "\n" +
                    escapeHtml(note.content).replaceAll("\n", " "),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (BuildContext context) => NoteView(note),
        );
      },
    );
  }
}
