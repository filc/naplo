import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/exam.dart';
import 'package:filcnaplo/ui/pages/planner/exams/tile.dart';

class ExamBuilder {
  List<List<ExamTile>> examTiles = [[], []];

  void build() {
    examTiles = [[], []];

    List<Exam> exams = app.user.sync.exam.data;

    exams.sort((a, b) => -a.date.compareTo(b.date));

    examTiles[0] = exams
        .where((t) => t.date.isAfter(DateTime.now()))
        .map((t) => ExamTile(t, false))
        .toList();

    examTiles[1] = exams
        .where((t) => t.date.isBefore(DateTime.now()))
        .map((t) => ExamTile(t, true))
        .toList();
  }
}
