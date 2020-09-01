import 'package:filcnaplo/data/context/app.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/profile_icon.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo/data/models/absence.dart';
import 'package:intl/intl.dart';

class AbsenceView extends StatelessWidget {
  final Absence absence;

  AbsenceView(this.absence);

  @override
  Widget build(BuildContext context) {
    // todo: Justify button in parental mode
    return Container(
      padding: EdgeInsets.only(top: 14.0),
      decoration: BoxDecoration(
        color: app.settings.theme.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: ProfileIcon(name: absence.teacher),
            title: Row(
              children: [
                Expanded(
                  child: Text(absence.teacher, overflow: TextOverflow.ellipsis),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Text(formatDate(context, absence.date)),
                ),
              ],
            ),
            subtitle: Text(
              capital(absence.subject.name),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Absence Details
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                absence.lessonIndex != null
                    ? AbsenceDetail(
                        I18n.of(context).delayLesson,
                        absence.lessonIndex.toString() +
                            ". (" +
                            (absence.lessonStart != null
                                ? DateFormat("HH:mm")
                                    .format(absence.lessonStart)
                                : "?") +
                            " - " +
                            (absence.lessonEnd != null
                                ? DateFormat("HH:mm").format(absence.lessonEnd)
                                : "?") +
                            ")",
                      )
                    : Container(),
                absence.mode != null
                    ? AbsenceDetail(
                        I18n.of(context).delayMode,
                        absence.mode.description,
                      )
                    : Container(),
                absence.justification != null
                    ? AbsenceDetail(
                        I18n.of(context).absenceJustification,
                        absence.justification.description,
                      )
                    : Container(),
                absence.state != null
                    ? AbsenceDetail(
                        I18n.of(context).delayState,
                        absence.state,
                      )
                    : Container(),
                absence.submitDate != null
                    ? AbsenceDetail(
                        I18n.of(context).administrationTime,
                        formatDate(context, absence.submitDate, showTime: true),
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AbsenceDetail extends StatelessWidget {
  final String title;
  final String value;

  AbsenceDetail(this.title, this.value);

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
