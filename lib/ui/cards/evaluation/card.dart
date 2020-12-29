import 'package:filcnaplo/ui/cards/evaluation/tile.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/ui/cards/card.dart';
import 'package:filcnaplo/ui/pages/evaluations/grades/view.dart';
import 'package:filcnaplo/data/models/evaluation.dart';

class EvaluationCard extends BaseCard {
  final Evaluation evaluation;
  final Key key;
  final DateTime compare;

  EvaluationCard(this.evaluation, {this.key, this.compare});

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      key: key,
      compare: compare,
      padding: evaluation.description != "" &&
              evaluation.mode != null &&
              evaluation.mode.description != ""
          ? EdgeInsets.all(12)
          : EdgeInsets.symmetric(horizontal: 12.0),
      child: GestureDetector(
        child: Container(
          child: EvaluationTile(evaluation),
        ),
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) => EvaluationView(evaluation),
          );
        },
      ),
    );
  }
}
