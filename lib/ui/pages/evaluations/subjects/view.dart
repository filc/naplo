import 'package:filcnaplo/data/models/evaluation.dart';
import 'package:filcnaplo/data/models/subject.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/empty.dart';
import 'package:filcnaplo/ui/pages/evaluations/grades/tile.dart';
import 'package:filcnaplo/ui/pages/evaluations/subjects/graph.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/utils/colors.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/ui/pages/evaluations/subjects/average_calc.dart';
import '../grades/tile.dart';

//ignore: must_be_immutable
class SubjectView extends StatefulWidget {
  final Subject subject;
  final double classAvg;
  List<Evaluation> tempEvals = [];

  SubjectView(this.subject, this.classAvg);

  @override
  _SubjectViewState createState() => _SubjectViewState();
}

class _SubjectViewState extends State<SubjectView> {
  double studentAvg;

  @override
  Widget build(BuildContext context) {
    studentAvg = 0;

    List<Evaluation> evaluations = app.user.sync.evaluation.data[0]
        .where((evaluation) => evaluation.type.name == "evkozi_jegy_ertekeles")
        .toList();

    List<Evaluation> subjectEvals =
        evaluations.where((e) => e.subject.id == widget.subject.id).toList();
    subjectEvals.addAll(widget.tempEvals);

    List<GradeTile> evaluationTiles = [];

    subjectEvals.forEach((evaluation) {
      if (evaluation.date != null &&
          evaluation.value.value !=
              null) if (evaluation.id.startsWith("temp_")) {
        evaluationTiles.add(
            GradeTile(evaluation, deleteCallback: _deleteCallbackFunction));
      } else
        evaluationTiles.add(GradeTile(evaluation));
    });

    subjectEvals.forEach((e) {
      studentAvg += e.value.value * (e.value.weight / 100);
    });

    double weight = subjectEvals.map((e) => e.value.weight / 100).reduce((a, b) => a + b);

    if (weight > 0)
      studentAvg = studentAvg / weight;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(capital(widget.subject.name)),
        actions: <Widget>[
          studentAvg.round() != 0
              ? Container(
                  padding: EdgeInsets.fromLTRB(0, 12.0, 8.0, 12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(45.0)),
                      color:
                          app.theme.evalColors[(studentAvg.round() - 1).clamp(0, 4)],
                    ),
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      app.settings.language == "en"
                          ? studentAvg.toStringAsFixed(2)
                          : studentAvg.toStringAsFixed(2).split(".").join(","),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                        color: textColor(
                          app.theme.evalColors[(studentAvg.round() - 1).clamp(0, 4)],
                        ),
                      ),
                    ),
                  ),
          )
          : Container(),
          widget.classAvg != null && widget.classAvg.round() != 0
              ? Padding(
                  padding: EdgeInsets.fromLTRB(0, 12.0, 8.0, 12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(45.0)),
                      border: Border.all(
                        width: 3.0,
                        color: app.theme.evalColors[
                            (widget.classAvg.round() - 1).clamp(0, 4)],
                      ),
                    ),
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      app.settings.language == "en"
                          ? widget.classAvg.toStringAsFixed(2)
                          : widget.classAvg
                              .toStringAsFixed(2)
                              .split(".")
                              .join(","),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
      body: Container(
        child: CupertinoScrollbar(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Container(
                height: 200.0,
                padding: EdgeInsets.all(4.0),
                margin: EdgeInsets.all(4.0),
                child: SubjectGraph.fromData(
                  data: subjectEvals,
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(right: 12, top: 12, left: 12, bottom: 75),
                child: Column(
                  children: evaluationTiles.isNotEmpty
                      ? evaluationTiles
                      : <Widget>[
                          Empty(title: I18n.of(context).emptySubjectGrades)
                        ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: FloatingActionButton(
        child: Icon(FeatherIcons.plus, color: app.settings.appColor),
        backgroundColor: app.settings.theme.backgroundColor,
        tooltip: I18n.of(context).evaluationsGhostTitle,
        onPressed: () async {
          Evaluation tempEval = await showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) =>
                AverageCalculator(widget.subject),
          );
          if (tempEval != null) {
            setState(() {
              widget.tempEvals.add(tempEval);
            });
          }
        },
      ),
    );
  }

  _deleteCallbackFunction(Evaluation toRemove) {
    setState(() {
      widget.tempEvals.removeWhere((e) => e.id == toRemove.id);
    });
  }
}
