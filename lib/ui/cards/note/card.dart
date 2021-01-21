import 'package:filcnaplo/ui/cards/note/tile.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/ui/cards/card.dart';
import 'package:filcnaplo/data/models/note.dart';


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
      child: NoteTile(note),
    );
  }
}
