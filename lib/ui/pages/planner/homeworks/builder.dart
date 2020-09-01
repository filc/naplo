import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/homework.dart';
import 'package:filcnaplo/ui/pages/planner/homeworks/tile.dart';

class HomeworkBuilder {
  List<List<HomeworkTile>> homeworkTiles = [[], []];

  final Function callback;
  HomeworkBuilder(this.callback);

  void build() {
    homeworkTiles = [[], []];
    final DateTime now = DateTime.now();

    List<Homework> homeworks = app.user.sync.homework.data
        .where((h) => h.date.isAfter(now.subtract(Duration(days: 30))))
        .toList();

    homeworks.sort((a, b) => -a.date.compareTo(b.date));

    homeworkTiles[0] = homeworks
        .where((h) =>
            h.date.isBefore(now) && h.deadline.isAfter(now) && !h.isSolved)
        .map((h) => HomeworkTile(h, false, updateTiles))
        .toList();

    homeworkTiles[1] = homeworks
        .where((h) => h.isSolved || h.deadline.isBefore(now))
        .map((h) => HomeworkTile(h, true, updateTiles))
        .toList();
  }

  void updateTiles(Homework homework) {
    app.user.sync.homework.data
        .firstWhere((h) => h.id == homework.id)
        .isSolved = !homework.isSolved;
    homeworkTiles[0].removeWhere((t) => t.homework.id == homework.id);
    homeworkTiles[1].removeWhere((t) => t.homework.id == homework.id);
    callback();
    app.user.kreta.homeworkSolved(homework, homework.isSolved);
  }
}
