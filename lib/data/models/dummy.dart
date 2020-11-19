import 'package:filcnaplo/data/models/event.dart';
import 'package:filcnaplo/data/models/homework.dart';
import 'package:filcnaplo/data/models/school.dart';
import 'package:filcnaplo/data/models/student.dart';
import 'package:filcnaplo/data/models/evaluation.dart';
import 'package:filcnaplo/data/models/subject.dart';
import 'package:filcnaplo/data/models/message.dart';
import 'package:filcnaplo/data/models/note.dart';
import 'package:filcnaplo/data/models/recipient.dart';
import 'package:filcnaplo/data/models/type.dart';
import 'package:filcnaplo/ui/pages/planner/timetable/day.dart';
import 'package:filcnaplo/ui/pages/planner/timetable/week.dart';

import 'exam.dart';
import 'lesson.dart';

class Dummy {
  static Student student = Student(
    "123",
    "Test User", // Student name
    School("0", "Test School", "Test"),
    DateTime.now(),
    "0",
    "Test Street 123",
    ["Test Parent"],
  );

  static List<Evaluation> evaluations = [
    Evaluation(
      "234512345",
      DateTime.now(),
      EvaluationValue(1, "One", "One", 200),
      "Test Teacher",
      "Test",
      Type("", "", "evkozi_jegy_ertekeles"),
      "",
      Subject("0", null, "English"),
      null,
      Type("0", "Test", "Test"),
      DateTime.now(),
      DateTime.now(),
      "Test",
    ),
    Evaluation(
      "100101110010",
      DateTime.now(),
      EvaluationValue(5, "Ötös", "Ötös", 100),
      "Teszttanár",
      "EzAzEnJegyem",
      Type("", "", "III_ne_jegy_ertekeles"),
      "",
      Subject("0", null, "English"),
      null,
      Type("0", "Test", "Test"),
      DateTime.now(),
      DateTime.now(),
      "Test",
    ),
    Evaluation(
      "123462",
      DateTime.now(),
      EvaluationValue(4, "Four", "Four", 100),
      "Test Teacher",
      "Test 2",
      Type("", "", "evkozi_jegy_ertekeles"),
      "",
      Subject("0", null, "English"),
      null,
      Type("0", "Test", "Test"),
      DateTime.now(),
      DateTime.now(),
      "Test",
    ),
    Evaluation(
      "234512346",
      DateTime.now(),
      EvaluationValue(2, "Two", "Two", 100),
      "Test Teacher 2",
      "Test 2",
      Type("", "", "evkozi_jegy_ertekeles"),
      "",
      Subject("1", null, "Grammar"),
      null,
      Type("0", "Test 2", "Test 2"),
      DateTime.now(),
      DateTime.now(),
      "exam 2",
    ),
    Evaluation(
      "2345123134",
      DateTime.now(),
      EvaluationValue(5, "Five", "Five", 50),
      "Test Teacher 3",
      "Test 3",
      Type("", "", "evkozi_jegy_ertekeles"),
      "",
      Subject("2", null, "Math"),
      null,
      Type("0", "Test 3", "Test 3"),
      DateTime.now(),
      DateTime.now(),
      "Test 3",
    ),
  ];

  static List<Message> messages = [
    Message(
      123,
      1234,
      true,
      false,
      DateTime.now(),
      "Test User",
      "This is a test.",
      "Test",
      [Recipient(0, '0', "Test Teacher", 0, null)],
      [],
    ),
    Message(
      132,
      12345,
      true,
      false,
      DateTime.now(),
      "Test User",
      "This is another test message.",
      "Test 2",
      [
        Recipient(0, '0', "Test Teacher", 0, null),
        Recipient(1, '1', "Albert", 1, null)
      ],
      [],
    ),
  ];

  static List<Note> notes = [
    Note(
      "0",
      "Test Note",
      DateTime.now(),
      DateTime.now(),
      "Test User",
      DateTime.now(),
      null,
      "This is a test note.",
      Type("", "", "ElektronikusUzenet"),
    ),
  ];

  static List<Event> events = [
    Event(
      "2378123",
      DateTime.now(),
      DateTime.now(),
      "Test Event",
      "This is a test event.",
    ),
  ];

  static List<Recipient> recipients = [
    Recipient(0, "", "Test User 1", 0, null),
    Recipient(1, "", "Test User 2", 0, null),
    Recipient(2, "", "Test User 3", 0, null),
  ];

  static List<Lesson> lessons = [
    Lesson(
      Type("122455", "", ""),
      DateTime.now(),
      Subject("1231651", null, "Szolfézs"),
      "3",
      12,
      "Jozsa Neni legjobb spanja",
      "Jozsa Neni",
      true,
      DateTime.now(),
      DateTime.now().add(Duration(minutes: 45)),
      Type("51654537", "", ""),
      null,
      <Exam>[],
      "6153131",
      Type("51561", "", ""),
      "Le van irva",
      "Kisterem",
      "9. C",
      "Matekmatika - mi ez mi?",
    ),
  ];

  static Week week = Week([
    Day(
      date: DateTime.now(),
    )
  ]);

  static List<Homework> homework = [
    Homework(
        DateTime.now(),
        DateTime.now(),
        DateTime.now().add(Duration(days: 1)),
        true,
        false,
        "Lajosne Fekete Andras",
        "Pihend ki az iskolai faradalmakat",
        "Kvantumfizika",
        "",
        [],
        "24672456"),
    Homework(
        DateTime.now().subtract(Duration(days: 1)),
        DateTime.now().subtract(Duration(days: 1)),
        DateTime.now().subtract(Duration(days: 1)),
        true,
        false,
        "Fekete Geza",
        "Vagj ki egy fat otthon, lakhelyedhez kozeli erdoben, a videot kuldd el TIMSZEN",
        "Faipari ismeretek",
        "",
        [],
        "24672456"),
  ];

  // k0sz boa
}
