import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/evaluation.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/helpers/averages.dart';
import 'package:filcnaplo/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tinycolor/tinycolor.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/ui/pages/evaluations/subjects/graph.dart';

class StatsBlock extends StatelessWidget {
  StatsBlock(this.values, this.average, this.titleTooltip, this.lastBoxTooltip);

  final List<String> values;
  final double average;
  final String titleTooltip;
  final String lastBoxTooltip;
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                EvaluationBlock(
                  title: "5",
                  value: values[4],
                  color: app.theme.evalColors[4],
                ),
                EvaluationBlock(
                  title: "4",
                  value: values[3],
                  color: app.theme.evalColors[3],
                ),
                EvaluationBlock(
                  title: "3",
                  value: values[2],
                  color: app.theme.evalColors[2],
                ),
              ],
            ),
          ),
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  EvaluationBlock(
                    title: "2",
                    value: values[1],
                    color: app.theme.evalColors[1],
                  ),
                  EvaluationBlock(
                    title: "1",
                    value: values[0],
                    color: app.theme.evalColors[0],
                  ),
                  Tooltip(
                    message: lastBoxTooltip,
                    child: EvaluationBlock(
                      value: average.toStringAsFixed(2),
                      color: getAverageColor(average),
                    ),
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}

class StatisticsTitle extends StatelessWidget {
  StatisticsTitle(this.icon, this.title);
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 14.0, bottom: 4.0),
      child: Row(
        children: [
          Icon(icon),
          Container(
            padding: EdgeInsets.only(left: 12),
            child: Text(title,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class StatisticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Evaluation> evaluations = app.user.sync.evaluation.data[0]
        .where((evaluation) => evaluation.type.name == "evkozi_jegy_ertekeles")
        .toList();

    List<String> grades = [
      evaluations.where((e) => e.value.value == 1).length.toString(),
      evaluations.where((e) => e.value.value == 2).length.toString(),
      evaluations.where((e) => e.value.value == 3).length.toString(),
      evaluations.where((e) => e.value.value == 4).length.toString(),
      evaluations.where((e) => e.value.value == 5).length.toString(),
    ];
    var subjects = calculateSubjectsAverage().where((e) => true);
    /*!e.subject.category.id.contains("Magatartas") &&
        !e.subject.category.id.contains("Szorgalom"));*/

    count(int grade) =>
        subjects.where((e) => roundSubjAvg(e.average) == grade).length;

    List<int> subjectGrades = [
      count(1),
      count(2),
      count(3),
      count(4),
      count(5),
    ];

    double subjectsAvgSum = 0;
    double subjectsAvgCount = 0;
    for (int i = 0; i < subjectGrades.length; i++) {
      var grade = i + 1;
      subjectsAvgSum += grade * subjectGrades[i];
      subjectsAvgCount += subjectGrades[i];
    }
    double subjectsAvg = subjectsAvgSum / subjectsAvgCount;

    double allAvg = 0;

    if (evaluations.length > 0) {
      evaluations.forEach((e) {
        allAvg += e.value.value * (e.value.weight / 100);
      });

      allAvg = allAvg /
          evaluations.map((e) => e.value.weight / 100).reduce((a, b) => a + b);
    } else {
      allAvg = 0.0;
    }

    return Container(
      child: CupertinoScrollbar(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            //Grades
            StatisticsTitle(
                FeatherIcons.bookmark, I18n.of(context).evaluations),
            StatsBlock(grades, allAvg, I18n.of(context).evaluations,
                I18n.of(context).tooltipStatisticsEvalsAvg),
            //Grades graph
            StatisticsTitle(FeatherIcons.trendingUp,
                I18n.of(context).evaluationsYearlyGraph),
            Container(
                padding: EdgeInsets.only(left: 10, right: 25),
                margin: EdgeInsets.only(top: 15, bottom: 30),
                height: 200,
                child: SubjectGraph(evaluations, dayThreshold: 2)),
            //Subjects
            Tooltip(
              message: I18n.of(context).tooltipStatisticsSubjects,
              child: StatisticsTitle(FeatherIcons.book,
                  I18n.of(context).evaluationsSubjectsAverage),
            ),
            StatsBlock(
                subjectGrades.map((e) => e.toString()).toList(),
                subjectsAvg,
                I18n.of(context).evaluationsSubjectsAverage,
                I18n.of(context).tooltipStatisticsSubjectsAvg),
          ],
        ),
      ),
    );
  }
}

class EvaluationBlock extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  EvaluationBlock({this.title, this.value, this.color});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = TinyColor(color).darken(15).color;

    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
      width: 100.0,
      height: 64.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        color: title != null ? backgroundColor : color,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          title != null
              ? Container(
                  width: 42.0,
                  height: 42.0,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "GoogleSans",
                      color: textColor(color),
                      fontSize: 28.0,
                      height: 1.2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : Container(),
          Padding(
            padding: title != null
                ? EdgeInsets.only(left: 4.0)
                : EdgeInsets.all(14.0),
            child: Text(
              value.replaceAll(".", ","),
              style: TextStyle(
                  color: textColor(title != null ? backgroundColor : color),
                  fontSize: 24.0),
            ),
          ),
        ],
      ),
    );
  }
}
