import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/subject.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/helpers/averages.dart';
import 'package:filcnaplo/ui/pages/evaluations/subjects/view.dart';
import 'package:filcnaplo/utils/colors.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubjectTile extends StatelessWidget {
  final Subject subject;
  final double studentAvg;
  final double classAvg;

  SubjectTile(this.subject, this.studentAvg, this.classAvg);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: MaterialButton(
        elevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            capital(subject.name),
            style: TextStyle(fontSize: 18.0),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              roundSubjAvg(studentAvg) < 3.0
                  ? Tooltip(
                      message: roundSubjAvg(studentAvg) < 2.0
                          ? I18n.of(context).tooltipSubjectsFailWarning
                          : I18n.of(context).tooltipSubjectsAlmostFailWarning,
                      child: Container(
                        child: Icon(
                          FeatherIcons.alertCircle,
                          color: getAverageColor(studentAvg),
                        ),
                        margin: EdgeInsets.only(right: 8),
                      ),
                    )
                  : Container(),
              classAvg != null && roundSubjAvg(classAvg) != 0
                  ? Tooltip(
                      message:
                          capitalize(I18n.of(context).evaluationAverageClass),
                      child: Container(
                        width: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(45.0)),
                          border: Border.all(
                            width: 3.0,
                            color: getAverageColor(classAvg),
                          ),
                        ),
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          app.settings.language.split("_")[0] == "en"
                              ? classAvg.toStringAsFixed(2)
                              : classAvg
                                  .toStringAsFixed(2)
                                  .split(".")
                                  .join(","),
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Container(),
              studentAvg > 0 && studentAvg <= 5.0
                  ? Tooltip(
                      message: capitalize(I18n.of(context).evaluationAverage),
                      child: Container(
                        width: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(45.0)),
                          color: getAverageColor(studentAvg),
                        ),
                        padding: EdgeInsets.all(8.0),
                        margin: EdgeInsets.only(left: 8.0),
                        child: Text(
                          app.settings.language.split("_")[0] == "en"
                              ? studentAvg.toStringAsFixed(2)
                              : studentAvg
                                  .toStringAsFixed(2)
                                  .split(".")
                                  .join(","),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textColor(
                              getAverageColor(studentAvg),
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
              builder: (context) => SubjectView(subject, classAvg)));
        },
      ),
    );
  }
}
