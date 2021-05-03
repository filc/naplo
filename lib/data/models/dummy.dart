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
      EvaluationType.midYear,
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
      EvaluationType.midYear,
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
      EvaluationValue(1, "One", "One", 100),
      "Test Teacher 2",
      "Test 2",
      EvaluationType.midYear,
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
      EvaluationType.midYear,
      "",
      Subject("2", null, "Math"),
      null,
      Type("0", "Test 3", "Test 3"),
      DateTime.now(),
      DateTime.now(),
      "Test 3",
    ),
    Evaluation(
      "2345123134",
      DateTime.now(),
      EvaluationValue(5, "Five", "Five", 50),
      "Test Teacher 3",
      "Test 3",
      EvaluationType.midYear,
      "",
      Subject(
          "123", null, "Matematika kompetencianövelő masterclass okosoknak"),
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
      MessageType.inbox,
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
      MessageType.inbox,
      [
        Recipient(0, '0', "Test Teacher", 0, null),
        Recipient(1, '1', "Albert", 1, null)
      ],
      [],
    ),
    Message(
      133,
      12346,
      true,
      false,
      DateTime.now(),
      "Bad hacker",
      "This is a bugged message",
      "Error alert!",
      MessageType.inbox,
      null,
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

  static List<Exam> exams = [
    Exam(
        DateTime.now(),
        DateTime.now().add(Duration(minutes: 120)),
        Type("123", "Gyakorlati feladat", "Gyakorlati feladat"),
        6,
        "Alváselmélet",
        "Marika nénje",
        "Javítási lehetőség",
        null,
        "555"),
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
    Lesson(
      Type("122455", "", ""),
      DateTime.now(),
      Subject("420", null, "Kémia"),
      "5",
      12,
      "",
      "Irma né",
      true,
      DateTime.now().add(Duration(minutes: 2 * 45)),
      DateTime.now().add(Duration(minutes: 3 * 45)),
      Type("51654537", "student presence type desc",
          "student presence type name"),
      null,
      <Exam>[],
      "6153132",
      Type("51561", "lesson type desc", "lesson type name"),
      "Le van irva",
      "Khémia",
      "9. C",
      "Matekmatika - mi ez mi?",
    ),
    Lesson(
      Type("122455", "", ""),
      DateTime.now(),
      Subject("1234", null, "Alváselmélet"),
      "0",
      12,
      "",
      "Marika Nénje",
      true,
      DateTime.now().add(Duration(minutes: 2 * 45)),
      DateTime.now().add(Duration(minutes: 3 * 45)),
      Type("51654537", "student presence type desc",
          "student presence type name"),
      "333",
      [
        "555",
      ],
      "6153133",
      Type("51561", "lesson type desc", "lesson type name"),
      "Bevezetés a tudatos álmodásba",
      "Hálószóbád",
      "9. C",
      "Név.",
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
        DateTime.now(),
        DateTime.now(),
        DateTime.now().add(Duration(days: 1)),
        true,
        false,
        "Marika Nénje",
        "Fordítsd meg a párnádat a hideg oldalára.",
        "Alváselmélet",
        "",
        [],
        "333"),
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
