import 'package:filcnaplo/modules/now/upcoming_todos/tile.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/exam.dart';
import 'package:filcnaplo/data/models/homework.dart';

class ToDoBuilder {
  List<ToDoTile> examTiles = [];
  List<ToDoTile> homeworkTiles = [];
  void build() {
    DateTime now = DateTime.now();
    DateTime lastMidnight = DateTime(now.year, now.month, now.day);
    DateTime end = lastMidnight.add(Duration(days: 3));

    List<Exam> exams = List<Exam>.from(app.user.sync.exam.data);
    exams = exams.where((e) => e.writeDate.isAfter(now) && e.writeDate.isBefore(end)).toList();
    exams.sort((a, b) => -a.writeDate.compareTo(b.writeDate));
    examTiles = exams.map((e) => ToDoTile(e.subjectName, e.description, e.writeDate)).toList();

    List<Homework> homeworks = List<Homework>.from(app.user.sync.homework.data);
    homeworks = homeworks.where((h) => h.deadline.isAfter(now) && h.deadline.isBefore(end)).toList();
    homeworks.sort((a, b) => -a.deadline.compareTo(b.deadline));
    homeworkTiles = homeworks.map((h) => ToDoTile(h.subjectName, h.content, h.deadline)).toList();
  }
}
