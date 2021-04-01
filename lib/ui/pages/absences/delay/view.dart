import 'package:filcnaplo/ui/common/bottom_card.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/common/profile_icon.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo/data/models/absence.dart';
import 'package:intl/intl.dart';

class DelayView extends StatelessWidget {
  final Absence delay;

  DelayView(this.delay);

  @override
  Widget build(BuildContext context) {
    // todo: Justify button in parental mode
    return BottomCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: ProfileIcon(name: delay.teacher),
            title: Row(
              children: [
                Expanded(
                  child: Text(delay.teacher,
                      softWrap: false, overflow: TextOverflow.fade),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Text(formatDate(context, delay.date)),
                ),
              ],
            ),
            subtitle: Text(
              capital(delay.subject.name),
              maxLines: 2,
              softWrap: false,
              overflow: TextOverflow.fade,
            ),
          ),

          // Delay Details
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DelayDetail(
                I18n.of(context).delayLesson,
                (delay.lessonIndex != null
                        ? (delay.lessonIndex.toString() + ". (")
                        : "") +
                    (delay.lessonStart != null
                        ? DateFormat("HH:mm").format(delay.lessonStart)
                        : I18n.of(context).unknown) +
                    " - " +
                    (delay.lessonEnd != null
                        ? DateFormat("HH:mm").format(delay.lessonEnd)
                        : I18n.of(context).unknown) +
                    (delay.lessonIndex != null ? ")" : ""),
              ),
              delay.mode != null
                  ? DelayDetail(
                      I18n.of(context).delayMode,
                      delay.mode.description,
                    )
                  : Container(),
              delay.justification != null
                  ? DelayDetail(
                      I18n.of(context).absenceJustification,
                      delay.justification.description,
                    )
                  : Container(),
              delay.state != null
                  ? DelayDetail(
                      I18n.of(context).delayState,
                      delay.state,
                    )
                  : Container(),
              delay.submitDate != null
                  ? DelayDetail(
                      I18n.of(context).administrationTime,
                      formatDate(context, delay.submitDate, showTime: true),
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }
}

class DelayDetail extends StatelessWidget {
  final String title;
  final String value;

  DelayDetail(this.title, this.value);

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
