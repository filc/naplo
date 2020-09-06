import 'package:filcnaplo/ui/pages/evaluations/grades/builder.dart';
import 'package:filcnaplo/ui/pages/evaluations/subjects/builder.dart';
import 'package:filcnaplo/ui/pages/evaluations/tabs.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/data/context/app.dart';

class EvaluationsPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey;

  EvaluationsPage(this._scaffoldKey);

  @override
  _EvaluationsPageState createState() =>
      _EvaluationsPageState(this._scaffoldKey);
}

class _EvaluationsPageState extends State<EvaluationsPage> {
  GradeBuilder _gradeBuilder;
  SubjectBuilder _subjectBuilder;

  _EvaluationsPageState(_scaffoldKey) {
    this._gradeBuilder = GradeBuilder();
    this._subjectBuilder = SubjectBuilder(callback: buildPage);
  }

  void updateCallback() => setState(() {});

  void buildPage() {
    _gradeBuilder.build(sortBy: app.evalSortBy);
    _subjectBuilder.build();
  }

  @override
  Widget build(BuildContext context) {
    buildPage();

    return EvaluationTabs(
      widget._scaffoldKey,
      _gradeBuilder.gradeTiles,
      _subjectBuilder,
      updateCallback,
    );
  }
}
