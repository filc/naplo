import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/common/custom_snackbar.dart';
import 'package:filcnaplo/ui/common/empty.dart';
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
  int currentUser = app.selectedUser;
  int selectedWeek = 0;
  TimetableBuilder _timetableBuilder;
  Week currentWeek;
  bool ready = false;

  changeWeek(int week) {
    //Start loading animation by making setting future to a constant false
    setState(() {
      ready = false;
    });

    // Start loading new week
    selectedWeek = week;
    refreshWeek().then((successful) {
      if (successful) {
        //After week is refreshed, stop animation, display week
        setState(() {
          ready = true;

          _timetableBuilder.build(selectedWeek);
          int selectedDay = _tabController.index;
          int length = _timetableBuilder.week.days.length;
          _tabController = TabController(
            vsync: this,
            length: length.clamp(1, length),
            initialIndex: selectedDay.clamp(0, length - 1),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            color: Colors.red,
            message: I18n.of(context).errorTimetableWeek,
          ),
        );
      }
    });
  }

  /// Return the index of today's tab in the timetable.
  /// Returns 0 (first tab) if there are no more schooldays this week.
  int todayIndex() {
    for (int i = 1; i <= _timetableBuilder.week.days.length; i++) {
      Day element = _timetableBuilder.week.days[i];
      if (element.date.weekday >= DateTime.now().weekday) {
        return i;
      }
    }

    return 0;
  }

  @override
  void initState() {
    super.initState();

    _timetableBuilder = TimetableBuilder();
    _timetableBuilder.build(selectedWeek);

    DateTime currentDay = _timetableBuilder.week.days.firstWhere((day) {
      int dif = day.date.difference(DateTime.now()).inHours;

      return dif > -24 && dif < 0;
    }, orElse: () => Day()).date;

    selectedWeek = _timetableBuilder.getCurrentWeek();

    refreshWeek(offline: true)
        .then((hasOfflineLessons) => setState(() {
              ready = hasOfflineLessons;
            }))
        .then((_) => {
              refreshWeek().then((successfulOnlineRefresh) => setState(() {
                    ready = successfulOnlineRefresh;
                    _timetableBuilder.build(selectedWeek);
                  }))
            });

    int dayIndex = currentDay != null ? todayIndex() : 0;

    if (_timetableBuilder.week.days.length > 1) {
      dayIndex = dayIndex.clamp(0, _timetableBuilder.week.days.length - 1);
    }

    _tabController = TabController(
      vsync: this,
      length: _timetableBuilder.week.days.length.clamp(1, 7),
      initialIndex: dayIndex,
    );
  }

  @override
  void dispose() {
    if (mounted) {
      super.dispose();
      _tabController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (app.selectedUser != currentUser) {
      changeWeek(selectedWeek);
      currentUser = app.selectedUser;
    }

    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(FeatherIcons.chevronLeft,
                      color: app.settings.appColor),
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
                        formatDate(context, currentWeek.start, weekday: false) +
                        " - " +
                        formatDate(context, currentWeek.end, weekday: false) +
                        ")",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                IconButton(
                  icon: Icon(FeatherIcons.chevronRight,
                      color: app.settings.appColor),
                  onPressed: () {
                    if (selectedWeek < 51) {
                      changeWeek(selectedWeek + 1);
                    }
                  },
                ),
              ],
            ),
          ),
          if (ready)
            Expanded(
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
            ),
          if (ready)
            Container(
              child: TimetableTabBar(
                color: app.settings.theme.textTheme.bodyText1.color,
                currentDayColor: Colors.grey,
                controller: _tabController,
                days: _timetableBuilder.week.days.length > 0
                    ? _timetableBuilder.week.days
                    : [],
              ),
            ),
          if (!ready)
            Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
        ],
      ),
    );
  }

  Future<bool> refreshWeek({bool offline = false}) async {
    currentWeek = _timetableBuilder.getWeek(selectedWeek);
    app.user.sync.timetable.from = currentWeek.start;
    app.user.sync.timetable.to = currentWeek.end;
    if (offline) {
      return app.user.sync.timetable.lessons.isNotEmpty;
    } else {
      bool successful = false;
      for (int i = 0; i < 5; i++) {
        successful = await app.user.sync.timetable.sync();
        if (successful) break;
        await Future.delayed(Duration(seconds: 1));
      }
      return successful;
    }
  }
}
