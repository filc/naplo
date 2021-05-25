import 'package:filcnaplo/data/models/evaluation.dart';
import 'package:filcnaplo/data/models/message.dart';

enum PageType { home, evaluations, planner, messages, absences }

class PageContext {
  const PageContext({this.messageType, this.evaluationType});

  final MessageType? messageType;
  final EvaluationType? evaluationType;
}
