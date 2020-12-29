import 'package:filcnaplo/data/controllers/search.dart';
import 'package:filcnaplo/data/models/searchable.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/account_button.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';

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
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Results
          CupertinoScrollbar(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(12.0, 100.0, 12.0, 0),
              itemCount: results.length,
              // results.length == 0 ? search history
              itemBuilder: (BuildContext context, int i) {
                Searchable item = results[i];
                return item.child;
              },
            ),
          ),

          // Search Bar
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
            padding: EdgeInsets.only(left: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(FeatherIcons.search),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
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
                        if (_searchController.text != "")
                          setState(() => _searchController.text = "");
                        else
                          Navigator.pop(context);
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

class SearchBar extends StatelessWidget {
  final Function openSearch;

  SearchBar({@required this.openSearch});

  @override
  Widget build(context) {
    return Container(
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
      padding: EdgeInsets.only(left: 12.0),
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
              onTap: openSearch,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 4.0),
            child: ClipOval(
              child: Material(
                color: Colors.transparent,
                child: AccountButton(padding: EdgeInsets.zero),
              ),
            ),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}
