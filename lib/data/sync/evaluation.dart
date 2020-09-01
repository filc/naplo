import 'dart:convert';

import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/evaluation.dart';
import 'package:filcnaplo/data/models/dummy.dart';

class EvaluationSync {
  List<List> data = [[], []];

  Future<bool> sync() async {
    if (!app.debugUser) {
      List<Evaluation> evaluations;
      List averages;
      evaluations = await app.user.kreta.getEvaluations();
      averages =
          await app.user.kreta.getAverages(app.user.sync.student.data.groupId);

      if (evaluations == null) {
        await app.user.kreta.refreshLogin();
        evaluations = await app.user.kreta.getEvaluations();
        averages = await app.user.kreta
            .getAverages(app.user.sync.student.data.groupId);
      }

      if (evaluations != null) {
        data[0] = evaluations;
        if (averages != null) data[1] = averages;

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
      data[0] = Dummy.evaluations;
      return true;
    }
  }

  delete() {
    data = [[], []];
  }
}
