import 'package:filcnaplo/ui/bottom_card.dart';
import 'package:filcnaplo/ui/pages/news/builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewsList extends StatefulWidget {
  NewsList();

  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  NewsBuilder newsBuilder;

  _NewsListState() {
    this.newsBuilder = NewsBuilder();
  }
  @override
  Widget build(BuildContext context) {
    newsBuilder.build();

    return Drawer(
        child: ListView(
      children: newsBuilder.newsTiles,
    ));
  }
}
