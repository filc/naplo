import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/ui/common/account_button.dart';
import 'package:filcnaplo/ui/pages/home/builder.dart';
import 'package:filcnaplo/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final _refreshHome = GlobalKey<RefreshIndicatorState>();

  FeedBuilder _feedBuilder;

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
      body: SafeArea(
        child: NestedScrollView(
          physics: BouncingScrollPhysics(),
          headerSliverBuilder: (context, _) {
            return [
              SliverAppBar(
                backgroundColor: app.settings.theme.scaffoldBackgroundColor,
                actions: [
                  IconButton(
                    icon: Icon(FeatherIcons.search),
                    onPressed: () {},
                  ),
                  AccountButton(),
                ],
                floating: false,
                pinned: true,
                expandedHeight: 230,
                shadowColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: [0, 0.1, 0.1, 1],
                        colors: [
                          app.settings.theme.scaffoldBackgroundColor,
                          app.settings.theme.scaffoldBackgroundColor,
                          textColor(app.settings.theme.scaffoldBackgroundColor)
                              .withOpacity(.02),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Swiper(
                      loop: false,
                      physics: BouncingScrollPhysics(),
                      pagination: SwiperPagination(
                        alignment: Alignment.bottomCenter,
                        margin: EdgeInsets.only(top: 12.0),
                        builder: DotSwiperPaginationBuilder(
                          activeColor: app.settings.appColor,
                          color: textColor(
                                  app.settings.theme.scaffoldBackgroundColor)
                              .withOpacity(.2),
                          space: 5.0,
                          size: 8.0,
                          activeSize: 8.0,
                        ),
                      ),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(top: 48.0, bottom: 24.0),
                          padding: EdgeInsets.all(24.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Center(
                              child: Text(
                                "Good night!",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              )
            ];
          },
          body: Container(
            child: Text("Stuff"),
          ),
        ),
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
    } else {
      return false;
    }
  }
}
