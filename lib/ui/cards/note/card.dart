import 'package:filcnaplo/ui/cards/note/tile.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/ui/cards/base.dart';
import 'package:filcnaplo/data/models/note.dart';

class NoteCard extends BaseCard {
  final Note note;
  final DateTime compare;

  NoteCard(this.note, {required this.compare}) : super(compare: compare);

  @override
  Widget build(BuildContext context) {
    return BaseCardWidget(
      child: NoteTile(note),
    );
  }
}
