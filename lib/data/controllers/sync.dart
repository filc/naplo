import 'package:filcnaplo/data/sync/evaluation.dart';
import 'package:filcnaplo/data/sync/message.dart';
import 'package:filcnaplo/data/sync/news.dart';
import 'package:filcnaplo/data/sync/note.dart';
import 'package:filcnaplo/data/sync/event.dart';
import 'package:filcnaplo/data/sync/student.dart';
import 'package:filcnaplo/data/sync/absence.dart';
import 'package:filcnaplo/data/sync/exam.dart';
import 'package:filcnaplo/data/sync/homework.dart';
import 'package:filcnaplo/data/sync/timetable.dart';

import 'package:filcnaplo/modules/autoupdate/releaseSync.dart';

import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/ui/pages/planner/timetable/builder.dart';
import 'package:filcnaplo/ui/pages/planner/timetable/week.dart';
import 'dart:async';

import 'package:flutter/material.dart';

class Task {
  final String? name;
  final Future Function()? task;

  Task({this.name, @required this.task});
}

class SyncController {
  // Users
  Map<String, SyncUser> users = {};

  // Progress Tracking
  List<Task> tasks = [];
  Function? updateCallback;
  int currentTask = 0;
  Future<void> fullSyncFinished = Completer().future;
  void addUser(String userID) {
    if (users[userID] == null) users[userID] = SyncUser();
  }

  Future fullSync() async {
    print("INFO: Full sync initiated.");

    tasks = [];

    createTask(Task(
      name: "student",
      task: app.user.sync.student.sync,
    ));

    createTask(Task(
      name: "evaluation",
      task: app.user.sync.evaluation.sync,
    ));

    createTask(Task(
      name: "timetable",
      task: app.user.sync.timetable.sync,
    ));

    createTask(Task(
      name: "homework",
      task: app.user.sync.homework.sync,
    ));

    createTask(Task(
      name: "exam",
      task: app.user.sync.exam.sync,
    ));

    createTask(Task(
      name: "message",
      task: app.user.sync.messages.sync,
    ));

    createTask(Task(
      name: "note",
      task: app.user.sync.note.sync,
    ));

    createTask(Task(
      name: "event",
      task: app.user.sync.event.sync,
    ));

    createTask(Task(
      name: "absence",
      task: app.user.sync.absence.sync,
    ));

    app.user.sync.news.sync();
    app.user.sync.release.sync();

    currentTask = 0;
    await Future.forEach(tasks, (Task task) async {
      try {
        await finishTask(task);
        if (app.debugMode)
          print("DEBUG: Task completed: " +
              (task.name ?? "null") +
              " (" +
              currentTask.toString() +
              ")");
      } catch (error) {
        print("ERROR: Task " +
            (task.name ?? "null") +
            " (" +
            currentTask.toString() +
            ")" +
            " failed with: " +
            error.toString());
      }
    });
    tasks = [];
    fullSyncFinished = Future.value(true);
    print("INFO: Full sync completed.");
  }

  createTask(Task task) {
    tasks.add(task);
  }

  Future finishTask(Task task) async {
    if (currentTask >= tasks.length) currentTask = 0;
    currentTask += 1;

    updateCallback!(
      task: task.name,
      current: currentTask,
      max: tasks.length,
    );

    await (task.task ?? () async {})();
  }

  void delete() {
    users.forEach((_, sync) {
      sync.messages.delete();
      sync.note.delete();
      sync.event.delete();
      sync.student.delete();
      sync.evaluation.delete();
      sync.absence.delete();
      sync.exam.delete();
      sync.homework.delete();
      sync.timetable.delete();
      sync.news.delete();
    });
  }
}

class SyncUser {
  // Syncers
  MessageSync messages = MessageSync();
  NoteSync note = NoteSync();
  EventSync event = EventSync();
  StudentSync student = StudentSync();
  EvaluationSync evaluation = EvaluationSync();
  AbsenceSync absence = AbsenceSync();
  ExamSync exam = ExamSync();
  HomeworkSync homework = HomeworkSync();
  TimetableSync timetable = TimetableSync();
  NewsSync news = NewsSync();
  ReleaseSync release = ReleaseSync();

  SyncUser() {
    TimetableBuilder builder = TimetableBuilder();
    Week currentWeek = builder.getWeek(builder.getCurrentWeek());
    timetable.from = currentWeek.start;
    timetable.to = currentWeek.end;
  }

  void allPending() {
    app.user.sync.absence.uiPending = true;
    app.user.sync.note.uiPending = true;
    app.user.sync.messages.uiPending = true;
    app.user.sync.evaluation.uiPending = true;
    app.user.sync.event.uiPending = true;
    app.user.sync.exam.uiPending = true;
    app.user.sync.homework.uiPending = true;
  }
}
