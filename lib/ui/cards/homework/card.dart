import 'package:filcnaplo/ui/cards/homework/tile.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/ui/card.dart';
import 'package:filcnaplo/data/models/homework.dart';
import 'package:filcnaplo/ui/pages/planner/homeworks/view.dart';

class HomeworkCard extends BaseCard {
  final Homework homework;
  final Key key;
  final DateTime compare;

  HomeworkCard(this.homework, {this.compare, this.key});

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      key: key,
      compare: compare,
      child: GestureDetector(
        child: Container(
          child: HomeworkTile(homework),
        ),
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) => HomeworkView(homework, () => {}),
          );
        },
      ),
    );
  }
}
