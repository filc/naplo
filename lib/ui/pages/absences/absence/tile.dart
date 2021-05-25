import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/absence.dart';
import 'package:filcnaplo/ui/pages/absences/absence/view.dart';
import 'package:filcnaplo/utils/colors.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/ui/cards/absence/tile.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:intl/intl.dart';

class AbsenceTileGroup extends StatelessWidget {
  final List<Absence> absences;

  AbsenceTileGroup(this.absences);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: absences.length > 0
            ? absences.length > 1
                ? Container(
                    padding: EdgeInsets.only(right: 9),
                    decoration: BoxDecoration(
                      color: textColor(Theme.of(context).backgroundColor)
                          .withAlpha(25),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          accentColor:
                              Theme.of(context).textTheme.bodyText1!.color),
                      child: ExpansionTile(
                        initiallyExpanded: absences.first.date!.isAfter(
                            DateTime.now().subtract(Duration(days: 10))),
                        tilePadding: EdgeInsets.zero,
                        childrenPadding: EdgeInsets.only(bottom: 9),
                        backgroundColor: Colors.transparent,
                        leading: Container(
                          width: 46.0,
                          height: 46.0,
                          alignment: Alignment.center,
                          child: Icon(
                              absences.any((absence) =>
                                      absence.state == "Igazolatlan" ||
                                      absence.state == "Igazolando")
                                  ? FeatherIcons.slash
                                  : FeatherIcons.checkCircle,
                              color: absences.any((absence) =>
                                      absence.state == "Igazolatlan")
                                  ? Colors.red
                                  : absences.any((absence) =>
                                          absence.state == "Igazolando")
                                      ? Colors.yellow[600]
                                      : Colors.green,
                              size: 30),
                        ),
                        title: Text(amountPlural(I18n.of(context).absence,
                            I18n.of(context).absenceAbsences, absences.length)),
                        subtitle: Text(capital(DateFormat(
                                    "EEEE", app.settings.locale.toString())
                                .format(absences[0].date!)) +
                            (absences[0].date!.isAfter(
                                    DateTime.now().subtract(Duration(days: 6)))
                                ? ""
                                : (" " +
                                    formatDate(context, absences[0].date)!))),
                        children:
                            absences.map((a) => AbsenceTileSmall(a)).toList(),
                      ),
                    ),
                  )
                : AbsenceTile(absences.first)
            : Container());
  }
}

class AbsenceTileSmall extends StatelessWidget {
  final Absence absence;

  AbsenceTileSmall(this.absence);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
        child: Row(
          children: [
            Icon(
              absence.state == "Igazolt"
                  ? FeatherIcons.check
                  : FeatherIcons.slash,
              color: absence.state == "Igazolt"
                  ? Colors.green
                  : absence.state == "Igazolando"
                      ? Colors.yellow[600]
                      : Colors.red,
            ),
            Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: absence.lessonIndex != null
                  ? Text(
                      absence.lessonIndex.toString() + ".",
                      style: TextStyle(
                          color: Theme.of(context).textTheme.caption!.color),
                    )
                  : Container(),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 6.0),
                child: Text(
                  capital(absence.subject!.name),
                  softWrap: false,
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () => showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) => AbsenceView(absence)),
    );
  }
}
