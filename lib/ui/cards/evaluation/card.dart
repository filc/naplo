import 'package:filcnaplo/ui/cards/evaluation/tile.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/ui/cards/base.dart';
import 'package:filcnaplo/data/models/evaluation.dart';

class EvaluationCard extends BaseCard {
  final Evaluation evaluation;
  final DateTime compare;

  EvaluationCard(this.evaluation, {required this.compare}) : super(compare: compare);

  @override
  Widget build(BuildContext context) {
    return BaseCardWidget(
      padding: evaluation.description != "" &&
              evaluation.mode != null &&
              evaluation.mode!.description != ""
          ? EdgeInsets.all(12)
          : EdgeInsets.symmetric(horizontal: 12.0),
      child: EvaluationTile(evaluation),
    );
  }
}
