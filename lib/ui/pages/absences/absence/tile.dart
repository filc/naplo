import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/models/absence.dart';
import 'package:filcnaplo/ui/pages/absences/absence/view.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/ui/cards/absence/tile.dart';
import 'package:filcnaplo/generated/i18n.dart';

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
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                            color: Theme.of(context).backgroundColor)),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                          accentColor:
                              Theme.of(context).textTheme.bodyText1.color),
                      child: ExpansionTile(
                        initiallyExpanded: absences.first.date.isAfter(
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
                                  : FeatherIcons.check,
                              color: absences.any((absence) =>
                                      absence.state == "Igazolatlan")
                                  ? Colors.red
                                  : absences.any((absence) =>
                                          absence.state == "Igazolando")
                                      ? Colors.yellow[600]
                                      : Colors.green,
                              size: 30),
                        ),
                        title: Text(formatDate(context, absences[0].date)),
                        subtitle: Text(amountPlural(I18n.of(context).absence,
                            I18n.of(context).absenceAbsences, absences.length)),
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
          children: <Widget>[
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
                      (absence.lessonIndex != 0
                          ? absence.lessonIndex.toString() + "."
                          : formatTime(absence.lessonStart) +
                              " - " +
                              formatTime(absence.lessonEnd)),
                      style: TextStyle(color: Colors.grey),
                    )
                  : Container(),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 6.0),
                child: Text(
                  capital(absence.subject.name),
                  overflow: TextOverflow.ellipsis,
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
