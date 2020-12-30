import 'package:filcnaplo/data/models/new.dart';
import 'package:flutter/cupertino.dart';

class NewsView extends StatelessWidget {
  final News news;

  NewsView(this.news);

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
        child: Container(child: Text("lol?")),
      );
}
