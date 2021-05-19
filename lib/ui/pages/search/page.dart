import 'package:filcnaplo/data/controllers/search.dart';
import 'package:filcnaplo/data/models/searchable.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class SearchPage extends StatefulWidget {
  final callback;
  SearchPage(this.callback);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Searchable> results = [];
  TextEditingController _searchController = TextEditingController();

  _SearchPageState();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black38,
      child: Stack(
        children: [
          // Results
          Container(
            margin: EdgeInsets.only(
                left: 18.0, right: 18.0, top: 74.0, bottom: 18.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: results.length > 0
                  ? app.settings.theme.scaffoldBackgroundColor
                  : Colors.transparent,
            ),
            child: CupertinoScrollbar(
              child: AnimationLimiter(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 12.0),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: Duration(milliseconds: 500),
                      child: SlideAnimation(
                        verticalOffset: 150,
                        child: FadeInAnimation(child: results[index].child),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Search Bar
          Container(
            margin: EdgeInsets.fromLTRB(18.0, 16.0, 18.0, 0),
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
            padding: EdgeInsets.only(left: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(FeatherIcons.search, color: app.settings.appColor),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      cursorColor: app.settings.appColor,
                      controller: _searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      onChanged: (String text) {
                        setState(() {
                          if (text != "") {
                            results = SearchController.searchableResults(
                              app.search
                                  .getSearchables(context, widget.callback),
                              text,
                            );
                          } else {
                            results = [];
                          }
                        });
                      },
                    ),
                  ),
                ),

                // Close / Clear search
                ClipOval(
                  child: Material(
                    color: Colors.transparent,
                    child: IconButton(
                      icon: Icon(FeatherIcons.x),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        if (_searchController.text != "") {
                          setState(() {
                            _searchController.text = "";
                            results = [];
                          });
                        } else {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          ),
        ],
      ),
    );
  }
}
