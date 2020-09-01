import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/evaluation.dart';
import 'package:filcnaplo/ui/pages/evaluations/subjects/tile.dart';

class SubjectBuilder {
  List<SubjectTile> subjectTiles = [];

  void build() {
    subjectTiles = [];

    List<Evaluation> evaluations = app.user.sync.evaluation.data[0]
        .where((evaluation) => evaluation.type.name == "evkozi_jegy_ertekeles")
        .toList();

    evaluations.forEach((evaluation) {
      if (!subjectTiles
          .map((SubjectTile s) => s.subject.id)
          .toList()
          .contains(evaluation.subject.id)) {
        double average = 0;
        double classAverage = 0;

        List<Evaluation> subjectEvals = evaluations
            .where((e) => e.subject.id == evaluation.subject.id)
            .toList();

        subjectEvals.forEach((e) {
          average += e.value.value * (e.value.weight / 100);
        });

        average = average /
            subjectEvals
                .map((e) => e.value.weight / 100)
                .reduce((a, b) => a + b);

        classAverage = app.user.sync.evaluation.data[1].firstWhere(
            (a) => a[0].id == evaluation.subject.id,
            orElse: () => [null, 0.0])[1];

        if (average.isNaN) average = 0.0;

        subjectTiles
            .add(SubjectTile(evaluation.subject, average, classAverage));
      }
    });

    subjectTiles.sort((a, b) => a.subject.name.compareTo(b.subject.name));
  }
}
