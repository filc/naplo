import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/common/dot.dart';
import 'package:filcnaplo/ui/common/label.dart';
import 'package:filcnaplo/ui/pages/about/supporters/tile.dart';
import 'package:flutter/material.dart';

class SupporterBuilder {
  Future<List<Widget>> build(BuildContext context) async {
    List<Widget> tiles = [];
    final supporters = await app.kretaApi.client.getSupporters();

    tiles.add(Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          children: [
            Spacer(),
            Dot(color: Color(0xFFE7513B)),
            SizedBox(width: 6.0),
            Text("Patreon"),
            Spacer(),
            Dot(color: Colors.yellow.shade600),
            SizedBox(width: 6.0),
            Text("Donate"),
            Spacer(),
          ],
        )));

    if (supporters["progress"]["value"] != null) {
      tiles.add(Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        child: Row(
          children: [
            Text("\$" + supporters["progress"]["value"].toString()),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: LinearProgressIndicator(
                    minHeight: 12.0,
                    backgroundColor: Colors.black12,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(app.settings.appColor),
                    value: supporters["progress"]["value"] /
                        supporters["progress"]["max"],
                  ),
                ),
              ),
            ),
            Text("\$" + supporters["progress"]["max"].toString()),
          ],
        ),
      ));
    }

    if (supporters["top"].length > 0) {
      tiles.add(Label(I18n.of(context).supportersTop));
    }
    supporters["top"]
        .forEach((supporter) => tiles.add(SupporterTile(supporter)));

    if (supporters["all"].length > 0) {
      tiles.add(Label(I18n.of(context).supportersAll));
    }
    supporters["all"]
        .forEach((supporter) => tiles.add(SupporterTile(supporter)));

    return tiles;
  }
}
