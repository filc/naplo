import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/context/page.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/helpers/averages.dart';
import 'package:filcnaplo/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/ui/cards/base.dart';
import 'package:filcnaplo/data/models/evaluation.dart';

class FinalCard extends BaseCard {
  final List<Evaluation> evals;
  final Key key;
  final DateTime compare;

  FinalCard(
    this.evals, {
    this.key,
    this.compare,
  });

  @override
  Widget build(BuildContext context) {
    double finalAvg = averageEvals(evals, finalAvg: true);

    String title = "";
    switch (evals.first.type) {
      case EvaluationType.firstQ:
        title += I18n.of(context).evaluationsQYear;
        break;
      case EvaluationType.secondQ:
        title += I18n.of(context).evaluations2qYear;
        break;
      case EvaluationType.halfYear:
        title += I18n.of(context).evaluationsHalfYear;
        break;
      case EvaluationType.thirdQ:
        title += I18n.of(context).evaluations3qYear;
        break;
      case EvaluationType.fourthQ:
        title += I18n.of(context).evaluations4qYear;
        break;
      case EvaluationType.endYear:
        title += I18n.of(context).evaluationsEndYear;
        break;
      case EvaluationType.midYear:
        break;
    }
    title += (" " + I18n.of(context).evaluations);

    int dicseretesAmount =
        evals.where((e) => e.description == "Dicséret").length;
    int failedAmount = evals.where((e) => e.value.value == 1).length;

    Color color = textColor(getAverageColor(finalAvg));
    Color secondary = color.withAlpha(180);

    onTap() {
      app.gotoPage(PageType.evaluations,
          pageContext: PageContext(evaluationType: evals.first.type));
    }

    return GestureDetector(
      onTap: onTap,
      child: BaseCard(
        color: getAverageColor(finalAvg),
        gradient: true,
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            width: 46.0,
            height: 46.0,
            child: Container(
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  finalAvg.toStringAsFixed(1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28.0,
                    height: 1.2,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
              ),
            ),
          ),
          title: Row(
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
              Text(" • " + evals.length.toString() + I18n.of(context).amount,
                  style: TextStyle(
                      fontSize: Theme.of(context).textTheme.bodyText2.fontSize,
                      color: secondary),
                  softWrap: false,
                  overflow: TextOverflow.fade)
            ],
          ),
          subtitle: (dicseretesAmount + failedAmount) > 0
              ? Text(
                  (dicseretesAmount > 0
                          ? (I18n.of(context).evaluationsCompliment +
                              ": " +
                              dicseretesAmount.toString() +
                              I18n.of(context).amount +
                              ((failedAmount > 0) ? ", " : ""))
                          : ("")) +
                      (failedAmount > 0
                          ? (I18n.of(context).evaluationsFailed +
                              ": " +
                              failedAmount.toString() +
                              I18n.of(context).amount)
                          : ("")),
                  style: TextStyle(color: secondary),
                )
              : null,
          trailing: ClipOval(
            child: Material(
              color: Colors.transparent,
              child: IconButton(
                icon: Icon(
                  FeatherIcons.arrowRight,
                  color: color,
                ),
                onPressed: onTap,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
