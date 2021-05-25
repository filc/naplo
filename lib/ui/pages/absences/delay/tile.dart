import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/absence.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:filcnaplo/ui/pages/absences/delay/view.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:intl/intl.dart';

class DelayTile extends StatelessWidget {
  final Absence delay;

  DelayTile(this.delay);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 46.0,
              height: 46.0,
              alignment: Alignment.center,
              child: Icon(
                  delay.state == "Igazolt"
                      ? FeatherIcons.checkCircle
                      : FeatherIcons.clock,
                  color: delay.state == "Igazolt"
                      ? Colors.green
                      : delay.state == "Igazolando"
                          ? Colors.yellow[600]
                          : Colors.red,
                  size: 30),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        delay.type!.description,
                      ),
                      Text(
                          " • " +
                              delay.delay.toString() +
                              " " +
                              I18n.of(context).timeMinute,
                          style: TextStyle(
                              //Copied directly from ListTile source code, same as subtitle
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .fontSize,
                              color: Theme.of(context).textTheme.caption!.color),
                          softWrap: false,
                          overflow: TextOverflow.fade)
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(formatDate(context, delay.submitDate)!),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    delay.lessonIndex != null
                        ? Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: Text(
                              (delay.lessonIndex != 0
                                  ? delay.lessonIndex.toString() + "."
                                  : formatTime(delay.lessonStart!) +
                                      " - " +
                                      formatTime(delay.lessonEnd!)),
                              style: TextStyle(
                                  color:
                                      Theme.of(context).textTheme.caption!.color,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        : Container(),
                    Text(
                      capital(delay.subject!.name),
                      maxLines: 2,
                      softWrap: false,
                      overflow: TextOverflow.fade,
                    ),
                  ],
                ),
                Text(capital(DateFormat("EEEE", app.settings.locale.toString())
                        .format(delay.date!)) +
                    (delay.date!
                            .isAfter(DateTime.now().subtract(Duration(days: 6)))
                        ? ""
                        : (" " + formatDate(context, delay.date)!))),
              ],
            ),
          ),
        ),
        onTap: () => showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) => DelayView(delay)));
  }
}
