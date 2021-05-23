import 'package:filcnaplo/data/context/page.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:filcnaplo/data/context/app.dart';

class BottomNavbar extends StatelessWidget {
  final Function(int)? onTap;
  final PageType selectedPage;

  BottomNavbar({this.onTap, required this.selectedPage});

  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        // Home Page
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.all(14.0),
            child: Icon(
              FeatherIcons.search,
            ),
          ),
          label: I18n.of(context).homepage,
        ),

        // Evaluations Page
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.all(14.0),
            child: Icon(
              FeatherIcons.bookmark,
            ),
          ),
          label: I18n.of(context).evaluationTitle,
        ),

        // Timetable Page
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.all(14.0),
            child: Icon(
              FeatherIcons.calendar,
            ),
          ),
          label: I18n.of(context).plannerTitle,
        ),
        // Messages Page
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.all(14.0),
            child: Icon(
              FeatherIcons.messageSquare,
            ),
          ),
          label: I18n.of(context).messageTitle,
        ),
        // Absences Page
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.all(14.0),
            child: Icon(
              FeatherIcons.clock,
            ),
          ),
          label: I18n.of(context).absenceTitle,
        ),
      ],
      currentIndex: selectedPage.index,
      selectedFontSize: 0,
      unselectedFontSize: 0,
      selectedIconTheme: IconThemeData(color: app.settings.appColor),
      unselectedIconTheme:
          IconThemeData(color: app.settings.theme.textTheme.bodyText1!.color),
      type: BottomNavigationBarType.fixed,
      onTap: this.onTap,
    );
  }
}
