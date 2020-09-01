import 'dart:convert';

import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/homework.dart';
//import 'package:filcnaplo/data/models/dummy.dart';

class HomeworkSync {
  List<Homework> data = [];

  Future<bool> sync() async {
    if (!app.debugUser) {
      List<Homework> homeworks;
      DateTime from = DateTime.fromMillisecondsSinceEpoch(1);
      homeworks = await app.user.kreta.getHomeworks(from);

      if (homeworks == null) {
        await app.user.kreta.refreshLogin();
        homeworks = await app.user.kreta.getHomeworks(from);
      }

      if (homeworks != null) {
        data = homeworks;

        await app.user.storage.delete("kreta_homeworks");

        await Future.forEach(homeworks, (homework) async {
          if (homework.json != null) {
            await app.user.storage.insert("kreta_homeworks", {
              "json": jsonEncode(homework.json),
            });
          }
        });
      }

      return homeworks != null;
    } else {
      //data = Dummy.homeworks;
      return true;
    }
  }

  delete() {
    data = [];
  }
}
