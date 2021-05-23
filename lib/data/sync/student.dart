import 'dart:convert';

import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/student.dart';
import 'package:filcnaplo/ui/common/profile_icon.dart';
import 'package:filcnaplo/data/models/dummy.dart';

class StudentSync {
  late Student student;

  Future<bool> sync() async {
    if (!app.debugUser) {
      Student? _student;
      _student = await app.user.kreta.getStudent();
      Map? group = await app.user.kreta.getGroup();
      _student?.groupId = group!['uid'];
      _student?.className = group!['className'];

      if (_student == null) {
        await app.user.kreta.refreshLogin();
        _student = await app.user.kreta.getStudent();
        group = await app.user.kreta.getGroup();
        _student?.groupId = group!['uid'];
        _student?.className = group!['className'];
      }

      if (_student != null) {
        student = _student;

        await app.user.storage.delete("student");
        app.user.realName = _student.name;

        if (app.user.name == null) app.user.name = _student.name;

        if (app.user.customProfileIcon != null &&
            app.user.customProfileIcon != null) {
          app.user.profileIcon = ProfileIcon(
              name: app.user.name ?? "?",
              size: 0.7,
              image: app.user.customProfileIcon!);
        }

        if (_student.json != null) {
          await app.user.storage.insert("student", {
            "json": jsonEncode(_student.json),
          });
        }
      }

      return _student != null;
    } else {
      student = Dummy.student;
      if (app.user.customProfileIcon != null) {
        app.user.profileIcon = ProfileIcon(name: Dummy.student.name, size: 0.7);
      }

      return true;
    }
  }

  delete() {}
}
