import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/evaluation.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tinycolor/tinycolor.dart';

class StatisticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Evaluation> evaluations = app.user.sync.evaluation.data[0]
        .where((evaluation) => evaluation.type.name == "evkozi_jegy_ertekeles")
        .toList();

    String count5 =
        evaluations.where((e) => e.value.value == 5).length.toString();
    String count4 =
        evaluations.where((e) => e.value.value == 4).length.toString();
    String count3 =
        evaluations.where((e) => e.value.value == 3).length.toString();
    String count2 =
        evaluations.where((e) => e.value.value == 2).length.toString();
    String count1 =
        evaluations.where((e) => e.value.value == 1).length.toString();

    double allAvg = 0;

    evaluations.forEach((e) {
      allAvg += e.value.value * (e.value.weight / 100);
    });

    allAvg = allAvg /
        evaluations.map((e) => e.value.weight / 100).reduce((a, b) => a + b);

    return Container(
      child: CupertinoScrollbar(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 14.0, bottom: 12.0),
              child: Text(I18n.of(context).evaluations,
                  style: TextStyle(fontSize: 18.0)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                EvaluationBlock(
                  title: "5",
                  value: count5,
                  color: app.theme.evalColors[4],
                ),
                EvaluationBlock(
                  title: "4",
                  value: count4,
                  color: app.theme.evalColors[3],
                ),
                EvaluationBlock(
                  title: "3",
                  value: count3,
                  color: app.theme.evalColors[2],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                EvaluationBlock(
                  title: "2",
                  value: count2,
                  color: app.theme.evalColors[1],
                ),
                EvaluationBlock(
                  title: "1",
                  value: count1,
                  color: app.theme.evalColors[0],
                ),
                EvaluationBlock(
                  value: allAvg.toStringAsFixed(2),
                  color: app.theme.evalColors[allAvg.round().clamp(0, 4) - 1],
                ),
              ],
            ),
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
                    style: GoogleFonts.quicksand(
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
