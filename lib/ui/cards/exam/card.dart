import 'package:filcnaplo/ui/cards/exam/tile.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/ui/cards/base.dart';
import 'package:filcnaplo/data/models/exam.dart';

class ExamCard extends BaseCard {
  final Exam exam;
  final DateTime compare;

  ExamCard(this.exam, {required this.compare}) : super(compare: compare);

  @override
  Widget build(BuildContext context) {
    return BaseCardWidget(
      child: ExamTile(exam),
    );
  }
}
