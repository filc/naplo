import 'package:filcnaplo/ui/cards/note/tile.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/ui/card.dart';
import 'package:filcnaplo/data/models/note.dart';
import 'package:filcnaplo/ui/pages/messages/note/view.dart';

class NoteCard extends BaseCard {
  final Note note;
  final Key key;
  final DateTime compare;

  NoteCard(this.note, {this.compare, this.key});

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      key: key,
      compare: compare,
      child: GestureDetector(
        child: Container(
          child: NoteTile(note),
        ),
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (BuildContext context) => NoteView(note),
          );
        },
      ),
    );
  }
}
