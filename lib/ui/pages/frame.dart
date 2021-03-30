import 'package:filcnaplo/data/context/page.dart';
import 'package:filcnaplo/data/models/new.dart';
import 'package:filcnaplo/data/sync/state.dart';
import 'package:filcnaplo/ui/common/custom_snackbar.dart';
import 'package:filcnaplo/ui/pages/news/view.dart';
import 'package:filcnaplo/ui/sync/indicator.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/pages/absences/page.dart';
import 'package:filcnaplo/ui/pages/evaluations/page.dart';
import 'package:filcnaplo/ui/pages/home/page.dart';
import 'package:filcnaplo/ui/pages/messages/page.dart';
import 'package:filcnaplo/ui/pages/planner/page.dart';
import 'package:filcnaplo/ui/pages/welcome/tutorial.dart';
import 'package:filcnaplo/utils/network.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/ui/common/bottom_navbar.dart';

class PageFrame extends StatefulWidget {
  @override
  _PageFrameState createState() => _PageFrameState();
}

class _PageFrameState extends State<PageFrame> {
  PageType selectedPage;

  @override
  void initState() {
    super.initState();

    selectedPage = PageType.values[app.settings.defaultPage];

    NetworkUtils.checkConnectivity().then((networkAvailable) {
      if (!networkAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
          message: I18n.of(context).errorInternet,
          color: Colors.red,
        ));
      }
    });

    // Sync at startup
    app.settings.update().then((_) {
      app.user.kreta.userAgent = app.settings.config.config.userAgent;
      app.settings.config.sync().then((success) {
        app.user.kreta.userAgent = app.settings.config.config.userAgent;
        if (app.user.loginState) app.sync.fullSync();
      }).catchError((error) {
        print("ERROR: PageFrame.initState: Could not get config: $error");
        if (app.user.loginState) app.sync.fullSync();
      });
    });

    app.user.sync.news.sync().then((_) {
      if (app.user.sync.news.prevLength != 0 && app.settings.enableNews) {
        Future.delayed(Duration(seconds: 1), () {
          Future.forEach(app.user.sync.news.fresh, (News news) async {
            if (news.title != null)
              await showDialog(
                context: context,
                builder: (context) => NewsView(news),
              );
          });
        });
      }
    });
  }

  void _navItemSelected(int item) {
    if (item != selectedPage.index) {
      app.gotoPage(PageType.values[item]);
    }
  }

  _pageRoute(Function(BuildContext) builder) {
    return PageRouteBuilder(
      pageBuilder: (context, _, __) => builder(context),
      transitionDuration: Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween(begin: 0.0, end: 1.0);
        var offsetAnimation = animation.drive(tween);

        return FadeTransition(
          opacity: offsetAnimation,
          child: child,
        );
      },
    );
  }

  Route handleRoute(RouteSettings settings) {
    switch (settings.name) {
      case "home":
        selectedPage = PageType.home;
        return _pageRoute((_) => HomePage());
      case "evaluations":
        selectedPage = PageType.evaluations;
        return _pageRoute((_) => EvaluationsPage());
      case "planner":
        selectedPage = PageType.planner;
        return _pageRoute((_) => PlannerPage());
      case "messages":
        selectedPage = PageType.messages;
        return _pageRoute((_) => MessagesPage());
      case "absences":
        selectedPage = PageType.absences;
        return _pageRoute((_) => AbsencesPage());
      default:
        selectedPage = PageType.values[app.settings.defaultPage];
        return _pageRoute((_) => [
              HomePage(),
              EvaluationsPage(),
              PlannerPage(),
              MessagesPage(),
              AbsencesPage(),
            ][selectedPage.index]);
    }
  }

  SyncState syncState = SyncState();
  bool showSyncProgress = false;
  bool animateSyncProgress = false;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      app.sync.updateCallback = ({String task, int current, int max}) {
        Map tasks = {
          "message": I18n.of(context).syncMessage,
          "student": I18n.of(context).syncStudent,
          "event": I18n.of(context).syncEvent,
          "note": I18n.of(context).syncNote,
          "evaluation": I18n.of(context).syncEvaluation,
          "absence": I18n.of(context).syncAbsence,
          "timetable": I18n.of(context).syncTimetable,
          "homework": I18n.of(context).syncHomework,
          "exam": I18n.of(context).syncExam,
        };

        setState(() {
          if (task != null) {
            syncState = SyncState(
              text: tasks[task] ?? "",
              current: current,
              max: max,
            );
          }
        });
      };

      if (app.firstStart) {
        app.firstStart = false;
        showDialog(
          barrierDismissible: false,
          useSafeArea: false,
          context: context,
          builder: (context) => Material(
            type: MaterialType.transparency,
            child: Container(
              child: TutorialView(callback: _navItemSelected),
              padding: EdgeInsets.only(top: 24.0),
              color: Colors.black45,
            ),
          ),
        );
      }
    });

    if (syncState.current != null && app.sync.tasks.length > 0) {
      showSyncProgress = true;
      animateSyncProgress = true;
    } else {
      animateSyncProgress = false;
      Future.delayed(
        Duration(milliseconds: 200),
        () => setState(() => showSyncProgress = false),
      );
    }

    // Tween<double> offlineAnimation = Tween<double>(begin: 100.0, end: 0.0);
    // Tween<double> offlineAnimation = Tween<double>(begin: 0.0, end: 100.0);
    Tween<double> offlineAnimation = Tween<double>(begin: 0.0, end: 0.0);

    return WillPopScope(
      onWillPop: () async {
        if (app.frame.currentState.canPop()) app.frame.currentState.pop();
        return false;
      },
      child: Scaffold(
        body: Container(
          child: Stack(
            children: [
              // Page content
              TweenAnimationBuilder(
                tween: offlineAnimation,
                curve: Curves.ease,
                duration: Duration(milliseconds: 500),
                builder: (context, value, _) => Padding(
                  padding: EdgeInsets.only(top: value / (100 / 42)),
                  child:
                      Navigator(key: app.frame, onGenerateRoute: handleRoute),
                ),
              ),

              TweenAnimationBuilder(
                tween: offlineAnimation,
                duration: Duration(milliseconds: 500),
                curve: Curves.ease,
                builder: (context, value, _) => Opacity(
                  opacity: value / 100,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.red,
                    padding: EdgeInsets.only(
                      left: 12.0,
                      right: 12.0,
                      bottom: 12.0,
                      top: value / (100 / 38.0),
                    ),
                    child: Text(
                      "A kréta jelenleg karbantartás alatt van.",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),

              // Sync Progress Indicator
              showSyncProgress
                  ? AnimatedOpacity(
                      opacity: animateSyncProgress ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 100),
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: SyncProgressIndicator(
                          text: syncState.text,
                          current: syncState.current.toString(),
                          max: syncState.max.toString(),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        bottomNavigationBar:
            BottomNavbar(this._navItemSelected, selectedPage: selectedPage),
      ),
    );
  }
}
