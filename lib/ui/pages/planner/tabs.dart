import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/ui/account_button.dart';
import 'package:filcnaplo/ui/custom_tabs.dart';
import 'package:filcnaplo/ui/empty.dart';
import 'package:filcnaplo/ui/pages/debug/button.dart';
import 'package:filcnaplo/ui/pages/debug/view.dart';
import 'package:filcnaplo/ui/pages/planner/timetable/frame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo/data/context/app.dart';

class PlannerTabs extends StatefulWidget {
  final _scaffoldKey;
  final homeworkTiles;
  final examTiles;
  final Function callback;

  PlannerTabs(
    this._scaffoldKey,
    this.homeworkTiles,
    this.examTiles, {
    this.callback,
  });

  @override
  _PlannerTabsState createState() => _PlannerTabsState();
}

class _PlannerTabsState extends State<PlannerTabs>
    with SingleTickerProviderStateMixin {
  final _refreshKeyTimetable = GlobalKey<RefreshIndicatorState>();
  final _refreshKeyHomeworks = GlobalKey<RefreshIndicatorState>();
  final _refreshKeyExams = GlobalKey<RefreshIndicatorState>();
  TabController _tabController;

  bool showPastExams = false;
  bool showPastHomework = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: 3,
    );
  }

  @override
  void dispose() {
    if (mounted) {
      _tabController.dispose();
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return <Widget>[
            SliverAppBar(
              floating: true,
              pinned: true,
              forceElevated: true,
              title: Text(
                I18n.of(context).plannerTitle,
                style: TextStyle(fontSize: 22.0),
              ),
              actions: <Widget>[
                app.debugMode
                    ? DebugButton(DebugViewClass.planner)
                    : Container(),
                AccountButton()
              ],
              bottom: CustomTabBar(
                controller: _tabController,
                color: app.settings.theme.textTheme.bodyText1.color,
                onTap: (value) {
                  _tabController.animateTo(value);
                  app.sync.updateCallback();
                },
                labels: [
                  CustomLabel(
                      title: capital(I18n.of(context).plannerTimetable)),
                  CustomLabel(title: capital(I18n.of(context).plannerHomework)),
                  CustomLabel(title: capital(I18n.of(context).plannerExams)),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            // Timetable
            RefreshIndicator(
              key: _refreshKeyTimetable,
              onRefresh: () async {
                if (!await app.user.sync.timetable.sync()) {
                  widget._scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text(
                      I18n.of(context).errorMessages,
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ));
                } else {
                  widget.callback();
                }
              },
              child: TimetableFrame(),
            ),

            // Homeworks
            RefreshIndicator(
              key: _refreshKeyHomeworks,
              onRefresh: () async {
                if (!await app.user.sync.homework.sync()) {
                  widget._scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text(
                      I18n.of(context).errorMessages,
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ));
                } else {
                  widget.callback();
                }
              },
              child: widget.homeworkTiles[0].length > 0 ||
                      widget.homeworkTiles[1].length > 0
                  ? CupertinoScrollbar(
                      child: ListView(
                        padding: EdgeInsets.only(top: 12.0),
                        physics: BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        children: <Widget>[
                          Column(children: widget.homeworkTiles[0]),
                          widget.homeworkTiles[0].length == 0
                              ? Padding(
                                  padding:
                                      EdgeInsets.only(left: 12.0, top: 12.0),
                                  child: Text(
                                    I18n.of(context).homeworkPast.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      letterSpacing: .7,
                                    ),
                                  ),
                                )
                              : widget.homeworkTiles[1].length > 0
                                  ? FlatButton(
                                      onPressed: () => setState(() =>
                                          showPastHomework = !showPastHomework),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                              child: Text(I18n.of(context)
                                                  .homeworkPast)),
                                          Icon(
                                            showPastHomework
                                                ? FeatherIcons.chevronUp
                                                : FeatherIcons.chevronDown,
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                          showPastHomework ||
                                  widget.homeworkTiles[0].length == 0
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4.0),
                                  child:
                                      Column(children: widget.homeworkTiles[1]))
                              : Container(),
                        ],
                      ),
                    )
                  : Empty(title: I18n.of(context).emptyHomework),
            ),

            // Exams
            RefreshIndicator(
              key: _refreshKeyExams,
              onRefresh: () async {
                if (!await app.user.sync.exam.sync()) {
                  widget._scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text(
                      I18n.of(context).errorMessages,
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ));
                } else {
                  widget.callback();
                }
              },
              child: widget.examTiles[0].length > 0 ||
                      widget.examTiles[1].length > 0
                  ? CupertinoScrollbar(
                      child: ListView(
                        padding: EdgeInsets.only(top: 12.0),
                        physics: BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        children: <Widget>[
                          Column(children: widget.examTiles[0]),
                          widget.examTiles[0].length == 0
                              ? Padding(
                                  padding:
                                      EdgeInsets.only(left: 12.0, top: 12.0),
                                  child: Text(
                                    I18n.of(context).examPast.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      letterSpacing: .7,
                                    ),
                                  ),
                                )
                              : widget.examTiles[1].length > 0
                                  ? FlatButton(
                                      onPressed: () => setState(
                                          () => showPastExams = !showPastExams),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                              child: Text(
                                                  I18n.of(context).examPast)),
                                          Icon(
                                            showPastExams
                                                ? FeatherIcons.chevronUp
                                                : FeatherIcons.chevronDown,
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                          showPastExams || widget.examTiles[0].length == 0
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4.0),
                                  child: Column(children: widget.examTiles[1]))
                              : Container(),
                        ],
                      ),
                    )
                  : Empty(title: I18n.of(context).emptyExams),
            ),
          ],
        ),
      ),
    );
  }
}

// Offset _getPosition(GlobalKey key) {
//   final RenderBox renderBox = key.currentContext.findRenderObject();
//   final position = renderBox.localToGlobal(Offset.zero);
//   return position;
// }
