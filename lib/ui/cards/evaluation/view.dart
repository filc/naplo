import 'package:filcnaplo/generated/i18n.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/data/models/evaluation.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo/ui/profile_icon.dart';

class EvaluationView extends StatelessWidget {
  final Evaluation evaluation;

  EvaluationView(this.evaluation);

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Teacher
            ListTile(
              contentPadding: EdgeInsets.only(top: 6.0),
              leading: ProfileIcon(name: evaluation.teacher),
              title: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      evaluation.teacher,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                  SizedBox(width: 4.0),
                  Text(
                    formatDate(context, evaluation.date),
                    style: TextStyle(fontSize: 14.0, color: Colors.grey),
                  ),
                ],
              ),
              subtitle: Text(capital(evaluation.subject.name)),
            ),

            // Evaluation Details
            Padding(
              padding: EdgeInsets.only(top: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  EvaluationDetail(
                    I18n.of(context).evaluationValue,
                    evaluation.value.valueName.replaceFirst("(", " (") +
                        " " +
                        evaluation.value.weight.toString() +
                        "%",
                  ),
                  EvaluationDetail(
                    I18n.of(context).evaluationSubject,
                    capital(evaluation.subject.name),
                  ),
                  evaluation.description != ""
                      ? EvaluationDetail(
                          I18n.of(context).evaluationDescription,
                          evaluation.description,
                        )
                      : Container(),
                  evaluation.mode != null
                      ? EvaluationDetail(
                          I18n.of(context).evaluationType,
                          evaluation.mode.description,
                        )
                      : Container(),
                  // evaluation.form != ""
                  //     ? EvaluationDetail(
                  //         I18n.of(context).evaluationValueType,
                  //         evaluation.form,
                  //       )
                  //     : Container(),
                  evaluation.evaluationType != null
                      ? EvaluationDetail(
                          I18n.of(context).evaluationForm,
                          evaluation.evaluationType.description,
                        )
                      : Container(),
                  evaluation.writeDate != null
                      ? EvaluationDetail(
                          I18n.of(context).evaluationWriteDate,
                          formatDate(context, evaluation.writeDate),
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EvaluationDetail extends StatelessWidget {
  final String title;
  final String value;

  EvaluationDetail(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      children: <Widget>[
        Text(
          capital(title) + ":  ",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 16.0),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
