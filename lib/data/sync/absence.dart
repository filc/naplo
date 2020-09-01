import 'dart:convert';

import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/absence.dart';
//import 'package:filcnaplo/data/models/dummy.dart';

class AbsenceSync {
  List<Absence> data = [];

  Future<bool> sync() async {
    if (!app.debugUser) {
      List<Absence> absences;
      absences = await app.user.kreta.getAbsences();

      if (absences == null) {
        await app.user.kreta.refreshLogin();
        absences = await app.user.kreta.getAbsences();
      }

      if (absences != null) {
        data = absences;

        await app.user.storage.delete("kreta_absences");

        await Future.forEach(absences, (absence) async {
          if (absence.json != null) {
            await app.user.storage.insert("kreta_absences", {
              "json": jsonEncode(absence.json),
            });
          }
        });
      }
      
      return absences != null;
    } else {
      //data = Dummy.absences;
      return true;
    }
  }

  delete() {
    data = [];
  }
}
