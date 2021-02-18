import 'package:filcnaplo/data/context/page.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class BottomNavbar extends StatelessWidget {
  final Function onTap;
  final PageType selectedPage;

  BottomNavbar(this.onTap, {@required this.selectedPage});

  Widget build(BuildContext context) {
    return Material(
      color: app.settings.theme.bottomNavigationBarTheme.backgroundColor,
      child: SalomonBottomBar(
        items: <SalomonBottomBarItem>[
          // Home Page
          SalomonBottomBarItem(
            icon: Icon(
              FeatherIcons.search,
            ),
            title: Text(I18n.of(context).drawerHome),
          ),

          // Evaluations Page
          SalomonBottomBarItem(
            icon: Icon(
              FeatherIcons.bookmark,
            ),
            title: Text(I18n.of(context).evaluationTitle),
          ),

          // Timetable Page
          SalomonBottomBarItem(
            icon: Icon(
              FeatherIcons.calendar,
            ),
            title: Text(I18n.of(context).plannerTitle),
          ),
          // Messages Page
          SalomonBottomBarItem(
            icon: Icon(
              FeatherIcons.messageSquare,
            ),
            title: Text(I18n.of(context).messageTitle),
          ),
          // Absences Page
          SalomonBottomBarItem(
            icon: Icon(
              FeatherIcons.clock,
            ),
            title: Text(I18n.of(context).absenceTitle),
          ),
        ],
        currentIndex: selectedPage.index,
        onTap: this.onTap,
        selectedItemColor: app.settings.appColor,
      ),
    );
  }
}
