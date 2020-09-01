import 'dart:convert';

import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/exam.dart';
//import 'package:filcnaplo/data/models/dummy.dart';

class ExamSync {
  List<Exam> data = [];

  Future<bool> sync() async {
    if (!app.debugUser) {
      List<Exam> exams;
      exams = await app.user.kreta.getExams();

      if (exams == null) {
        await app.user.kreta.refreshLogin();
        exams = await app.user.kreta.getExams();
      }

      if (exams != null) {
        data = exams;

        await app.user.storage.delete("kreta_exams");

        await Future.forEach(exams, (exam) async {
          if (exam.json != null) {
            await app.user.storage.insert("kreta_exams", {
              "json": jsonEncode(exam.json),
            });
          }
        });
      }

      return exams != null;
    } else {
      //data = Dummy.exams;
      return true;
    }
  }

  delete() {
    data = [];
  }
}
