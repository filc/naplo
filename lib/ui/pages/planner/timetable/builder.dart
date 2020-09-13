import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/lesson.dart';
import 'package:filcnaplo/ui/pages/planner/timetable/day.dart';
import 'package:filcnaplo/ui/pages/planner/timetable/tile.dart';
import 'package:filcnaplo/ui/pages/planner/timetable/week.dart';

class TimetableBuilder {
  Week week = Week([]);

  void build(i) {
    week = getWeek(i);
    List<Day> days = [];
    List<Lesson> lessons = app.user.sync.timetable.data;

    lessons.sort((a, b) => a.start.compareTo(b.start));

    lessons.forEach((lesson) {
      if (!days.any(
          (d) => d.lessons.any((l) => l.date.weekday == lesson.date.weekday))) {
        days.add(Day(date: lesson.date, lessons: [], tiles: []));
      }

      if (!days.last.lessons.map((l) => l.id).contains(lesson.id))
        days.last.lessons.add(lesson);
      if (lesson.subject != null) days.last.tiles.add(LessonTile(lesson));
    });

    days.sort((a, b) => a.date.compareTo(b.date));

    week.days = days;
  }

  Week getWeek(int weekOfYear) {
    // Returns the current week of the school year
    final now = DateTime.now();
    DateTime schoolStart;
    Week currentWeek = Week([]);

    if (DateTime(now.year, DateTime.september).isAfter(now))
      schoolStart = DateTime(now.year - 1, DateTime.september, 1);
    else
      schoolStart = DateTime(now.year, DateTime.september, 1);

    if (schoolStart.weekday == 6 || schoolStart.weekday == 7)
      schoolStart = schoolStart.add(Duration(days: -schoolStart.weekday + 8));

    currentWeek.start = schoolStart
        .add(Duration(days: 7 * weekOfYear - (schoolStart.weekday - 1)));
    if (currentWeek.start.isBefore(DateTime(now.year, DateTime.september, 1))) {
      currentWeek.start = DateTime(now.year, DateTime.september, 1);
    }

    currentWeek.end = schoolStart
        .add(Duration(days: 7 * weekOfYear + (6 - schoolStart.weekday)));
    if (DateTime(now.year, DateTime.september).isAfter(now)) {
      if (currentWeek.end.isAfter(DateTime(now.year, DateTime.august, 31))) {
        currentWeek.start = DateTime(now.year, 9, 1);
      }
    }

    return currentWeek;
  }

  int getCurrentWeek() {
    final now = DateTime.now();
    DateTime schoolStart;

    if (DateTime(now.year, DateTime.september).isAfter(now))
      schoolStart = DateTime(now.year - 1, DateTime.september, 1);
    else
      schoolStart = DateTime(now.year, DateTime.september, 1);

    if (schoolStart.weekday == 6 || schoolStart.weekday == 7)
      schoolStart = schoolStart.add(Duration(days: -schoolStart.weekday + 8));

    return ((now.difference(schoolStart).inDays - (now.weekday - 1)) / 7)
            .floor() +
        1;
  }
}
