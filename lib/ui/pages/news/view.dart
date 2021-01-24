import 'package:filcnaplo/data/models/new.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/style.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsView extends StatefulWidget {
  final News news;

  NewsView(this.news);

  @override
  _NewsViewState createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 64),
        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: app.settings.theme.backgroundColor,
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  Text(
                    widget.news.title ?? "",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: FontSize.large.size,
                    ),
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
                ],
              ),
            ),
            Row(
              children: [
                widget.news.link != null
                    ? TextButton(
                        child: Text(
                          I18n.of(context).dialogOpen.toUpperCase(),
                          style: TextStyle(
                            color: app.settings.appColor,
                          ),
                        ),
                        onPressed: () async {
                          if (await canLaunch(widget.news.link))
                            await launch(widget.news.link);
                          else
                            throw "Cannot open url ${widget.news.link}";
                        },
                      )
                    : Container(),
                Spacer(),
                TextButton(
                  child: Text(
                    I18n.of(context).dialogDone.toUpperCase(),
                    style: TextStyle(
                      color: app.settings.appColor,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
