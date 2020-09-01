import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/homework.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/profile_icon.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeworkView extends StatefulWidget {
  final Homework homework;
  final Function onSolved;

  HomeworkView(this.homework, this.onSolved);

  @override
  _HomeworkViewState createState() => _HomeworkViewState();
}

class _HomeworkViewState extends State<HomeworkView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 12.0),
      decoration: BoxDecoration(
        color: app.settings.theme.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: ListTile(
                  leading: ProfileIcon(name: widget.homework.teacher),
                  title: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          capitalize(widget.homework.teacher),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Text(formatDate(context, widget.homework.date))
                    ],
                  ),
                  subtitle: Text(capital(widget.homework.subjectName)),
                ),
              ),
              Container(
                width: 42.0,
                margin: EdgeInsets.only(right: 12.0),
                child: Column(
                  children: <Widget>[
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0)),
                      padding: EdgeInsets.zero,
                      onPressed: () =>
                          setState(() => widget.onSolved(widget.homework)),
                      child: Icon(
                        widget.homework.isSolved
                            ? FeatherIcons.checkSquare
                            : FeatherIcons.square,
                        color: widget.homework.isSolved
                            ? app.settings.appColor
                            : null,
                      ),
                    ),
                    Text(
                      capital(I18n.of(context).dialogDone),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            ],
          ),

          // Homework details
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(14.0),
              child: CupertinoScrollbar(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: HomeworkDetail(
                        I18n.of(context).homeworkDeadline,
                        formatDate(context, widget.homework.deadline),
                      ),
                    ),

                    // Message content
                    app.settings.renderHtml
                        ? Html(
                            data: widget.homework.content,
                            onLinkTap: (url) async {
                              if (await canLaunch(url))
                                await launch(url);
                              else
                                throw 'Invalid URL';
                            },
                          )
                        : SelectableLinkify(
                            text: escapeHtml(widget.homework.content),
                            onOpen: (url) async {
                              if (await canLaunch(url.url))
                                await launch(url.url);
                              else
                                throw 'Invalid URL';
                            },
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeworkDetail extends StatelessWidget {
  final String title;
  final String value;

  HomeworkDetail(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      children: <Widget>[
        Text(
          capital(title) + ":  ",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 16.0),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
