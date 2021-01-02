import 'package:filcnaplo/ui/cards/card.dart';
import 'package:filcnaplo/ui/cards/absence/card.dart';
import 'package:filcnaplo/ui/cards/evaluation/card.dart';
import 'package:filcnaplo/ui/cards/message/card.dart';
import 'package:filcnaplo/ui/cards/note/card.dart';
import 'package:filcnaplo/ui/cards/homework/card.dart';
import 'package:filcnaplo/ui/cards/exam/card.dart';
import 'package:filcnaplo/ui/pages/search/bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/ui/pages/search/page.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomePage extends StatefulWidget {
  final Function jumpToPage;
  HomePage(this.jumpToPage);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _refreshHome = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    List<Widget> feedCards = buildFeed();

    return Container(
      child: Stack(
        children: <Widget>[
          // Cards
          Container(
            child: RefreshIndicator(
              key: _refreshHome,
              displacement: 100.0,
              onRefresh: () async {
                await app.sync.fullSync();
              },
              child: CupertinoScrollbar(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  padding: EdgeInsets.only(top: 100.0),
                  itemCount: feedCards.length,
                  itemBuilder: (context, index) {
                    if (index < 9) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: Duration(milliseconds: 500),
                        child: SlideAnimation(
                          verticalOffset: 150,
                          child: FadeInAnimation(
                            child: feedCards[index],
                          ),
                        ),
                      );
                    } else {
                      return feedCards[index];
                    }
                  },
                ),
              ),
            ),
          ),

          // Search bar
          SearchBar(
            openSearch: () => showDialog(
              context: context,
              builder: (context) => SearchPage(() => setState(() {})),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> buildFeed() {
    List<Widget> elements = [];
    List<BaseCard> cards = [];

    app.user.sync.messages.received.forEach((message) => cards.add(MessageCard(
          message,
          () => setState(() {}),
          key: Key(message.messageId.toString()),
          compare: message.date,
        )));
    app.user.sync.note.data.forEach((note) => cards.add(NoteCard(
          note,
          key: Key(note.id),
          compare: note.date,
        )));
    app.user.sync.evaluation.data[0]
        .forEach((evaluation) => cards.add(EvaluationCard(
              evaluation,
              key: Key(evaluation.id),
              compare: evaluation.date,
            )));
    app.user.sync.absence.data.forEach((absence) => cards.add(AbsenceCard(
          absence,
          key: Key(absence.id.toString()),
          compare: absence.submitDate,
        )));
    app.user.sync.homework.data.forEach((homework) => cards.add(HomeworkCard(
          homework,
          key: Key(homework.id.toString()),
          compare: homework.date,
        )));
    app.user.sync.exam.data.forEach((exam) => cards.add(ExamCard(
          exam,
          key: Key(exam.id.toString()),
          compare: exam.date,
        )));

    cards.sort((a, b) => -a.compare.compareTo(b.compare));

    elements.addAll(cards);
    
    return elements;
  }
}
