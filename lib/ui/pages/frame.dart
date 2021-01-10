import 'package:filcnaplo/data/state/sync.dart';
import 'package:filcnaplo/ui/custom_snackbar.dart';
import 'package:filcnaplo/ui/pages/news/view.dart';
import 'package:filcnaplo/ui/sync/indicator.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/pages/absences/page.dart';
import 'package:filcnaplo/ui/pages/evaluations/page.dart';
import 'package:filcnaplo/ui/pages/home/page.dart';
import 'package:filcnaplo/ui/pages/messages/page.dart';
import 'package:filcnaplo/ui/pages/planner/page.dart';
import 'package:filcnaplo/ui/pages/tutorial.dart';
import 'package:filcnaplo/utils/network.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/ui/bottom_navbar.dart';

class PageFrame extends StatefulWidget {
  @override
  _PageFrameState createState() => _PageFrameState();
}

class _PageFrameState extends State<PageFrame> {
  GlobalKey<ScaffoldState> _homeKey = GlobalKey();

  @override
  void initState() {
    super.initState();

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
      app.user.kreta.userAgent = app.settings.config.data.userAgent;
      app.settings.config.sync().then((success) {
        app.user.kreta.userAgent = app.settings.config.data.userAgent;
        if (app.user.loginState) app.sync.fullSync();
      }).catchError((error) {
        print("ERROR: PageFrame.initState: Could not get config: $error");
        if (app.user.loginState) app.sync.fullSync();
      });
    });

    if (app.firstStart) {
      app.user.sync.news.sync();
      //Dont display news on first start.
    } else {
      app.user.sync.news.sync().then(
        (_) {
          if (app.settings.enableNews) {
            Future.delayed(
              Duration(seconds: 1),
              () {
                Future.forEach(
                  app.user.sync.news.fresh,
                  (news) async => await showDialog(
                    useSafeArea: true,
                    context: context,
                    builder: (context) => NewsView(news),
                  ),
                );
              },
            );
          }
        },
      );
    }
  }

  void _navItemSelected(int item) {
    if (item != app.selectedPage) {
      setState(() {
        app.selectedPage = item;
      });
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
            syncState =
                SyncState(text: tasks[task] ?? "", current: current, max: max);
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

    Widget pageContent;

    switch (app.selectedPage) {
      case 0:
        pageContent = HomePage(_navItemSelected);
        break;
      case 1:
        pageContent = EvaluationsPage(_homeKey);
        break;
      case 2:
        pageContent = PlannerPage();
        break;
      case 3:
        pageContent = MessagesPage(_homeKey);
        break;
      case 4:
        pageContent = AbsencesPage(_homeKey);
        break;
      default:
        pageContent = HomePage(_navItemSelected);
        break;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {});

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

    return Scaffold(
      key: _homeKey,
      body: Container(
        child: Stack(
          children: <Widget>[
            // Page content
            pageContent,

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
      bottomNavigationBar: BottomNavbar(this._navItemSelected),
    );
  }
}
