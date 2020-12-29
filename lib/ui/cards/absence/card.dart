import 'package:filcnaplo/ui/cards/absence/tile.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/ui/cards/card.dart';
import 'package:filcnaplo/data/models/absence.dart';
import 'package:filcnaplo/ui/pages/absences/absence/view.dart';

class AbsenceCard extends BaseCard {
  final Absence absence;
  final Key key;
  final DateTime compare;

  AbsenceCard(this.absence, {this.compare, this.key});

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      key: key,
      compare: compare,
      child: GestureDetector(
        child: Container(
          child: AbsenceTile(absence),
        ),
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) => AbsenceView(absence),
          );
        },
      ),
    );
  }
}
