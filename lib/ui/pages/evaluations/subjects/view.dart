import 'package:filcnaplo/data/models/evaluation.dart';
import 'package:filcnaplo/data/models/subject.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/helpers/averages.dart';
import 'package:filcnaplo/ui/common/empty.dart';
import 'package:filcnaplo/ui/common/label.dart';
import 'package:filcnaplo/ui/pages/evaluations/grades/tile.dart';
import 'package:filcnaplo/ui/pages/evaluations/subjects/graph.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/utils/colors.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:filcnaplo/ui/pages/evaluations/subjects/average_calc.dart';

class SubjectView extends StatefulWidget {
  final Subject subject;
  final double classAvg;

  SubjectView(this.subject, this.classAvg);

  @override
  _SubjectViewState createState() => _SubjectViewState();
}

class _SubjectViewState extends State<SubjectView> {
  late double studentAvg;
  List<Evaluation> tempEvals = [];

  @override
  Widget build(BuildContext context) {
    studentAvg = 0;

    List<Evaluation> evaluations = app.user.sync.evaluation.evaluations;

    List<Evaluation> subjectEvals =
        evaluations.where((e) => e.subject!.id == widget.subject.id).toList();
    subjectEvals.insertAll(0, tempEvals);

    List<Widget> evaluationTiles = [];

    subjectEvals.forEach((evaluation) {
      if (evaluation.type == EvaluationType.midYear) {
        if (evaluation.date != null) if (evaluation.id.startsWith("temp_")) {
          evaluationTiles.add(GradeTile(
            evaluation,
            padding: EdgeInsets.only(bottom: 6.0),
            deleteCallback: _deleteCallback,
          ));
        } else {
          evaluationTiles.add(GradeTile(
            evaluation,
            padding: EdgeInsets.only(bottom: 6.0),
          ));
        }
      } else {
        String? yearTitle;

        switch (evaluation.type) {
          case EvaluationType.firstQ:
            yearTitle = I18n.of(context).evaluationsQYear;
            break;
          case EvaluationType.secondQ:
            yearTitle = I18n.of(context).evaluations2qYear;
            break;
          case EvaluationType.halfYear:
            yearTitle = I18n.of(context).evaluationsHalfYear;
            break;
          case EvaluationType.thirdQ:
            yearTitle = I18n.of(context).evaluations3qYear;
            break;
          case EvaluationType.fourthQ:
            yearTitle = I18n.of(context).evaluations4qYear;
            break;
          case EvaluationType.endYear:
            yearTitle = I18n.of(context).evaluationsEndYear;
            break;
          case EvaluationType.levelExam:
            yearTitle = I18n.of(context).evaluationsLevelExam;
            break;
          case EvaluationType.unknown:
            yearTitle = I18n.of(context).unknown;
            break;
          case EvaluationType.midYear:
            break;
        }

        evaluationTiles.add(YearDivider(
          text: yearTitle ?? "-",
          evaluation: evaluation,
        ));
      }
    });

    subjectEvals.forEach((e) {
      studentAvg += e.value.value * (e.value.weight / 100);
    });

    double weight =
        subjectEvals.map((e) => e.value.weight / 100).reduce((a, b) => a + b);

    if (weight > 0) studentAvg = studentAvg / weight;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: app.settings.appColor),
        shadowColor: Colors.transparent,
        backgroundColor: app.settings.theme.scaffoldBackgroundColor,
        actions: [
          widget.classAvg != 0 && roundSubjAvg(widget.classAvg) != 0
              ? Padding(
                  padding: EdgeInsets.fromLTRB(0, 12.0, 8.0, 12.0),
                  child: Row(
                    children: [
                      Text(
                        capitalize(I18n.of(context).evaluationAverageClass),
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Container(
                        width: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(45.0)),
                          border: Border.all(
                            width: 3.0,
                            color: getAverageColor(widget.classAvg),
                          ),
                        ),
                        padding: EdgeInsets.all(5.0),
                        margin: EdgeInsets.only(left: 5.0),
                        child: Text(
                          app.settings.language.split("_")[0] == "en"
                              ? widget.classAvg.toStringAsFixed(2)
                              : widget.classAvg
                                  .toStringAsFixed(2)
                                  .split(".")
                                  .join(","),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
          roundSubjAvg(studentAvg) != 0
              ? Padding(
                  padding: EdgeInsets.fromLTRB(0, 12.0, 8.0, 12.0),
                  child: Row(
                    children: [
                      Text(
                        capitalize(I18n.of(context).evaluationAverage),
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Container(
                        width: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(45.0)),
                          color: getAverageColor(studentAvg),
                        ),
                        padding: EdgeInsets.all(8.0),
                        margin: EdgeInsets.only(left: 5.0),
                        child: Text(
                          app.settings.language.split("_")[0] == "en"
                              ? studentAvg.toStringAsFixed(2)
                              : studentAvg
                                  .toStringAsFixed(2)
                                  .split(".")
                                  .join(","),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                            color: textColor(getAverageColor(studentAvg)),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
      body: Container(
        child: CupertinoScrollbar(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Container(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  capital(widget.subject.name),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.0,
                  ),
                ),
              ),
              Container(
                height: 200.0,
                margin: EdgeInsets.fromLTRB(12.0, 14.0, 24.0, 6.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: SubjectGraph(subjectEvals, dayThreshold: 5),
              ),
              Label(I18n.of(context).evaluationTitle),
              Container(
                padding: EdgeInsets.only(
                    right: 12.0, top: 0, left: 12.0, bottom: 75.0),
                child: Column(
                  children: evaluationTiles.isNotEmpty
                      ? evaluationTiles
                      : [Empty(title: I18n.of(context).emptySubjectGrades)],
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
            builder: (BuildContext context) => AverageCalculator(
              widget.subject,
              multiplier: tempEvals.length + 1,
            ),
          );
          setState(() {
            tempEvals.insert(0, tempEval);
          });
        },
      ),
    );
  }

  _deleteCallback(Evaluation toRemove) {
    setState(() {
      tempEvals.removeWhere((e) => e.id == toRemove.id);
    });
  }
}

class YearDivider extends StatelessWidget {
  const YearDivider({required this.text, required this.evaluation});

  final String text;
  final Evaluation evaluation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(.7),
              borderRadius: BorderRadius.circular(12.0),
            ),
            height: 3.0,
            width: 100.0,
            margin: EdgeInsets.all(6.0),
          ),
          Text(
            text,
            style: TextStyle(
              color: app.settings.appColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(.7),
              borderRadius: BorderRadius.circular(12.0),
            ),
            height: 3.0,
            width: 100.0,
            margin: EdgeInsets.all(6.0),
          ),
        ],
      ),
    );
  }
}
