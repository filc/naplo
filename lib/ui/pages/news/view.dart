import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/models/new.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsView extends StatefulWidget {
  final News news;

  NewsView(this.news);

  @override
  _NewsViewState createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  Widget image;
  _NewsViewState();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          margin: EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height - 150,
            ),
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: ListView(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      widget.news.title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: FontSize.large.size),
                    ),
                  ],
                ),
                widget.news.content != null
                    ? Container(
                        margin: EdgeInsets.only(top: 10, bottom: 20),
                        child: SelectableText(widget.news.content),
                      )
                    : Container(),
                widget.news.image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        child: Image.network(
                          widget.news.image,
                        ),
                      )
                    : Container(),
                widget.news.link != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextButton(
                            child:
                                Text(I18n.of(context).dialogOpen.toUpperCase(),
                                    style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                    )),
                            onPressed: () async {
                              if (await (canLaunch(widget.news.link)))
                                await launch(widget.news.link);
                              else
                                throw "Cannot open url ${widget.news.link}";
                            },
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
