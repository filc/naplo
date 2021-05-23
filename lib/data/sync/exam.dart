import 'dart:convert';

import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/dummy.dart';
import 'package:filcnaplo/data/models/exam.dart';
//import 'package:filcnaplo/data/models/dummy.dart';

class ExamSync {
  List<Exam> exams = [];
  bool uiPending = true;

  Future<bool> sync() async {
    if (!app.debugUser) {
      List<Exam>? _exams;
      _exams = await app.user.kreta.getExams();

      if (_exams == null) {
        await app.user.kreta.refreshLogin();
        _exams = await app.user.kreta.getExams();
      }

      if (_exams != null) {
        exams = _exams;

        await app.user.storage.delete("kreta_exams");

        await Future.forEach(_exams, (Exam exam) async {
          if (exam.json != null) {
            await app.user.storage.insert("kreta_exams", {
              "json": jsonEncode(exam.json),
            });
          }
        });
      }

      uiPending = true;

      return _exams != null;
    } else {
      exams = Dummy.exams;
      return true;
    }
  }

  delete() {
    exams = [];
  }
}
