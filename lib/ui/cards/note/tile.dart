import 'package:filcnaplo/data/models/note.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo/ui/common/profile_icon.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/ui/cards/miss/tile.dart';
import 'package:filcnaplo/ui/pages/messages/note/view.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class NoteTile extends StatelessWidget {
  final Note note;

  NoteTile(this.note);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                children: [
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
              onTap: () {
                showSlidingBottomSheet(
                  context,
                  useRootNavigator: true,
                  builder: (BuildContext context) => noteView(note, context),
                );
              },
            ),
    );
  }
}
