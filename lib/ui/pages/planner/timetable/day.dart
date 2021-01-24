import 'dart:math';
import 'package:filcnaplo/data/models/lesson.dart';
import 'package:filcnaplo/ui/pages/planner/timetable/tile.dart';

class Day {
  List<Lesson> lessons;
  DateTime date;
  List<LessonTile> tiles = [];

  Day({this.lessons = const [], this.date});

  void buildTiles() {
    var namedLessons = lessons.where((l) => l.subject != null);

    if (
      namedLessons.any((l) => l.lessonIndex == "+")
    ) {
      return namedLessons.forEach((l) {
        tiles.add(LessonTile(l));
      });
    }

    var lessonIndexes = namedLessons
        .map((l) => int.parse(l.lessonIndex));
  
    int minIndex = lessonIndexes.reduce(min);
    int maxIndex = lessonIndexes.reduce(max);

    tiles = [];

    List<int>.generate(maxIndex - minIndex + 1, (int i) => minIndex + i)
        .forEach((int i) {
      var lesson = namedLessons.firstWhere(
          (l) => int.parse(l.lessonIndex) == i,
          orElse: () => Lesson.fromJson({'isEmpty': true, 'Oraszam': i}));
      tiles.add(LessonTile(lesson));
    });
  }
}
