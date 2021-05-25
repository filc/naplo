import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/pages/news/builder.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewsHistoryView extends StatefulWidget {
  NewsHistoryView();

  @override
  _NewsHistoryViewState createState() => _NewsHistoryViewState();
}

class _NewsHistoryViewState extends State<NewsHistoryView> {
  late NewsBuilder newsBuilder;

  _NewsHistoryViewState() {
    this.newsBuilder = NewsBuilder();
  }

  @override
  Widget build(BuildContext context) {
    newsBuilder.build();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Text(capital(I18n.of(context).aboutNews)),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 6.0),
        child: CupertinoScrollbar(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: newsBuilder.newsTiles,
          ),
        ),
      ),
    );
  }
}
