import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/evaluation.dart';
import 'package:filcnaplo/utils/format.dart';

Future syncEvaluations() async {
  List<Evaluation> previousEvals = app.user.sync.evaluation.evaluations;
  print(previousEvals.length);
  await Future.delayed(Duration(seconds: 20));
  await app.user.sync.evaluation.sync();
  print(app.user.sync.evaluation.evaluations.length);
  List<Evaluation> newEvals = app.user.sync.evaluation.evaluations
      .where((e) => !previousEvals.contains(e))
      .toList();
  await Future.forEach(newEvals, (e) async {
    if (e != null)
      await app.notifications.show(
        title: e.type == EvaluationType.midYear
            ? e.description != ""
                ? capital(e.description)
                : capital(e.mode != null
                        ? e.mode.description
                        : e.value.valueName.split("(")[0]) +
                    " " +
                    (e.value.weight != 100
                        ? e.value.weight.toString() + "%"
                        : "")
            : capital(e.subject != null ? e.subject.name : "?"),
        body: e.type == EvaluationType.midYear
            ? capital(e.subject != null
                ? e.subject.name
                : "?" +
                    (e.description != ""
                        ? (e.mode != null
                            ? "\n" +
                                e.mode.description +
                                " " +
                                (e.value.weight != 100
                                    ? e.value.weight.toString() + "%"
                                    : "")
                            : e.form != null
                                ? "\n" + e.form
                                : "")
                        : ""))
            : e.value.valueName.split("(")[0],
      );
  });
}
