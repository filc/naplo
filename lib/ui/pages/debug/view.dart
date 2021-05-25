import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/ui/common/empty.dart';
import 'package:filcnaplo/ui/pages/debug/struct.dart';
import 'package:filcnaplo/ui/pages/debug/tile.dart';
import 'package:flutter/material.dart';

enum DebugViewClass { evalutaions, planner, messages, absences }

class DebugView extends StatefulWidget {
  final DebugViewClass type;

  DebugView({required this.type});

  @override
  _DebugViewState createState() => _DebugViewState();
}

class _DebugViewState extends State<DebugView> {
  late DebugViewStruct debug;
  late List<Widget> debugChildren;

  @override
  void initState() {
    debug = DebugViewStruct(widget.type);
    debugChildren =
        debug.endpoints.map((endpoint) => DebugTile(endpoint)).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(color: app.settings.appColor),
        title: Text(debug.title ?? "null"),
        shadowColor: Colors.transparent,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Container(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: debugChildren.length > 0 ? debugChildren : [Empty()],
        ),
      ),
    );
  }
}
