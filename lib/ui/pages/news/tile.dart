import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/ui/pages/news/view.dart';
import 'package:flutter/cupertino.dart';
import 'package:filcnaplo/data/models/new.dart';
import 'package:flutter/material.dart';

class NewsTile extends StatelessWidget {
  final News news;
  NewsTile(this.news);

  @override
  Widget build(BuildContext context) => ListTile(
        // leading: Image.network(news.image, width: 50, height: 50) ??
        //     Icon(FeatherIcons.image),
        title: Text(news.title),
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => NewsView(news))),
      );
}
