import 'package:filcnaplo/ui/pages/planner/timetable/day.dart';

class Week {
  DateTime? start;
  DateTime? end;
  List<Day> days;

  Week(this.days, {this.start, this.end});
}
