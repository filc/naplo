import 'package:filcnaplo/ui/cards/absence/tile.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/ui/cards/base.dart';
import 'package:filcnaplo/data/models/absence.dart';

class AbsenceCard extends BaseCard {
  final Absence absence;
  final DateTime compare;

  AbsenceCard(this.absence, {required this.compare}) : super(compare: compare);

  @override
  Widget build(BuildContext context) {
    return BaseCardWidget(
      child: Container(
        child: AbsenceTile(absence),
      ),
    );
  }
}
