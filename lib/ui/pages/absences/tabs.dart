import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/custom_tabs.dart';
import 'package:filcnaplo/ui/empty.dart';
import 'package:filcnaplo/ui/pages/accounts/page.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AbsenceTabs extends StatefulWidget {
  final Function callback;
  final _absenceTiles;
  final _delayTiles;
  final _missTiles;
  final _scaffoldKey;

  AbsenceTabs(
    this._scaffoldKey,
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
      initialIndex: app.tabState.absences.index,
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
    return NestedScrollView(
      headerSliverBuilder: (context, _) {
        return <Widget>[
          SliverAppBar(
            floating: true,
            pinned: true,
            snap: true,
            forceElevated: true,
            centerTitle: true,
            leading: Icon(FeatherIcons.slash),
            title: Text(I18n.of(context).absenceTitle),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: app.user.profileIcon,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AccountPage(),
                            fullscreenDialog: true));
                  },
                ),
              ),
            ],
            bottom: CustomTabBar(
              controller: _tabController,
              onTap: (value) {
                app.tabState.absences.index = value;
                _tabController.animateTo(value);
                app.storage.storage.update("tabs", {"absences": value});
              },
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
    );
  }
}
