import 'dart:convert';

import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/student.dart';
import 'package:filcnaplo/ui/profile_icon.dart';
import 'package:filcnaplo/data/models/dummy.dart';

class StudentSync {
  Student data;

  Future<bool> sync() async {
    if (!app.debugUser) {
      Student student;
      student = await app.user.kreta.getStudent();
      student.groupId = await app.user.kreta.getGroups();

      if (student == null) {
        await app.user.kreta.refreshLogin();
        student = await app.user.kreta.getStudent();
        student.groupId = await app.user.kreta.getGroups();
      }

      if (student != null) {
        data = student;

        await app.user.storage.delete("student");
        app.user.realName = student.name;

        if (app.user.name == null) app.user.name = student.name;

        if (app.user.customProfileIcon != null &&
            app.user.customProfileIcon != null) {
          app.user.profileIcon = ProfileIcon(
              name: app.user.name,
              size: 0.7,
              image: app.user.customProfileIcon);
        }

        if (student.json != null) {
          await app.user.storage.insert("student", {
            "json": jsonEncode(student.json),
          });
        }
      }
      
      return student != null;
    } else {
      data = Dummy.student;
      if (app.user.customProfileIcon != null) {
        app.user.profileIcon = ProfileIcon(name: Dummy.student.name, size: 0.7);
      }

      return true;
    }
  }

  delete() {
    data = null;
  }
}
