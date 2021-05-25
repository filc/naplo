import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/absence.dart';
import 'package:filcnaplo/ui/pages/absences/delay/tile.dart';

class DelayBuilder {
  List<DelayTile> delayTiles = [];
  void build() {

    delayTiles = [];
    List<Absence> delays = app.user.sync.absence.absences
        .where((delay) => delay.type!.name == "keses")
        .toList();

    delays.sort(
      (a, b) => -a.date!.compareTo(b.date!),
    );

    delays.forEach((delay) => delayTiles.add(DelayTile(delay)));
  }
}
