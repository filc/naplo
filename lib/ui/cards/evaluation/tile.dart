import 'package:filcnaplo/data/context/app.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/data/models/evaluation.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:google_fonts/google_fonts.dart';

class EvaluationTile extends StatelessWidget {
  final Evaluation evaluation;

  EvaluationTile(this.evaluation);

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
            child: Text(
              evaluation.type.name == "evkozi_jegy_ertekeles"
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
                      : "?"),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          evaluation.date != null
              ? Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(formatDate(context, evaluation.date)),
                )
              : Container(),
        ],
      ),
      subtitle: Text(
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
                                ? evaluation.value.weight.toString() + "%"
                                : "")
                        : evaluation.form != null ? "\n" + evaluation.form : "")
                    : "")
            : evaluation.value.valueName.split("(")[0],
        maxLines: evaluation.mode != null ? 2 : 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
