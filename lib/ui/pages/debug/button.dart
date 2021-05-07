import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/ui/pages/debug/view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DebugButton extends StatelessWidget {
  final DebugViewClass type;

  DebugButton(this.type);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(FeatherIcons.cpu, color: app.settings.appColor),
      onPressed: () => Navigator.of(context, rootNavigator: true).push(
          CupertinoPageRoute(builder: (context) => DebugView(type: type))),
      tooltip: "DebugView",
    );
  }
}
