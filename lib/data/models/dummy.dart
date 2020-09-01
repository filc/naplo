import 'package:filcnaplo/data/models/school.dart';
import 'package:filcnaplo/data/models/student.dart';
import 'package:filcnaplo/data/models/evaluation.dart';
import 'package:filcnaplo/data/models/subject.dart';
import 'package:filcnaplo/data/models/message.dart';
import 'package:filcnaplo/data/models/note.dart';
import 'package:filcnaplo/data/models/recipient.dart';
import 'package:filcnaplo/data/models/type.dart';

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
      null,
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
      null,
      "",
      Subject("0", null, "Grammar"),
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
      null,
      "",
      Subject("0", null, "Math"),
      null,
      Type("0", "Test 3", "Test 3"),
      DateTime.now(),
      DateTime.now(),
      "Test 3",
    ),
  ];

  static List<Message> messages = [
    Message(
      23452345,
      34573245,
      true,
      false,
      DateTime.now(),
      "Test User",
      "This is a test messages.",
      "Test",
      [],
      [],
    ),
    Message(
      23452345,
      34573245,
      true,
      false,
      DateTime.now(),
      "Test User",
      "This is a test messages.",
      "Test",
      [],
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
      null,
    ),
  ];

  static List<Recipient> recipients = [
    Recipient(0, "", "Test User 1", 0, null),
    Recipient(1, "", "Test User 2", 0, null),
    Recipient(2, "", "Test User 3", 0, null),
  ];

  // k0sz boa
}
