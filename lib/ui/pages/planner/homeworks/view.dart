//import 'package:feather_icons_flutter/feather_icons_flutter.dart';
//import 'package:filcnaplo/ui/bottom_card.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/homework.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/common/profile_icon.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'attachment.dart';

class HomeworkView extends StatefulWidget {
  final Homework homework;

  HomeworkView(this.homework);

  @override
  _HomeworkViewState createState() => _HomeworkViewState();
}

class _HomeworkViewState extends State<HomeworkView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        color: app.settings.theme.backgroundColor,
      ),
      margin: EdgeInsets.only(top: 64.0),
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ProfileIcon(name: widget.homework.teacher),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.homework.teacher != null
                              ? capitalize(widget.homework.teacher)
                              : I18n.of(context).unknown,
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
            ],
          ),

          // Homework details

          HomeworkDetail(
            I18n.of(context).homeworkDeadline,
            formatDate(context, widget.homework.deadline),
          ),

          SizedBox(height: 12.0),

          // Message content
          Expanded(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                app.settings.renderHtml
                    ? Html(
                        data: widget.homework.content,
                        onLinkTap: (url) async {
                          await FlutterWebBrowser.openWebPage(
                            url: url,
                            customTabsOptions: CustomTabsOptions(
                              toolbarColor: app.settings.theme.backgroundColor,
                              showTitle: true,
                            ),
                            safariVCOptions: SafariViewControllerOptions(
                              dismissButtonStyle:
                                  SafariViewControllerDismissButtonStyle.close,
                            ),
                          );
                        },
                      )
                    : SelectableLinkify(
                        text: escapeHtml(widget.homework.content),
                        onOpen: (url) async {
                          await FlutterWebBrowser.openWebPage(
                            url: url.url,
                            customTabsOptions: CustomTabsOptions(
                              toolbarColor: app.settings.theme.backgroundColor,
                              showTitle: true,
                            ),
                            safariVCOptions: SafariViewControllerOptions(
                              dismissButtonStyle:
                                  SafariViewControllerDismissButtonStyle.close,
                            ),
                          );
                        },
                      ),
                widget.homework.attachments == []
                    ? Container()
                    : Column(
                        children: widget.homework.attachments
                            .map((attachment) => AttachmentTile(attachment))
                            .toList())
              ],
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
      children: [
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
