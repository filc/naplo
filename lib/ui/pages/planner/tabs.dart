//import 'package:flutter/gestures.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/ui/custom_tabs.dart';
import 'package:filcnaplo/ui/empty.dart';
import 'package:filcnaplo/ui/pages/accounts/page.dart';
import 'package:filcnaplo/ui/pages/planner/timetable/frame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo/data/context/app.dart';
//import 'package:feather_icons_flutter/feather_icons_flutter.dart';

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
  bool showPastHomeworks = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: 3,
      initialIndex: app.tabState.timetable.index,
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
              snap: true,
              forceElevated: true,
              leading: Icon(FeatherIcons.calendar),
              title: Text(I18n.of(context).plannerTitle),
              centerTitle: true,
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    icon: app.user.profileIcon,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountPage()));
                    },
                  ),
                ),
              ],
              bottom: CustomTabBar(
                controller: _tabController,
                color: app.settings.theme.textTheme.bodyText1.color,
                onTap: (value) {
                  app.tabState.timetable.index = value;
                  _tabController.animateTo(value);
                  app.sync.updateCallback();
                  app.storage.storage.update("tabs", {"timetable": value});
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
          physics: NeverScrollableScrollPhysics(),
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
              child: CupertinoScrollbar(
                child: ListView(
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  children: <Widget>[
                    widget.homeworkTiles[0].length > 0
                        ? Column(children: widget.homeworkTiles[0])
                        : Empty(title: I18n.of(context).emptyHomework),
                    FlatButton(
                      onPressed: () => setState(
                          () => showPastHomeworks = !showPastHomeworks),
                      child: Row(
                        children: <Widget>[
                          Expanded(child: Text(I18n.of(context).homeworkPast)),
                          Icon(
                            showPastHomeworks
                                ? FeatherIcons.chevronUp
                                : FeatherIcons.chevronDown,
                          ),
                        ],
                      ),
                    ),
                    showPastHomeworks
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: widget.homeworkTiles[1].length > 0
                                ? Column(children: widget.homeworkTiles[1])
                                : Empty(
                                    title: I18n.of(context).emptyPastHomework,
                                  ),
                          )
                        : Container(),
                  ],
                ),
              ),
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
              child: CupertinoScrollbar(
                child: ListView(
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  children: <Widget>[
                    widget.examTiles[0].length > 0
                        ? Column(children: widget.examTiles[0])
                        : Empty(title: I18n.of(context).emptyExams),
                    FlatButton(
                      onPressed: () =>
                          setState(() => showPastExams = !showPastExams),
                      child: Row(
                        children: <Widget>[
                          Expanded(child: Text(I18n.of(context).examPast)),
                          Icon(
                            showPastExams
                                ? FeatherIcons.chevronUp
                                : FeatherIcons.chevronDown,
                          ),
                        ],
                      ),
                    ),
                    showPastExams
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: widget.examTiles[1].length > 0
                                ? Column(children: widget.examTiles[1])
                                : Empty(title: I18n.of(context).emptyPastExams),
                          )
                        : Container(),
                  ],
                ),
              ),
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
