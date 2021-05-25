import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/exam.dart';
import 'package:filcnaplo/ui/pages/planner/exams/tile.dart';

class ExamBuilder {
  List<List<ExamTile>> examTiles = [[], []];

  void build() {
    examTiles = [[], []];

    List<Exam> exams = app.user.sync.exam.exams;

    exams.sort((a, b) => -a.date!.compareTo(b.date!));
    
    DateTime now = DateTime.now();
    examTiles[0] = exams
        .where((t) => t.writeDate!.isAfter(now))
        .map((t) => ExamTile(t, false))
        .toList();

    examTiles[1] = exams
        .where((t) => t.writeDate!.isBefore(now))
        .map((t) => ExamTile(t, true))
        .toList();
  }
}
