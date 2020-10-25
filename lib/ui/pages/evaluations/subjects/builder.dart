import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/evaluation.dart';
import 'package:filcnaplo/data/models/subject.dart';
import 'package:filcnaplo/ui/pages/evaluations/subjects/tile.dart';
import 'package:filcnaplo/helpers/averages.dart';

class SubjectBuilder {
  List<SubjectTile> subjectTiles = [];

  void build() {
    subjectTiles = [];
    var averages = calculateSubjectsAverage();
    averages.forEach((el) {
      subjectTiles.add(SubjectTile(el.subject, el.average, el.classAverage));
    });

    subjectTiles.sort((a, b) => a.subject.name.compareTo(b.subject.name));
  }
}
