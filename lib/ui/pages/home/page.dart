import 'package:filcnaplo/ui/pages/home/builder.dart';
import 'package:filcnaplo/ui/pages/search/bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/ui/pages/search/page.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _refreshHome = GlobalKey<RefreshIndicatorState>();

  late FeedBuilder _feedBuilder;

  @override
  void initState() {
    super.initState();
    _feedBuilder = FeedBuilder(callback: () => setState(() {}));
    _feedBuilder.build();
  }

  @override
  Widget build(BuildContext context) {
    if (homePending()) _feedBuilder.build();

    return Scaffold(
      body: Stack(
        children: [
          // Cards
          Container(
            child: RefreshIndicator(
              key: _refreshHome,
              displacement: 100.0,
              onRefresh: () async {
                await app.sync.fullSync();
              },
              child: CupertinoScrollbar(
                child: AnimationLimiter(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    padding: EdgeInsets.only(top: 100.0),
                    itemCount: _feedBuilder.elements.length,
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: Duration(milliseconds: 500),
                        child: SlideAnimation(
                          verticalOffset: 150,
                          child: FadeInAnimation(
                            child: _feedBuilder.elements[index],
                          ),
                        ),
                      );
                    },
                  ),
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

  bool homePending() {
    if (app.user.sync.absence.uiPending ||
        app.user.sync.note.uiPending ||
        app.user.sync.messages.uiPending ||
        app.user.sync.evaluation.uiPending ||
        app.user.sync.event.uiPending ||
        app.user.sync.exam.uiPending ||
        app.user.sync.homework.uiPending) {
      app.user.sync.absence.uiPending = false;
      app.user.sync.note.uiPending = false;
      app.user.sync.messages.uiPending = false;
      app.user.sync.evaluation.uiPending = false;
      app.user.sync.event.uiPending = false;
      app.user.sync.exam.uiPending = false;
      app.user.sync.homework.uiPending = false;

      return true;
    } else
      return false;
  }
}
