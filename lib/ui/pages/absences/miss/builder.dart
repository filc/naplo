import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/note.dart';
import 'package:filcnaplo/ui/pages/absences/miss/tile.dart';

class MissBuilder {
  List<MissTile> missTiles = [];
  void build() {
    missTiles = [];
    List<Note> misses = app.user.sync.note.data
        .where((miss) =>
            miss.type.name == "HaziFeladatHiany" ||
            miss.type.name == "Felszereleshiany")
        .toList();

    misses.sort(
      (a, b) => -a.date.compareTo(b.date),
    );

    misses.forEach((miss) => missTiles.add(MissTile(miss)));
  }
}
