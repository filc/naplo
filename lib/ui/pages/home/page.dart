import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/card.dart';
import 'package:filcnaplo/ui/cards/evaluation/card.dart';
import 'package:filcnaplo/ui/cards/message/card.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/ui/pages/accounts/page.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/ui/pages/search.dart';

class HomePage extends StatefulWidget {
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
    List<BaseCard> cards = [];

    app.user.sync.messages.data[0].forEach((message) => cards.add(MessageCard(
          message,
          key: Key(message.messageId.toString()),
          compare: message.date,
        )));
    app.user.sync.evaluation.data[0]
        .forEach((evaluation) => cards.add(EvaluationCard(
              evaluation,
              key: Key(evaluation.id),
              compare: evaluation.date,
            )));

    cards.sort((a, b) => -a.compare.compareTo(b.compare));

    return cards;
  }

  Route _searchRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SearchPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
