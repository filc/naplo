import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/modules/now/upcoming_todos/view.dart';
import 'package:filcnaplo/modules/now/current_lesson/view.dart';
import 'package:filcnaplo/modules/now/helper.dart';
import 'package:filcnaplo/modules/now/mode.dart';

class Now extends StatefulWidget {
  final Function jumpToPage;
  Now(this.jumpToPage);
  @override
  NowState createState() => NowState();
}

class NowState extends State<Now> {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return FutureBuilder(
        future: app.sync.fullSyncFinished,
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) return Container();
          Mode currentMode = getMode(app.user.sync.timetable.data);
          return Column(children: [
            UpcomingToDoList(widget.jumpToPage),
            currentMode == Mode.AtSchool
                ? CurrentLessonCard(getCurrentLesson(
                    getLessonsToday(app.user.sync.timetable.data, now), now))
                : Container()
          ]);
        });
  }
}
