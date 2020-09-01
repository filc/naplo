import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/context/theme.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/dot.dart';
import 'package:filcnaplo/ui/pages/about/supporters/tile.dart';
import 'package:flutter/material.dart';

class SupporterBuilder {
  Future<List<Widget>> build(BuildContext context) async {
    List<Widget> tiles = [];
    final supporters = await app.kretaApi.client.getSupporters();

    tiles.add(Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          children: <Widget>[
            Spacer(),
            Dot(color: Color(0xFFE7513B)),
            SizedBox(width: 6.0),
            Text("Patreon"),
            Spacer(),
            Dot(color: Color(0xFFA66BFF)),
            SizedBox(width: 6.0),
            Text("Twitch"),
            Spacer(),
            Dot(color: ThemeContext.colors["default"]),
            SizedBox(width: 6.0),
            Text("Donate"),
            Spacer(),
          ],
        )));

    if (supporters[0].length > 0) {
      tiles.add(
        Padding(
          padding: EdgeInsets.only(top: 12.0, left: 12.0),
          child: Text(
            I18n.of(context).supportersTop.toUpperCase(),
            style: TextStyle(letterSpacing: 1.5),
          ),
        ),
      );
    }
    supporters[0].forEach((supporter) => tiles.add(SupporterTile(supporter)));

    if (supporters[1].length > 0) {
      tiles.add(
        Container(
          padding: EdgeInsets.only(top: 12.0, left: 12.0),
          child: Text(
            I18n.of(context).supportersAll.toUpperCase(),
            style: TextStyle(letterSpacing: 1.5),
          ),
        ),
      );
    }
    supporters[1].forEach((supporter) => tiles.add(SupporterTile(supporter)));

    return tiles;
  }
}
