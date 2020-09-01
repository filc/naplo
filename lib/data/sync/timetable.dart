import 'dart:convert';

import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/lesson.dart';
//import 'package:filcnaplo/data/models/dummy.dart';

class TimetableSync {
  List<Lesson> data = [];
  DateTime from;
  DateTime to;

  Future<bool> sync() async {
    if (!app.debugUser) {
      List<Lesson> lessons;
      lessons = await app.user.kreta.getLessons(from, to);

      if (lessons == null) {
        await app.user.kreta.refreshLogin();
        lessons = await app.user.kreta.getLessons(from, to);
      }

      if (lessons != null) {
        data = lessons;

        await app.user.storage.delete("kreta_lessons");

        await Future.forEach(lessons, (lesson) async {
          if (lesson.json != null &&
              from.isBefore(DateTime.now()) &&
              to.isAfter(DateTime.now())) {
            await app.user.storage.insert("kreta_lessons", {
              "json": jsonEncode(lesson.json),
            });
          }
        });
      } else {
        data = [];
      }

      return lessons != null;
    } else {
      //data[0] = Dummy.lessons;
      return true;
    }
  }

  delete() {
    data = [];
  }
}
