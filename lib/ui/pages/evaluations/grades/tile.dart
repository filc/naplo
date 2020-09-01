import 'package:flutter/material.dart';
import 'package:filcnaplo/data/models/evaluation.dart';
import 'package:filcnaplo/ui/cards/evaluation/tile.dart';
import 'package:filcnaplo/ui/cards/evaluation/view.dart';

class GradeTile extends StatelessWidget {
  final Evaluation evaluation;

  GradeTile(this.evaluation);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: EvaluationTile(evaluation),
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) => EvaluationView(evaluation),
        );
      },
    );
  }
}
