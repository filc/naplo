import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/cards/evaluation/view.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/data/models/evaluation.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/type.dart';
import 'package:filcnaplo/data/models/subject.dart';

class AverageCalculator extends StatefulWidget {
  final Subject subject;

  AverageCalculator(this.subject);

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
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "Ha kapnék egy...",
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(child: Container()),
                  Row(
                    children: <Widget>[
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
                      "Súly: " + weight.toInt().toString() + "%",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        right: 10, top: 10, left: 10, bottom: 35),
                    child: Slider(
                      value: weight,
                      divisions: 7,
                      min: 50.0,
                      max: 400.0,
                      onChanged: (newWeight) {
                        setState(() => weight = newWeight);
                      },
                      activeColor: Theme.of(context).accentColor,
                    ),
                  ),
                  FlatButton(
                    padding: EdgeInsets.only(
                        top: 15, bottom: 15, right: 35, left: 35),
                    shape: StadiumBorder(),
                    child: Text(
                      "Hozzáadás",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    onPressed: addEvalToAverage,
                    color: Theme.of(context).highlightColor,
                  ),
                  Expanded(child: Container())
                ])));
  }

  void addEvalToAverage() {
    print("debug add eval button pressed");
    print("eval value was " +
        evaluation.toString() +
        ", and weight was " +
        weight.toString());
    Evaluation newEval = Evaluation(
        "123", //TODO
        DateTime.now(),
        EvaluationValue(evaluation, " ", " ", weight.toInt()),
        " ",
        "Ha kapnék egy... description", //TODO i18n
        Type(
            "Type type id", //TODO
            "Ha kapnék egy... Type type",
            "Ha kapnék egy... Type name"),
        "group id", //TODO
        widget.subject,
        Type("Type evaltype id", "Type evaltype description",
            "Type evaltype name"),
        Type("Type mode id", "Type mode description", "Type mode name"),
        DateTime.now(),
        DateTime.now(),
        "Form");
    app.user.sync.evaluation.data[0].add(newEval);
    Navigator.of(context).pop();
  }

  Widget evalRadio(int value) {
    return Column(
      children: <Widget>[
        Text(
          value.toString(),
          style: TextStyle(fontSize: 23),
        ),
        Radio<int>(
          value: value,
          groupValue: evaluation,
          activeColor: Theme.of(context).accentColor,
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
