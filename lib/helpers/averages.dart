import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/evaluation.dart';
import 'package:filcnaplo/data/models/subject.dart';

class SubjectAverage {
  SubjectAverage(this.subject, this.average, this.classAverage);
  final Subject subject;
  final double average;
  final double classAverage;
}

int roundSubjectAverage(Subject subject, double average) {
  /* print(subject.name +
      " " +
      subject.category.name +
      "|" +
      subject.category.description +
      "|" +
      subject.category.id); */

  // todo: ability to change rounding point of each subject
  return average.round();
}

List<SubjectAverage> calculateSubjectsAverage() {
  List<Evaluation> evaluations = app.user.sync.evaluation.data[0]
      .where((evaluation) => evaluation.type.name == "evkozi_jegy_ertekeles")
      .toList();
  List<SubjectAverage> averages = [];
  evaluations.forEach((evaluation) {
    if (!averages
        .map((SubjectAverage s) => s.subject.id)
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
          subjectEvals.map((e) => e.value.weight / 100).reduce((a, b) => a + b);

      classAverage = app.user.sync.evaluation.data[1].firstWhere(
          (a) => a[0].id == evaluation.subject.id,
          orElse: () => [null, 0.0])[1];

      if (average.isNaN) average = 0.0;

      averages.add(SubjectAverage(evaluation.subject, average, classAverage));
    }
  });
  return averages;
}
