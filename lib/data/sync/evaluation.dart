import 'dart:convert';

import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/evaluation.dart';
import 'package:filcnaplo/data/models/dummy.dart';

class EvaluationSync {
  List<Evaluation> evaluations = [];
  List<dynamic> averages = [];
  bool uiPending = true;

  Future<bool> sync() async {
    List<Evaluation> _evaluations;
    List<dynamic> _averages;

    if (!app.debugUser) {
      _evaluations = await app.user.kreta.getEvaluations();
      if (app.user.sync.student.student.groupId != null)
        _averages = await app.user.kreta
            .getAverages(app.user.sync.student.student.groupId);

      if (_evaluations == null) {
        await app.user.kreta.refreshLogin();
        _evaluations = await app.user.kreta.getEvaluations();
        if (app.user.sync.student.student.groupId != null)
          _averages = await app.user.kreta
              .getAverages(app.user.sync.student.student.groupId);
      }

      if (_evaluations != null) {
        _evaluations.sort((a, b) => -a.writeDate.compareTo(b.writeDate));
        evaluations = _evaluations;
        if (_averages != null) averages = _averages;

        await app.user.storage.delete("evaluations");

        await Future.forEach(evaluations, (evaluation) async {
          if (evaluation.json != null) {
            await app.user.storage.insert("evaluations", {
              "json": jsonEncode(evaluation.json),
            });
          }
        });
      }

      uiPending = true;

      return _evaluations != null;
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
