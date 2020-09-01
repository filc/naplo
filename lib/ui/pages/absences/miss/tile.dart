import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/note.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';

class MissTile extends StatelessWidget {
  final Note miss;

  MissTile(this.miss);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            Icon(
              miss.type.name == "HaziFeladatHiany"
                  ? FeatherIcons.home
                  : FeatherIcons.bookOpen,
              color: app.settings.appColor,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Text(
                  miss.content.split("órán")[0],
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Text(formatDate(context, miss.date)),
            ),
          ],
        ),
      ),
    );
  }
}
