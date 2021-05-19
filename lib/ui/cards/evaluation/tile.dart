import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/data/models/evaluation.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo/ui/pages/evaluations/grades/view.dart';

class EvaluationTile extends StatelessWidget {
  final Evaluation evaluation;
  final Function deleteCallback;

  EvaluationTile(this.evaluation, {this.deleteCallback});

  @override
  Widget build(BuildContext context) {
    final bool isTemp = evaluation.id.startsWith("temp_");

    String title = evaluation.type == EvaluationType.midYear
        ? evaluation.description != ""
            ? capital(evaluation.description)
            : capital(evaluation.mode != null
                    ? evaluation.mode.description
                    : evaluation.value.valueName.split("(")[0]) +
                " " +
                (evaluation.value.weight != 100
                    ? evaluation.value.weight.toString() + "%"
                    : "")
        : capital(evaluation.subject != null
            ? evaluation.subject.name
            : I18n.of(context).unknown);

    String subtitle = evaluation.type == EvaluationType.midYear
        ? capital(evaluation.subject != null
                ? evaluation.subject.name
                : I18n.of(context).unknown) +
            (evaluation.description != ""
                ? (evaluation.mode != null
                    ? "\n" +
                        evaluation.mode.description +
                        " " +
                        (evaluation.value.weight != 100
                            ? evaluation.value.weight.toString() + "%"
                            : "")
                    : evaluation.form != null
                        ? "\n" + evaluation.form
                        : "")
                : "")
        : evaluation.value.valueName.split("(")[0];

    return GestureDetector(
      onTap: () {
        if (!isTemp)
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) => EvaluationView(evaluation),
          );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: isTemp ? Theme.of(context).highlightColor : null,
        ),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            width: 46.0,
            height: 46.0,
            child: Container(
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  children: [
                    Text(
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
                        color: isTemp
                            ? app.settings.appColor
                            : evaluation.value.value != 0 &&
                                    evaluation.evaluationType != null &&
                                    evaluation.evaluationType.name ==
                                        "Szazalekos"
                                ? null
                                : app.theme.evalColors[
                                    (evaluation.value.value - 1).clamp(0, 4)],
                      ),
                    ),
                    evaluation.evaluationType != null &&
                            evaluation.evaluationType.name == "Szazalekos"
                        ? Text("%",
                            style: TextStyle(
                              fontFamily: "GoogleSans",
                              fontSize: 20,
                              height: 0.8,
                              fontWeight: FontWeight.w700,
                            ))
                        : Container()
                  ],
                ),
              ),
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: isTemp
                    ? Text(
                        I18n.of(context).evaluationsGhost,
                        style: TextStyle(
                            color: app.settings.appColor,
                            fontWeight: FontWeight.bold),
                      )
                    : Text(
                        title,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                      ),
              ),
              isTemp
                  ? Container()
                  : evaluation.date != null
                      ? Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(formatDate(context, evaluation.date)),
                        )
                      : Container(),
            ],
          ),
          subtitle: isTemp
              ? Text(evaluation.value.weight.toString() + "%")
              : Text(
                  subtitle,
                  maxLines: evaluation.mode != null ? 2 : 1,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                ),
          trailing: isTemp
              ? IconButton(
                  icon: Icon(FeatherIcons.trash),
                  color: Colors.red,
                  tooltip: I18n.of(context).tooltipGhostRemove,
                  onPressed: () {
                    if (deleteCallback != null) deleteCallback(evaluation);
                  })
              : null,
        ),
      ),
    );
  }
}
