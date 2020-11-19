import 'package:flutter/material.dart';
import 'package:filcnaplo/data/models/evaluation.dart';
import 'package:filcnaplo/ui/cards/evaluation/tile.dart';
import 'package:filcnaplo/ui/pages/evaluations/grades/view.dart';

class GradeTile extends StatelessWidget {
  final Evaluation evaluation;
  final Function deleteCallback;

  GradeTile(this.evaluation, {this.deleteCallback});

  @override
  Widget build(BuildContext context) {
    final bool isTemp = evaluation.id.startsWith("temp_");
    return GestureDetector(
      child: EvaluationTile(evaluation, deleteCallback: deleteCallback),
      onTap: isTemp
          ? () {}
          : () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (BuildContext context) => EvaluationView(evaluation),
              );
            },
    );
  }
}
