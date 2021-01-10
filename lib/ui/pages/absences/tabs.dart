import 'package:filcnaplo/ui/account_button.dart';
import 'package:filcnaplo/ui/custom_snackbar.dart';
import 'package:filcnaplo/ui/custom_tabs.dart';
import 'package:filcnaplo/ui/pages/debug/button.dart';
import 'package:filcnaplo/ui/pages/debug/view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/empty.dart';

class AbsenceTabs extends StatefulWidget {
  final Function callback;
  final _absenceTiles;
  final _delayTiles;
  final _missTiles;

  AbsenceTabs(
    this._absenceTiles,
    this._delayTiles,
    this._missTiles,
    this.callback,
  );

  @override
  _AbsenceTabsState createState() => _AbsenceTabsState();
}

class _AbsenceTabsState extends State<AbsenceTabs>
    with SingleTickerProviderStateMixin {
  final _refreshKeyAbsences = GlobalKey<RefreshIndicatorState>();
  final _refreshKeyDelays = GlobalKey<RefreshIndicatorState>();
  final _refreshKeyMisses = GlobalKey<RefreshIndicatorState>();

  TabController _tabController;

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
              shadowColor: Colors.transparent,
              backgroundColor:
                  app.settings.theme.bottomNavigationBarTheme.backgroundColor,
              title: Text(
                I18n.of(context).absenceTitle,
                style: TextStyle(fontSize: 22.0),
              ),
              actions: <Widget>[
                app.debugMode
                    ? DebugButton(DebugViewClass.absences)
                    : Container(),
                AccountButton()
              ],
              bottom: CustomTabBar(
                controller: _tabController,
                onTap: (value) => _tabController.animateTo(value),
                color: app.settings.theme.textTheme.bodyText1.color,
                labels: [
                  CustomLabel(title: capital(I18n.of(context).absenceAbsences)),
                  CustomLabel(title: capital(I18n.of(context).absenceDelays)),
                  CustomLabel(title: capital(I18n.of(context).absenceMisses)),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // Absences
            RefreshIndicator(
              key: _refreshKeyAbsences,
              onRefresh: () async {
                if (!await app.user.sync.absence.sync()) {
                  ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
                    message: I18n.of(context).errorMessages,
                    color: Colors.red,
                  ));
                } else {
                  widget.callback();
                }
              },
              child: widget._absenceTiles.length > 0
                  ? CupertinoScrollbar(
                      child: ListView(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          physics: BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          children: widget._absenceTiles),
                    )
                  : Empty(title: I18n.of(context).emptyAbsences),
            ),

            // Delays
            RefreshIndicator(
              key: _refreshKeyDelays,
              onRefresh: () async {
                if (!await app.user.sync.absence.sync()) {
                  ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
                    message: I18n.of(context).errorMessages,
                    color: Colors.red,
                  ));
                } else {
                  widget.callback();
                }
              },
              child: widget._delayTiles.length > 0
                  ? CupertinoScrollbar(
                      child: ListView(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          physics: BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          children: widget._delayTiles),
                    )
                  : Empty(title: I18n.of(context).emptyDelays),
            ),

            // Misses
            RefreshIndicator(
                key: _refreshKeyMisses,
                onRefresh: () async {
                  if (!await app.user.sync.note.sync()) {
                    ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
                      message: I18n.of(context).errorMessages,
                      color: Colors.red,
                    ));
                  } else {
                    widget.callback();
                  }
                },
                child: widget._missTiles.length > 0
                    ? CupertinoScrollbar(
                        child: ListView(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            physics: BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            children: widget._missTiles),
                      )
                    : Empty(
                        title: I18n.of(context).emptyMisses)), // get from notes
          ],
        ),
      ),
    );
  }
}
