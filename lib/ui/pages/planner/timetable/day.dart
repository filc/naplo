import 'package:filcnaplo/data/models/lesson.dart';
import 'package:filcnaplo/ui/pages/planner/timetable/tile.dart';
import 'package:flutter/material.dart';

class Day {
  List<Lesson> lessons;
  List<LessonTile> tiles;
  DateTime date;
  Widget specialDate;

  Day({this.lessons = const [], this.tiles = const [], this.date, this.specialDate});
}
