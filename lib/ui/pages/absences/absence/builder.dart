import 'package:filcnaplo/ui/pages/absences/absence/tile.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/absence.dart';

class AbsenceBuilder {
  List<AbsenceTileGroup> absenceTiles = [];

  void build() {
    absenceTiles = [];
    List<Absence> absences = app.user.sync.absence.data
        .where((absence) => absence.type.name == "hianyzas")
        .toList();

    absences.sort(
      (a, b) => -a.date.compareTo(b.date),
    );

    Map<String, List<Absence>> absenceDays = {};
    absences.forEach((absence) {
      if (!absenceDays.keys.contains(absence.date.toString())) {
        absenceDays[absence.date.toString()] = [];
      }

      absenceDays[absence.date.toString()].add(absence);
    });

    absenceDays.keys.forEach((day) {
      List<Absence> absences = absenceDays[day];
      absences.sort((a, b) => a.lessonStart.compareTo(b.lessonStart));
      absenceTiles.add(AbsenceTileGroup(absences));
    });
  }
}
