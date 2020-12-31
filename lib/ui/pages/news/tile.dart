import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/ui/pages/news/view.dart';
import 'package:flutter/cupertino.dart';
import 'package:filcnaplo/data/models/new.dart';
import 'package:flutter/material.dart';

class NewsTile extends StatelessWidget {
  final News news;
  NewsTile(this.news);

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(width: 1, color: Colors.white),
        ),
        margin: EdgeInsets.only(top: 5, left: 5, right: 5),
        child: ListTile(
          // leading: Image.network(news.image, width: 50, height: 50)
          leading: Icon(FeatherIcons.mail),
          title: Text(news.title),
          subtitle: Text(
            news.content,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () => showDialog(
              barrierColor: Colors.transparent,
              context: context,
              builder: (BuildContext context) => NewsView(news)),
        ),
      );
}
