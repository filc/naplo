import 'package:filcnaplo/ui/cards/homework/tile.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/ui/cards/base.dart';
import 'package:filcnaplo/data/models/homework.dart';

class HomeworkCard extends BaseCard {
  final Homework homework;
  final DateTime compare;

  HomeworkCard(this.homework, {required this.compare}) : super(compare: compare);

  @override
  Widget build(BuildContext context) {
    return BaseCardWidget(
      child: HomeworkTile(homework),
    );
  }
}
