import 'dart:convert';

import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/controllers/sync.dart';
import 'package:filcnaplo/data/models/absence.dart';
import 'package:filcnaplo/data/models/evaluation.dart';
import 'package:filcnaplo/data/models/event.dart';
import 'package:filcnaplo/data/models/exam.dart';
import 'package:filcnaplo/data/models/homework.dart';
import 'package:filcnaplo/data/models/lesson.dart';
import 'package:filcnaplo/data/models/message.dart';
import 'package:filcnaplo/data/models/note.dart';
import 'package:filcnaplo/data/models/student.dart';
import 'package:filcnaplo/data/models/user.dart';
import 'package:filcnaplo/ui/common/profile_icon.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

Future offlineLoad(User user) async {
  Database userStorage = app.storage.users[user.id]!;
  User globalUser = app.users.firstWhere((search) => search.id == user.id);
  SyncUser globalSync = app.sync.users[user.id]!;

  List student = await userStorage.query("student");
  List settings = await userStorage.query("settings");

  if (settings[0]["nickname"] != "") globalUser.name = settings[0]["nickname"];

  globalUser.customProfileIcon = settings[0]["custom_profile_icon"];
  if (globalUser.customProfileIcon != "") {
    if (app.debugMode)
      print("DEBUG: User profileIcon: " + globalUser.customProfileIcon!);

    globalUser.profileIcon = ProfileIcon(
      name: globalUser.name ?? "",
      size: 0.7,
      image: globalUser.customProfileIcon!,
      color: Colors.grey,
    );
  } else {
    globalUser.profileIcon = ProfileIcon(name: globalUser.name ?? "?", size: 0.7, color: Colors.grey,);
  }

  if (student.length > 0) {
    globalSync.student.student =
        Student.fromJson(jsonDecode(student[0]["json"]));
  }

  List evaluations = await userStorage.query("evaluations");

  globalSync.evaluation.evaluations = [];
  globalSync.evaluation.averages = [];

  evaluations.forEach((evaluation) {
    globalSync.evaluation.evaluations
        .add(Evaluation.fromJson(jsonDecode(evaluation["json"])));
  });

  List notes = await userStorage.query("kreta_notes");

  globalSync.note.notes = [];
  notes.forEach((note) {
    globalSync.note.notes.add(Note.fromJson(jsonDecode(note["json"])));
  });

  List events = await userStorage.query("kreta_events");

  globalSync.event.events = [];
  events.forEach((event) {
    globalSync.event.events.add(Event.fromJson(jsonDecode(event["json"])));
  });

  List messagesInbox = await userStorage.query("messages_inbox");

  globalSync.messages.inbox = [];
  messagesInbox.forEach((message) {
    globalSync.messages.inbox
        .add(Message.fromJson(jsonDecode(message["json"])));
  });

  List messagesSent = await userStorage.query("messages_sent");

  globalSync.messages.sent = [];
  messagesSent.forEach((message) {
    globalSync.messages.sent.add(Message.fromJson(jsonDecode(message["json"])));
  });

  List messagesDraft = await userStorage.query("messages_draft");

  globalSync.messages.inbox = [];
  messagesDraft.forEach((message) {
    globalSync.messages.inbox
        .add(Message.fromJson(jsonDecode(message["json"])));
  });

  List messagesTrash = await userStorage.query("messages_trash");

  globalSync.messages.trash = [];
  messagesTrash.forEach((message) {
    globalSync.messages.trash
        .add(Message.fromJson(jsonDecode(message["json"])));
  });

  List absences = await userStorage.query("kreta_absences");

  globalSync.absence.absences = [];
  absences.forEach((absence) {
    globalSync.absence.absences
        .add(Absence.fromJson(jsonDecode(absence["json"])));
  });

  List exams = await userStorage.query("kreta_exams");

  globalSync.exam.exams = [];
  exams.forEach((exam) {
    globalSync.exam.exams.add(Exam.fromJson(jsonDecode(exam["json"])));
  });

  List homeworks = await userStorage.query("kreta_homeworks");

  globalSync.homework.homework = [];
  homeworks.forEach((homework) {
    globalSync.homework.homework
        .add(Homework.fromJson(jsonDecode(homework["json"])));
  });

  List lessons = await userStorage.query("kreta_lessons");

  globalSync.timetable.lessons = [];
  lessons.forEach((lesson) {
    globalSync.timetable.lessons
        .add(Lesson.fromJson(jsonDecode(lesson["json"])));
  });
}
