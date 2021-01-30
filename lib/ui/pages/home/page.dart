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

  FeedBuilder _feedBuilder;

  List<Key> dataKeyes = [];

  @override
  void initState() {
    super.initState();
    _feedBuilder = FeedBuilder(callback: () => setState(() {}));
    _feedBuilder.build();
    saveKeyes();
  }

  @override
  Widget build(BuildContext context) {
    if (newData()) {
      _feedBuilder.build();
      saveKeyes();
    }

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

  void saveKeyes() {
    dataKeyes = [];
    dataKeyes.addAll([
      app.user.sync.evaluation.key,
      app.user.sync.timetable.key,
      app.user.sync.homework.key,
      app.user.sync.exam.key,
      app.user.sync.note.key,
      app.user.sync.event.key,
      app.user.sync.absence.key
    ]);
  }

  bool newData() {
    return !(app.user.sync.evaluation.match(dataKeyes[0]) &&
        app.user.sync.timetable.match(dataKeyes[1]) &&
        app.user.sync.homework.match(dataKeyes[2]) &&
        app.user.sync.exam.match(dataKeyes[3]) &&
        app.user.sync.note.match(dataKeyes[4]) &&
        app.user.sync.event.match(dataKeyes[5]) &&
        app.user.sync.absence.match(dataKeyes[6]));
  }
}
