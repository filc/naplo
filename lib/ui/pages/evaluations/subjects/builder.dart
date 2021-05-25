import 'package:filcnaplo/ui/pages/evaluations/subjects/tile.dart';
import 'package:filcnaplo/helpers/averages.dart';

class SubjectBuilder {
  List<SubjectTile> subjectTiles = [];

  void build() {
    subjectTiles = [];
    var averages = calculateSubjectAverages();
    averages.forEach((SubjectAverage s) {
      subjectTiles.add(SubjectTile(s.subject, s.average, s.classAverage));
    });

    subjectTiles.sort((a, b) => a.subject.name.compareTo(b.subject.name));
  }
}
