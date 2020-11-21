import 'dart:math';
import 'package:filcnaplo/data/models/lesson.dart';
import 'package:filcnaplo/ui/pages/planner/timetable/tile.dart';

class Day {
  List<Lesson> lessons;
  DateTime date;

  Day({this.lessons = const [], this.date});

  List<LessonTile> get tiles {
    var lessonIndexes = lessons.map((l) => int.parse(l.lessonIndex));
    int minIndex = lessonIndexes.reduce(min);
    int maxIndex = lessonIndexes.reduce(max);

    List<LessonTile> tiles = [];

    new List<int>.generate(maxIndex - minIndex + 1, (int i) => minIndex + i)
        .forEach((int i) {
      var lesson = lessons.firstWhere((l) => int.parse(l.lessonIndex) == i,
          orElse: () => Lesson.fromJson({'isEmpty': true, 'Oraszam': i}));
      tiles.add(LessonTile(lesson));
    });
    return tiles;
  }
}
