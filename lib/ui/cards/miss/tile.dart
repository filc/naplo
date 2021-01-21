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
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 46.0,
          height: 46.0,
          alignment: Alignment.center,
          child: Icon(
              miss.type.name == "HaziFeladatHiany"
                  ? FeatherIcons.home
                  : FeatherIcons.bookOpen,
              color: app.settings.appColor,
              size: 30),
        ),
        title: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                miss.type.description,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(formatDate(context, miss.submitDate)),
            ),
          ],
        ),
        subtitle: Text(miss.content.split("órán")[0]),
      ),
    );
  }
}
