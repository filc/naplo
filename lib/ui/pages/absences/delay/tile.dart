import 'package:filcnaplo/data/models/absence.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/ui/pages/absences/delay/view.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';

class DelayTile extends StatelessWidget {
  final Absence delay;

  DelayTile(this.delay);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            Icon(
              delay.state == "Igazolt"
                  ? FeatherIcons.check
                  : FeatherIcons.clock,
              color: delay.state == "Igazolt"
                  ? Colors.green
                  : delay.state == "Igazolando"
                      ? Colors.yellow[600]
                      : Colors.red,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Text(
                  capital(delay.subject.name),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Text(formatDate(context, delay.date)),
            ),
          ],
        ),
      ),
      onTap: () => showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) => DelayView(delay)),
    );
  }
}
