import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/data/models/evaluation.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:google_fonts/google_fonts.dart';

class EvaluationTile extends StatelessWidget {
  final Evaluation evaluation;
  final Function deleteCallback;

  EvaluationTile(this.evaluation, [this.deleteCallback]);

  @override
  Widget build(BuildContext context) {
    final bool isTemp = evaluation.id.startsWith("temp_");

    return Container(
      padding: EdgeInsets.all(3),
      margin: EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: isTemp ? Theme.of(context).highlightColor : Colors.transparent,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 46.0,
          height: 46.0,
          child: Container(
            alignment: Alignment.center,
            child: Text(
              evaluation.value.value != 0
                  ? evaluation.value.value.toString()
                  : "?",
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                fontSize: 38.0,
                height: 1.2,
                fontWeight: FontWeight.w500,
                color: evaluation.value.value != 0
                    ? app.theme
                        .evalColors[(evaluation.value.value - 1).clamp(0, 4)]
                    : null,
              ),
            ),
          ),
        ),
        title: Row(
          children: <Widget>[
            Expanded(
              child: isTemp
                  ? Text(
                      "HA KAPNÉK EGY...",
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold),
                    )
                  : Text(
                      evaluation.type.name == "evkozi_jegy_ertekeles"
                          ? evaluation.description != ""
                              ? capital(evaluation.description)
                              : capital(evaluation.mode != null
                                      ? evaluation.mode.description
                                      : evaluation.value.valueName
                                          .split("(")[0]) +
                                  " " +
                                  (evaluation.value.weight != 100
                                      ? evaluation.value.weight.toString() + "%"
                                      : "")
                          : capital(evaluation.subject != null
                              ? evaluation.subject.name
                              : "?"),
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
            isTemp
                ? Icon(FeatherIcons.trash)
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
                evaluation.type.name == "evkozi_jegy_ertekeles"
                    ? capital(evaluation.subject != null
                            ? evaluation.subject.name
                            : "?") +
                        (evaluation.description != ""
                            ? (evaluation.mode != null
                                ? "\n" +
                                    evaluation.mode.description +
                                    " " +
                                    (evaluation.value.weight != 100
                                        ? evaluation.value.weight.toString() +
                                            "%"
                                        : "")
                                : evaluation.form != null
                                    ? "\n" + evaluation.form
                                    : "")
                            : "")
                    : evaluation.value.valueName.split("(")[0],
                maxLines: evaluation.mode != null ? 2 : 1,
                overflow: TextOverflow.ellipsis,
              ),
      ),
    );
  }
}
