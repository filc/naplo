import 'dart:math';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/data/models/evaluation.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/type.dart';
import 'package:filcnaplo/data/models/subject.dart';

class AverageCalculator extends StatefulWidget {
  final Subject subject;
  final int multiplier;

  AverageCalculator(this.subject, {this.multiplier = 1});

  @override
  AverageCalculatorState createState() => AverageCalculatorState();
}

class AverageCalculatorState extends State<AverageCalculator> {
  int evaluation = 1;
  double weight = 100;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: app.settings.theme.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                I18n.of(context).evaluationsGhostTitle,
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(child: Container()),
            Row(
              children: [
                evalRadio(1),
                evalRadio(2),
                evalRadio(3),
                evalRadio(4),
                evalRadio(5)
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                capital(I18n.of(context).evaluationWeight) +
                    ": " +
                    weight.toInt().toString() +
                    "%",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(right: 10, top: 10, left: 10, bottom: 35),
              child: Slider(
                value: weight,
                divisions: 7,
                min: 50.0,
                max: 400.0,
                onChanged: (newWeight) {
                  setState(() => weight = newWeight);
                },
                activeColor: app.settings.appColor,
              ),
            ),
            MaterialButton(
              elevation: 0,
              highlightElevation: 0,
              padding:
                  EdgeInsets.only(top: 15, bottom: 15, right: 35, left: 35),
              shape: StadiumBorder(),
              child: Text(
                I18n.of(context).dialogAdd,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              onPressed: addEvalToAverage,
              color: Theme.of(context).highlightColor,
            ),
            Expanded(child: Container())
          ],
        ),
      ),
    );
  }

  void addEvalToAverage() {
    int randId;
    var rand = Random();
    randId = rand.nextInt(1000);

    DateTime date = DateTime.now().add(Duration(days: 7 * widget.multiplier));

    Evaluation tempEval = Evaluation(
      "temp_" + randId.toString(), //id
      date, //writedate
      EvaluationValue(evaluation, " ", " ", weight.toInt()),
      "", //teacher
      "", //description
      EvaluationType.midYear, //type
      null, //groupid
      widget.subject,
      Type("", "", ""), //evaluationtype
      Type("", "", ""), //mode
      date, //date
      date, //seen-date
      null,
    );

    Navigator.of(context).pop(tempEval);
  }

  Widget evalRadio(int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(fontSize: 23),
        ),
        Radio<int>(
          value: value,
          groupValue: evaluation,
          activeColor: app.settings.appColor,
          onChanged: (int value) {
            setState(() {
              evaluation = value;
            });
          },
        ),
      ],
    );
  }
}
