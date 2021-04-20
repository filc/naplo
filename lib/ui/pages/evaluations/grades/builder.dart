import 'package:filcnaplo/data/models/evaluation.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/ui/pages/evaluations/grades/tile.dart';
import 'package:flutter/material.dart';

class GradeBuilder {
  List<GradeTile> gradeTiles = [];

  void build({EvaluationType type, int sortBy}) {
    // sortBy
    // 0 date
    // 1 date R
    // 2 write date
    // 3 write date R
    // 4 value
    // 5 value R

    gradeTiles = [];
    List<Evaluation> evaluations = app.user.sync.evaluation.evaluations
        .where((evaluation) => evaluation.type == type)
        .toList();

    if (sortBy != null) {
      switch (sortBy) {
        case 0: //Date forward
          evaluations.sort(
            (a, b) => -a.date.compareTo(b.date),
          );
          break;
        case 1: //Date backward
          evaluations.sort(
            (a, b) => a.date.compareTo(b.date),
          );
          break;
        case 2: //WriteDate forward
          evaluations.sort(
            (a, b) => -(a.writeDate ?? DateTime.fromMillisecondsSinceEpoch(0))
                .compareTo(
                    b.writeDate ?? DateTime.fromMillisecondsSinceEpoch(0)),
          );
          break;
        case 3: //WriteDate backward
          evaluations.sort(
            (a, b) => (a.writeDate ?? DateTime.fromMillisecondsSinceEpoch(0))
                .compareTo(
                    b.writeDate ?? DateTime.fromMillisecondsSinceEpoch(0)),
          );
          break;
        case 4: //Value better first
          var dicseretesek = evaluations
              .where((element) => element.description == "Dicséret")
              .toList();
          evaluations.removeWhere((element) => dicseretesek.contains(element));

          evaluations.sort(
            (a, b) => -(a.value.value ?? 0).compareTo(b.value.value ?? 0),
          );

          evaluations.insertAll(0, dicseretesek);
          break;
        case 5: //Value worse first
          var dicseretesek = evaluations
              .where((element) => element.description == "Dicséret")
              .toList();
          evaluations.removeWhere((element) => dicseretesek.contains(element));

          evaluations.sort(
            (a, b) => (a.value.value ?? 0).compareTo(b.value.value ?? 0),
          );

          evaluations.addAll(dicseretesek);
          break;
      }
    } else {
      evaluations.sort(
        (a, b) => -a.date.compareTo(b.date),
      );
    }

    evaluations.forEach(
      (evaluation) => gradeTiles.add(GradeTile(
        evaluation,
        padding: EdgeInsets.only(bottom: 4.0),
      )),
    );
  }
}
