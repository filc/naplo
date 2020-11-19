import 'dart:convert';

import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/homework.dart';
import 'package:filcnaplo/data/models/dummy.dart';

class HomeworkSync {
  List<Homework> data = [];

  Future<bool> sync() async {
    if (!app.debugUser) {
      List<Homework> homework;
      DateTime from = DateTime.fromMillisecondsSinceEpoch(1);
      homework = await app.user.kreta.getHomeworks(from);

      if (homework == null) {
        await app.user.kreta.refreshLogin();
        homework = await app.user.kreta.getHomeworks(from);
      }

      if (homework != null) {
        data = homework;

        await app.user.storage.delete("kreta_homeworks");

        await Future.forEach(homework, (h) async {
          if (h.json != null) {
            await app.user.storage.insert("kreta_homeworks", {
              "json": jsonEncode(h.json),
            });
          }
        });
      }

      return homework != null;
    } else {
      data = Dummy.homework;
      return true;
    }
  }

  delete() {
    data = [];
  }
}
