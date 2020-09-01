import 'package:filcnaplo/ui/pages/planner/homeworks/builder.dart';
import 'package:filcnaplo/ui/pages/planner/tabs.dart';
import 'package:filcnaplo/ui/pages/planner/exams/builder.dart';
import 'package:flutter/material.dart';

class PlannerPage extends StatefulWidget {
  final _scaffoldKey;

  PlannerPage(this._scaffoldKey);

  @override
  _PlannerPageState createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> {
  HomeworkBuilder homeworkBuilder;
  ExamBuilder examBuilder;

  @override
  void initState() {
    super.initState();

    homeworkBuilder = HomeworkBuilder(updateCallback);
    examBuilder = ExamBuilder();
  }

  @override
  Widget build(BuildContext context) {
    buildPage();

    return PlannerTabs(
      widget._scaffoldKey,
      homeworkBuilder.homeworkTiles,
      examBuilder.examTiles,
      callback: updateCallback,
    );
  }

  void updateCallback() {
    setState(() {});
  }

  void buildPage() {
    homeworkBuilder.build();
    examBuilder.build();
  }
}
