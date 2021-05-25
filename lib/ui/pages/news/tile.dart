import 'package:filcnaplo/ui/pages/news/view.dart';
import 'package:flutter/cupertino.dart';
import 'package:filcnaplo/data/models/news.dart';
import 'package:flutter/material.dart';

class NewsTile extends StatelessWidget {
  final News news;

  NewsTile(this.news);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(width: 1, color: Colors.white),
      ),
      margin: EdgeInsets.only(top: 6.0, left: 14.0, right: 14.0, bottom: 12.0),
      child: ListTile(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        title: Text(news.title!),
        subtitle: Text(
          news.content!.replaceAll("\n", " "),
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.fade,
        ),
        onTap: () => showDialog(
            context: context,
            builder: (BuildContext context) => NewsView(news)),
      ),
    );
  }
}
