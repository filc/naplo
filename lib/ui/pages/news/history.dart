import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/ui/bottom_card.dart';
import 'package:filcnaplo/ui/pages/news/builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewsHistoryView extends StatefulWidget {
  final BuildContext context;

  NewsHistoryView(this.context);

  @override
  _NewsHistoryViewState createState() => _NewsHistoryViewState();
}

class _NewsHistoryViewState extends State<NewsHistoryView> {
  NewsBuilder newsBuilder;

  _NewsHistoryViewState() {
    this.newsBuilder = NewsBuilder();
  }
  @override
  Widget build(BuildContext context) {
    newsBuilder.build();

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(15),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: newsBuilder.newsTiles,
        ),
      ),
    );
  }
}
