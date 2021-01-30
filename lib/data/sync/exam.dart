import 'dart:convert';

import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/dummy.dart';
import 'package:filcnaplo/data/models/exam.dart';
import 'package:flutter/material.dart';
//import 'package:filcnaplo/data/models/dummy.dart';

class ExamSync {
  List<Exam> exams = [];
  Key key;

  Future<bool> sync() async {
    if (!app.debugUser) {
      List<Exam> _exams;
      _exams = await app.user.kreta.getExams();

      if (_exams == null) {
        await app.user.kreta.refreshLogin();
        _exams = await app.user.kreta.getExams();
      }

      if (_exams != null) {
        exams = _exams;

        await app.user.storage.delete("kreta_exams");

        await Future.forEach(_exams, (exam) async {
          if (exam.json != null) {
            await app.user.storage.insert("kreta_exams", {
              "json": jsonEncode(exam.json),
            });
          }
        });
      }

      key = UniqueKey();
      return _exams != null;
    } else {
      exams = Dummy.exams;
      return true;
    }
  }

  delete() {
    exams = [];
  }

  bool match(Key oldKey) {
    return oldKey == key;
  }
}
