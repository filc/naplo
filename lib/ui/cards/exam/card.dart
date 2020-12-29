import 'package:filcnaplo/ui/cards/exam/tile.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/ui/cards/card.dart';
import 'package:filcnaplo/data/models/exam.dart';
import 'package:filcnaplo/ui/pages/planner/exams/view.dart';

class ExamCard extends BaseCard {
  final Exam exam;
  final Key key;
  final DateTime compare;

  ExamCard(this.exam, {this.compare, this.key});

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      key: key,
      compare: compare,
      child: GestureDetector(
        child: Container(
          child: ExamTile(exam),
        ),
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) => ExamView(exam),
          );
        },
      ),
    );
  }
}
