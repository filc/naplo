import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/modules/now/now.dart';
import 'package:filcnaplo/ui/card.dart';
import 'package:filcnaplo/ui/cards/absence/card.dart';
import 'package:filcnaplo/ui/cards/evaluation/card.dart';
import 'package:filcnaplo/ui/cards/message/card.dart';
import 'package:filcnaplo/ui/cards/note/card.dart';
import 'package:filcnaplo/ui/cards/homework/card.dart';
import 'package:filcnaplo/ui/cards/exam/card.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/ui/pages/accounts/page.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/ui/pages/search.dart';

class HomePage extends StatefulWidget {
  final Function jumpToPage;
  final _scaffoldKey;
  HomePage(this.jumpToPage, this._scaffoldKey);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _refreshHome = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
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
                child: ListView(
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  padding: EdgeInsets.only(top: 100.0),
                  children: buildFeed(),
                ),
              ),
            ),
          ),

          // Search bar
          Container(
            margin: EdgeInsets.fromLTRB(18.0, 40.0, 18.0, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: app.settings.theme.backgroundColor,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 2.0),
                  blurRadius: 4.0,
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                )
              ],
            ),
            padding: EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(FeatherIcons.search),
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(11.5),
                      child: Text(
                        capital(I18n.of(context).search),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(_searchRoute());
                    },
                  ),
                ),
                GestureDetector(
                  child: app.user.profileIcon,
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AccountPage()));
                  },
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildFeed() {
    List<Widget> elements = [];
    List<BaseCard> cards = [];

    app.user.sync.messages.data[0].forEach((message) => cards.add(MessageCard(
          message,
          widget._scaffoldKey,
          updateCallback,
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

    if (true /*if now module is turned on in settings*/) {
      elements.add(Now(widget.jumpToPage));
    }

    elements.addAll(cards);

    return elements;
  }

  Route _searchRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SearchPage(widget._scaffoldKey, updateCallback),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
   void updateCallback() {
    setState(() {});
  }
}
