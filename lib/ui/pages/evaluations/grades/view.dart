import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/common/bottom_card.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/data/models/evaluation.dart';
import 'package:filcnaplo/utils/format.dart';

class EvaluationView extends StatelessWidget {
  final Evaluation evaluation;

  EvaluationView(this.evaluation);

  @override
  Widget build(BuildContext context) {
    return BottomCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.only(left: 12.0),
            leading: Text(
              evaluation.value.value != 0
                  ? (evaluation.value.value.toString() +
                      ((evaluation.type != EvaluationType.midYear &&
                              evaluation.description == "Dicséret"
                          ? "*"
                          : "")))
                  : evaluation.value.shortName ?? "?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 38.0,
                height: 1.2,
                fontWeight: FontWeight.w500,
                color: evaluation.value.value != 0 &&
                        evaluation.evaluationType != null &&
                        evaluation.evaluationType.name == "Szazalekos"
                    ? null
                    : app.theme
                        .evalColors[(evaluation.value.value - 1).clamp(0, 4)],
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    capital(evaluation.subject.name),
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                ),
                Text(
                  formatDate(context, evaluation.date),
                  style: TextStyle(fontSize: 14.0, color: Colors.grey),
                ),
              ],
            ),
            subtitle: Text(
              evaluation.teacher,
              softWrap: false,
              overflow: TextOverflow.fade,
              style: TextStyle(fontSize: 14.0),
            ),
          ),

          // Evaluation Details
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EvaluationDetail(
                I18n.of(context).evaluationValue,
                evaluation.value.valueName.replaceFirst("(", " (") +
                    " " +
                    evaluation.value.weight.toString() +
                    "%",
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
              // Basically useless info
              // evaluation.form != ""
              //     ? EvaluationDetail(
              //         I18n.of(context).evaluationValueType,
              //         evaluation.form,
              //       )
              //     : Container(),
              // evaluation.evaluationType != null
              //     ? EvaluationDetail(
              //         I18n.of(context).evaluationForm,
              //         evaluation.evaluationType.description,
              //       )
              //     : Container(),
              evaluation.writeDate != null
                  ? EvaluationDetail(
                      I18n.of(context).evaluationWriteDate,
                      formatDate(context, evaluation.writeDate),
                    )
                  : Container(),
            ],
          ),
        ],
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
      children: [
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
          softWrap: false,
          overflow: TextOverflow.fade,
        ),
      ],
    );
  }
}
