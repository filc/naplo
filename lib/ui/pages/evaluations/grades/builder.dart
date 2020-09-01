import 'package:filcnaplo/data/models/evaluation.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/ui/pages/evaluations/grades/tile.dart';

class GradeBuilder {
  List<GradeTile> gradeTiles = [];

  void build({int sortBy}) {
    // sortBy
    // 0 date
    // 1 date R
    // 2 write date
    // 3 write date R
    // 4 value
    // 5 value R

    Map<String, int> evalTypes = {
      "evkozi_jegy_ertekeles": 0,
      "I_ne_jegy_ertekeles": 1,
      "II_ne_jegy_ertekeles": 2,
      "felevi_jegy_ertekeles": 3,
      "III_ne_jegy_ertekeles": 4,
      "IV_ne_jegy_ertekeles": 5,
      "evvegi_jegy_ertekeles": 6,
    };

    gradeTiles = [];
    List<Evaluation> evaluations = app.user.sync.evaluation.data[0]
        .where((evaluation) =>
            evalTypes[evaluation.type.name] == app.selectedEvalPage)
        .toList();

    if (sortBy != null) {
      switch (sortBy) {
        case 0:
          evaluations.sort(
            (a, b) => -a.date.compareTo(b.date),
          );
          break;
        case 1:
          evaluations.sort(
            (a, b) => a.date.compareTo(b.date),
          );
          break;
        case 2:
          evaluations.sort(
            (a, b) => -(a.writeDate ?? DateTime.fromMillisecondsSinceEpoch(0))
                .compareTo(
                    b.writeDate ?? DateTime.fromMillisecondsSinceEpoch(0)),
          );
          break;
        case 3:
          evaluations.sort(
            (a, b) => (a.writeDate ?? DateTime.fromMillisecondsSinceEpoch(0))
                .compareTo(
                    b.writeDate ?? DateTime.fromMillisecondsSinceEpoch(0)),
          );
          break;
        case 4:
          evaluations.sort(
            (a, b) => -(a.value.value ?? 0).compareTo(b.value.value ?? 0),
          );
          break;
        case 5:
          evaluations.sort(
            (a, b) => (a.value.value ?? 0).compareTo(b.value.value ?? 0),
          );
          break;
      }
    } else {
      evaluations.sort(
        (a, b) => -a.date.compareTo(b.date),
      );
    }

    evaluations.forEach(
      (evaluation) => gradeTiles.add(GradeTile(evaluation)),
    );
  }
}
