import 'package:flutter/material.dart';
import 'package:filcnaplo/data/models/evaluation.dart';
import 'package:filcnaplo/ui/cards/evaluation/tile.dart';
import 'package:filcnaplo/ui/pages/evaluations/grades/view.dart';

class GradeTile extends StatelessWidget {
  final Evaluation evaluation;
  final Function deleteCallback;
  final EdgeInsetsGeometry padding;

  GradeTile(
    this.evaluation, {
    this.padding = EdgeInsets.zero,
    this.deleteCallback,
  });

  @override
  Widget build(BuildContext context) {
    final bool isTemp = evaluation.id.startsWith("temp_");
    return Padding(
      padding: padding,
      child: MaterialButton(
        elevation: 0,
        highlightElevation: 0,
        child: EvaluationTile(evaluation, deleteCallback: deleteCallback),
        padding: EdgeInsets.only(right: 6.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        onPressed: isTemp
            ? () {}
            : () {
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
