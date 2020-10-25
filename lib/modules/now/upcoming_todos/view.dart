import 'package:filcnaplo/modules/now/upcoming_todos/tile.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'builder.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/ui/card.dart';

class ToDoList extends StatefulWidget {
  final String title;
  final List<ToDoTile> tiles;
  final IconData icon;
  final Function titleOnTap;
  static const int MAX_ELEMENTS = 3;
  ToDoList(this.icon, this.title, this.titleOnTap, this.tiles);
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  bool showAll = false;
  @override
  Widget build(BuildContext context) {
    bool tooMuchElements = widget.tiles.length > ToDoList.MAX_ELEMENTS;
    List<ToDoTile> tilesToShow = !showAll && tooMuchElements
        ? widget.tiles.sublist(0, ToDoList.MAX_ELEMENTS)
        : widget.tiles;
    int omittedElementCount =
        tooMuchElements ? widget.tiles.length - ToDoList.MAX_ELEMENTS : 0;
    return Padding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
                child: Row(children: [
                  Padding(
                      child: Icon(
                        widget.icon,
                        size: 25,
                        color: Theme.of(context).accentColor,
                      ),
                      padding: EdgeInsets.only(right: 10)),
                  Text(widget.title,
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold))
                ]),
                onTap: widget.titleOnTap),
            Column(
              children: [
                ListView(
                  shrinkWrap: true,
                  children: tilesToShow,
                  padding: EdgeInsets.all(3),
                  primary: false,
                ),
                tooMuchElements ? Padding(
                        child: GestureDetector(
                          child: Text(
                              showAll ? I18n.of(context)
                                  .collapseList : I18n.of(context)
                                  .showOthers(omittedElementCount.toString()),
                              style: TextStyle(
                                  color: Theme.of(context).accentColor)),
                          onTap: () {
                            setState(() {
                              showAll = !showAll;
                            });
                          },
                        ),
                        padding: EdgeInsets.only(left: 3)) : Container()
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ],
        ),
        padding: EdgeInsets.only(top: 8, left: 8));
  }
}

class UpcomingToDoList extends BaseCard {
  final ToDoBuilder builder = ToDoBuilder();
  final Function jumpToPage;
  UpcomingToDoList(this.jumpToPage);
  @override
  Widget build(BuildContext context) {
    builder.build();
    bool noExams = builder.examTiles.length == 0,
        noHomeworks = builder.homeworkTiles.length == 0;
    if (noExams && noHomeworks) return Container();
    return BaseCard(
        child: Column(children: [
      !noExams
          ? ToDoList(
              FeatherIcons.calendar,
              I18n.of(context).examUpcoming,
              () {
                app.tabState.timetable.index = 2;
                jumpToPage(2);
              },
              builder.examTiles,
            )
          : Container(),
      !noHomeworks
          ? ToDoList(
              FeatherIcons.home,
              I18n.of(context).homeworkUpcoming,
              () {
                app.tabState.timetable.index = 1;
                jumpToPage(2);
              },
              builder.homeworkTiles,
            )
          : Container()
    ]));
  }
}
