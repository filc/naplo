import 'package:filcnaplo/ui/empty.dart';
import 'package:filcnaplo/ui/pages/debug/struct.dart';
import 'package:filcnaplo/ui/pages/debug/tile.dart';
import 'package:flutter/material.dart';

enum DebugViewClass { evalutaions, planner, messages, absences }

class DebugView extends StatefulWidget {
  final DebugViewClass type;

  DebugView({@required this.type});

  @override
  _DebugViewState createState() => _DebugViewState();
}

class _DebugViewState extends State<DebugView> {
  DebugViewStruct debug;

  @override
  void initState() {
    debug = DebugViewStruct(widget.type);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(),
        title: Text(debug.title),
        shadowColor: Colors.transparent,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Container(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children:
              debug.endpoints.map((endpoint) => DebugTile(endpoint)).toList() ??
                  [Empty()],
        ),
      ),
    );
  }
}
