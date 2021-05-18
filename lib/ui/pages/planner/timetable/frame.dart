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
  bool realWeekend = false;

  changeWeek(int week) {
    //Start loading animation by making setting future to a constant false
    if (mounted)
      setState(() {
        ready = false;
      });

    // Start loading new week
    selectedWeek = week;
    refreshWeek().then((successful) {
      if (successful) {
        //After week is refreshed, stop animation, display week
        if (mounted)
          setState(() {
            ready = true;

            _timetableBuilder.build(selectedWeek);
            int selectedDay = _tabController.index;
            int length = _timetableBuilder.week.days.length;
            length = length == 0 ? 1 : length;
            _tabController = TabController(
              vsync: this,
              length: length,
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
  int currentDay() {
    for (int i = 0; i < _timetableBuilder.week.days.length; i++) {
      Day element = _timetableBuilder.week.days[i];
      if (element.date.weekday >= DateTime.now().weekday) {
        return i;
      }
    }
    realWeekend = _timetableBuilder.week.days.length != 0;
    return 0;
  }

  @override
  void initState() {
    super.initState();

    _timetableBuilder = TimetableBuilder();
    selectedWeek = _timetableBuilder.getCurrentWeek();
    _timetableBuilder.build(selectedWeek);
    _tabController = TabController(
      length: _timetableBuilder.week.days.length,
      vsync: this,
      initialIndex: currentDay(),
    );

    refreshWeek(offline: true)
        .then((hasOfflineLessons) => setState(() {
              currentDay();
              ready = hasOfflineLessons && !realWeekend;
            }))
        .then((_) {
      refreshWeek().then((successfulOnlineRefresh) async {
        currentDay();
        if (realWeekend) {
          selectedWeek = selectedWeek + 1;
          changeWeek(selectedWeek);
        }
        if (mounted)
          setState(() {
            ready = successfulOnlineRefresh;
          });
      });
    });
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
                  tooltip: capital(I18n.of(context).dateWeekPrev),
                ),
                Expanded(
                  child: MaterialButton(
                    autofocus: false,
                    clipBehavior: Clip.none,
                    onPressed: () {
                      changeWeek(_timetableBuilder.getCurrentWeek());
                    },
                    child: Tooltip(
                      message: I18n.of(context).dateWeekCurrent,
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
                        softWrap: false,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
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
                  tooltip: capital(I18n.of(context).dateWeekNext),
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
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(app.settings.appColor),
                ),
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
