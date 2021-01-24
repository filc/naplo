import 'dart:convert';

import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/evaluation.dart';
import 'package:filcnaplo/data/models/dummy.dart';

class EvaluationSync {
  List<Evaluation> evaluations = [];
  List<dynamic> averages = [];

  Future<bool> sync() async {
    if (!app.debugUser) {
      evaluations = await app.user.kreta.getEvaluations() ?? [];
      if (app.user.sync.student.data.groupId != null)
        averages = await app.user.kreta
            .getAverages(app.user.sync.student.data.groupId);

      if (evaluations == null) {
        await app.user.kreta.refreshLogin();
        evaluations = await app.user.kreta.getEvaluations() ?? [];
        if (app.user.sync.student.data.groupId != null)
          averages = await app.user.kreta
              .getAverages(app.user.sync.student.data.groupId);
      }

      if (evaluations != null) {
        evaluations = evaluations;
        if (averages != null) averages = averages;

        await app.user.storage.delete("evaluations");

        await Future.forEach(evaluations, (evaluation) async {
          if (evaluation.json != null) {
            await app.user.storage.insert("evaluations", {
              "json": jsonEncode(evaluation.json),
            });
          }
        });
      }

      return evaluations != null;
    } else {
      evaluations = Dummy.evaluations;
      return true;
    }
  }

  delete() {
    evaluations = [];
    averages = [];
  }
}
