import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/evaluation.dart';
import 'package:filcnaplo/ui/cards/absence/card.dart';
import 'package:filcnaplo/ui/cards/base.dart';
import 'package:filcnaplo/ui/cards/evaluation/card.dart';
import 'package:filcnaplo/ui/cards/evaluation/final_card.dart';
import 'package:filcnaplo/ui/cards/exam/card.dart';
import 'package:filcnaplo/ui/cards/homework/card.dart';
import 'package:filcnaplo/ui/cards/message/card.dart';
import 'package:filcnaplo/ui/cards/note/card.dart';
import 'package:flutter/material.dart';

class FeedBuilder {
  final Function callback;

  FeedBuilder({@required this.callback});

  List<Widget> elements = [];

  List<Widget> build() {
    elements = [];
    List<BaseCard> cards = [];

    app.user.sync.messages.inbox.forEach((message) => cards.add(MessageCard(
          message,
          callback,
          key: Key(message.messageId.toString()),
          compare: message.date,
        )));
    app.user.sync.note.notes.forEach((note) => cards.add(NoteCard(
          note,
          key: Key(note.id),
          compare: note.date,
        )));

    List<List<Evaluation>> finalEvals = [[], [], [], [], [], [], [], []];
    app.user.sync.evaluation.evaluations.forEach((evaluation) {
      if (evaluation.type == EvaluationType.midYear) {
        cards.add(EvaluationCard(
          evaluation,
          key: Key(evaluation.id),
          compare: evaluation.date,
        ));
      } else {
        finalEvals[evaluation.type.index - 1].add(evaluation);
      }
    });
    finalEvals.where((element) => element.isNotEmpty).forEach((list) {
      cards.add(FinalCard(
        list,
        key: Key(list.first.id),
        compare: list.first.date,
      ));
    });

    app.user.sync.absence.absences.forEach((absence) => cards.add(AbsenceCard(
          absence,
          key: Key(absence.id.toString()),
          compare: absence.submitDate,
        )));
    app.user.sync.homework.homework
        .where((homework) => homework.deadline.isAfter(DateTime.now()))
        .forEach((homework) => cards.add(HomeworkCard(
              homework,
              key: Key(homework.id.toString()),
              compare: homework.date,
            )));
    app.user.sync.exam.exams
        .where((exam) => exam.writeDate.isAfter(DateTime.now()))
        .forEach((exam) => cards.add(ExamCard(
              exam,
              key: Key(exam.id.toString()),
              compare: exam.date,
            )));

    cards.sort((a, b) => -a.compare.compareTo(b.compare));

    elements.addAll(cards.where((card) =>
        card.compare.isAfter(DateTime.now().subtract(Duration(days: 300)))));

    return elements;
  }
}
