import 'dart:math';
import 'package:filcnaplo/data/models/lesson.dart';
import 'package:filcnaplo/ui/pages/planner/timetable/tile.dart';

class Day {
  List<Lesson> lessons;
  DateTime date;
  List<LessonTile> tiles = [];

  Day({this.lessons = const [], this.date});

  void buildTiles() {
    var lessonIndexes = lessons
        .map((l) => int.parse(l.lessonIndex != "+" ? l.lessonIndex : '0'));
    int minIndex = lessonIndexes.reduce(min);
    int maxIndex = lessonIndexes.reduce(max);

    tiles = [];

    List<int>.generate(maxIndex - minIndex + 1, (int i) => minIndex + i)
        .forEach((int i) {
      var lesson = lessons.firstWhere(
          (l) => int.parse(l.lessonIndex != "+" ? l.lessonIndex : '0') == i,
          orElse: () => Lesson.fromJson({'isEmpty': true, 'Oraszam': i}));
      if (lesson.subject != null) tiles.add(LessonTile(lesson));
    });
  }
}
