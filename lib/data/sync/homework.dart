import 'dart:convert';

import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/homework.dart';
import 'package:filcnaplo/data/models/dummy.dart';

class HomeworkSync {
  List<Homework> homework = [];
  bool uiPending = true;

  Future<bool> sync() async {
    if (!app.debugUser) {
      List<Homework> _homework;
      DateTime from = DateTime.fromMillisecondsSinceEpoch(1);
      _homework = await app.user.kreta.getHomeworks(from);
      if (_homework == null) {
        await app.user.kreta.refreshLogin();
        _homework = await app.user.kreta.getHomeworks(from);
      }

      if (_homework != null) {
        homework = _homework;

        await app.user.storage.delete("kreta_homeworks");

        await Future.forEach(homework, (h) async {
          if (h.json != null) {
            await app.user.storage.insert("kreta_homeworks", {
              "json": jsonEncode(h.json),
            });
          }
        });
      }

      uiPending = true;

      return _homework != null;
    } else {
      homework = Dummy.homework;
      return true;
    }
  }

  delete() {
    homework = [];
  }
}
