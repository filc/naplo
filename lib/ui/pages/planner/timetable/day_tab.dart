import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo/ui/pages/planner/timetable/day.dart';
import 'package:filcnaplo/ui/pages/planner/timetable/tile.dart';
import 'package:flutter/material.dart';

class DayTab extends StatelessWidget {
  final Day day;

  DayTab(this.day);

  @override
  Widget build(BuildContext context) {
    day.buildTiles();

    if (day.lessons.any((l) => l.subject == null) &&
        !day.tiles
            .map((t) => t.lesson.id)
            .contains(day.lessons.firstWhere((l) => l.subject == null).id)) {
      day.tiles.insert(
        0,
        SpecialDateTile(day.lessons.firstWhere((l) => l.subject == null)),
      );
    }

    return Container(
      child: ListView(
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: day.tiles,
      ),
    );
  }
}

class DayTabButton extends StatelessWidget {
  final Day day;
  final Color color;

  DayTabButton(this.day, {this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        weekdayStringShort(context, day.date.weekday).toUpperCase(),
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 24.0, color: color),
      ),
    );
  }
}

double _indexChangeProgress(TabController controller) {
  final double controllerValue = controller.animation.value;
  final double previousIndex = controller.previousIndex.toDouble();
  final double currentIndex = controller.index.toDouble();

  if (!controller.indexIsChanging)
    return (currentIndex - controllerValue).abs().clamp(0.0, 1.0);

  return (controllerValue - currentIndex).abs() /
      (currentIndex - previousIndex).abs();
}

class TimetableTabIndicator extends StatelessWidget {
  const TimetableTabIndicator({
    Key key,
    @required this.backgroundColor,
    @required this.borderColor,
    @required this.size,
    @required this.day,
    @required this.controller,
    @required this.index,
  })  : assert(backgroundColor != null),
        assert(borderColor != null),
        assert(size != null),
        super(key: key);

  final Color backgroundColor;
  final TabController controller;
  final Day day;
  final Color borderColor;
  final double size;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(4.0),
        child: MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
          padding: EdgeInsets.zero,
          onPressed: () {
            controller.animateTo(
              index,
              duration: Duration(milliseconds: 650),
            );
          },
          child: Center(
            child: DayTabButton(day, color: backgroundColor),
          ),
        ),
      ),
    );
  }
}

class TimetableTabBar extends StatelessWidget {
  const TimetableTabBar({
    Key key,
    this.controller,
    this.days,
    this.indicatorSize = 12.0,
    this.color,
    this.currentDayColor,
    this.selectedColor,
  })  : assert(indicatorSize != null && indicatorSize > 0.0),
        super(key: key);

  final TabController controller;
  final double indicatorSize;
  final List<Day> days;
  final Color color;
  final Color selectedColor;
  final Color currentDayColor;

  Widget _buildTabIndicator(
      int tabIndex,
      TabController tabController,
      ColorTween selectedColorTween,
      ColorTween previousColorTween,
      BuildContext context) {
    Color background;
    Color borderColor = selectedColorTween.end;

    if (tabController.indexIsChanging) {
      final double t = 1.0 - _indexChangeProgress(tabController);
      if (tabController.index == tabIndex)
        background = selectedColorTween.lerp(t);
      else if (tabController.previousIndex == tabIndex)
        background = previousColorTween.lerp(t);
      else
        background = selectedColorTween.begin;
    } else {
      final double offset = tabController.offset;
      if (tabController.index == tabIndex) {
        background = selectedColorTween.lerp(1.0 - offset.abs());
        borderColor = app.settings.appColor;
      } else if (tabController.index == tabIndex - 1 && offset > 0.0) {
        background = selectedColorTween.lerp(offset);
      } else if (tabController.index == tabIndex + 1 && offset < 0.0) {
        background = selectedColorTween.lerp(-offset);
      } else {
        background = selectedColorTween.begin;
      }
    }

    return TimetableTabIndicator(
      backgroundColor: background,
      borderColor: borderColor,
      size: indicatorSize,
      day: days[tabIndex],
      controller: controller,
      index: tabIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final TabController tabController = controller;
    final Animation<double> animation = CurvedAnimation(
      parent: tabController.animation,
      curve: Curves.fastOutSlowIn,
    );

    if (days.length < 1) return Container();

    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget child) {
        return Semantics(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List<Widget>.generate(days.length, (int tabIndex) {
              int dif = days[tabIndex].date.difference(DateTime.now()).inHours;

              final Color fixColor =
                  dif > -24 && dif < 0 ? currentDayColor : color;
              final Color fixSelectedColor =
                  selectedColor ?? app.settings.appColor;
              final ColorTween selectedColorTween =
                  ColorTween(begin: fixColor, end: fixSelectedColor);
              final ColorTween previousColorTween =
                  ColorTween(begin: fixSelectedColor, end: fixColor);

              return _buildTabIndicator(
                tabIndex,
                tabController,
                selectedColorTween,
                previousColorTween,
                context,
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
