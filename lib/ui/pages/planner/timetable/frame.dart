import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/empty.dart';
import 'package:filcnaplo/ui/pages/planner/timetable/builder.dart';
import 'package:filcnaplo/ui/pages/planner/timetable/day.dart';
import 'package:filcnaplo/ui/pages/planner/timetable/day_tab.dart';
import 'package:filcnaplo/ui/pages/planner/timetable/week.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';

class TimetableFrame extends StatefulWidget {
  @override
  _TimetableFrameState createState() => _TimetableFrameState();
}

class _TimetableFrameState extends State<TimetableFrame>
    with TickerProviderStateMixin {
  TabController _tabController;

  int selectedWeek = 0;
  TimetableBuilder _timetableBuilder;
  Week currentWeek;

  Future<bool> future;

  changeWeek(int week) {
    setState(() {
      selectedWeek = week;
      refreshWeek();
    });
  }

  @override
  void initState() {
    super.initState();
    _timetableBuilder = TimetableBuilder();
    _tabController = TabController(
      vsync: this,
      length: 1,
    );

    selectedWeek = _timetableBuilder.getCurrentWeek();
    future = refreshWeek();
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
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        _timetableBuilder.build(selectedWeek);

        _tabController = TabController(
          vsync: this,
          length: _timetableBuilder.week.days.length.clamp(1, 7),
          initialIndex: 0,
        );

        DateTime currentDay = _timetableBuilder.week.days.firstWhere((day) {
          int dif = day.date.difference(DateTime.now()).inHours;

          return dif > -24 && dif < 0;
        }, orElse: () => Day()).date;

        int dayIndex = 0;

        dayIndex = currentDay != null
            ? currentDay.weekday - (6 - _timetableBuilder.week.days.length)
            : 0;

        if (_timetableBuilder.week.days.length > 1) {
          dayIndex = dayIndex.clamp(0, _timetableBuilder.week.days.length - 1);
        }

        _tabController.index = dayIndex;

        bool ready = snapshot.hasData || snapshot.hasError;

        return Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(FeatherIcons.chevronLeft),
                      onPressed: () {
                        if (selectedWeek > 0) {
                          changeWeek(selectedWeek - 1);
                        }
                      },
                    ),
                    Expanded(
                      child: Text(
                        (selectedWeek + 1).toString() +
                            ". " +
                            I18n.of(context).dateWeek +
                            " (" +
                            formatDate(context, currentWeek.start,
                                weekday: false) +
                            " - " +
                            formatDate(context, currentWeek.end,
                                weekday: false) +
                            ")",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    IconButton(
                      icon: Icon(FeatherIcons.chevronRight),
                      onPressed: () {
                        if (selectedWeek < 51) {
                          changeWeek(selectedWeek + 1);
                        }
                      },
                    ),
                  ],
                ),
              ),
              ready
                  ? Expanded(
                      child: Container(
                        child: TabBarView(
                          controller: _tabController,
                          children: _timetableBuilder.week.days.length > 0
                              ? _timetableBuilder.week.days
                                  .map((d) => DayTab(d))
                                  .toList()
                              : [Empty(title: I18n.of(context).timetableEmpty)],
                        ),
                      ),
                    )
                  : Container(),
              ready
                  ? Container(
                      child: TimetableTabBar(
                        color: app.settings.theme.textTheme.bodyText1.color,
                        currentDayColor: Colors.grey,
                        controller: _tabController,
                        days: _timetableBuilder.week.days.length > 0
                            ? _timetableBuilder.week.days
                            : [],
                      ),
                    )
                  : Container(),
              !ready
                  ? Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Container(),
            ],
          ),
        );
      },
    );
  }

  Future<bool> refreshWeek() async {
    currentWeek = _timetableBuilder.getWeek(selectedWeek);

    app.user.sync.timetable.from = currentWeek.start;
    app.user.sync.timetable.to = currentWeek.end;

    await app.user.sync.timetable.sync();

    return true;
  }
}
