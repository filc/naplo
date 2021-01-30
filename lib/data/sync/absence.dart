import 'dart:convert';

import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/absence.dart';
import 'package:flutter/material.dart';
//import 'package:filcnaplo/data/models/dummy.dart';

class AbsenceSync {
  List<Absence> absences = [];
  Key key;

  Future<bool> sync() async {
    if (!app.debugUser) {
      List<Absence> _absences;
      _absences = await app.user.kreta.getAbsences();

      if (_absences == null) {
        await app.user.kreta.refreshLogin();
        _absences = await app.user.kreta.getAbsences();
      }

      if (_absences != null) {
        absences = _absences;

        await app.user.storage.delete("kreta_absences");

        await Future.forEach(_absences, (absence) async {
          if (absence.json != null) {
            await app.user.storage.insert("kreta_absences", {
              "json": jsonEncode(absence.json),
            });
          }
        });
      }

      key = UniqueKey();
      return _absences != null;
    } else {
      //data = Dummy.absences;
      return true;
    }
  }

  delete() {
    absences = [];
  }

  bool match(Key oldKey) {
    return oldKey == key;
  }
}
