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
import 'package:sliding_sheet/sliding_sheet.dart';
import 'attachment.dart';

SlidingSheetDialog homeworkView(Homework homework, BuildContext context) {
  return SlidingSheetDialog(
    cornerRadius: 16,
    cornerRadiusOnFullscreen: 0,
    avoidStatusBar: true,
    color: app.settings.theme.backgroundColor,
    scrollSpec: ScrollSpec.bouncingScroll(),
    duration: Duration(milliseconds: 300),
    snapSpec: const SnapSpec(
      snap: true,
      snappings: [0.5, 0.7, 1.0],
      positioning: SnapPositioning.relativeToAvailableSpace,
    ),
    headerBuilder: (context, state) {
      return Material(
        color: app.settings.theme.backgroundColor,
        child: Padding(
          padding: EdgeInsets.fromLTRB(12.0, 0, 12.0, 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                height: 4.0,
                width: 60.0,
                margin: EdgeInsets.all(12.0),
              ),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: ProfileIcon(name: homework.teacher),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              homework.teacher != null
                                  ? capitalize(homework.teacher)
                                  : I18n.of(context).unknown,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Text(formatDate(context, homework.date))
                        ],
                      ),
                      subtitle: Text(capital(homework.subjectName)),
                    ),
                  ),
                ],
              ),

              // Homework details
              Row(
                children: [
                  HomeworkDetail(
                    I18n.of(context).homeworkDeadline,
                    formatDate(context, homework.deadline),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
    builder: (context, state) {
      return Material(
        color: app.settings.theme.backgroundColor,
        child: Padding(
          padding: EdgeInsets.fromLTRB(12.0, 0, 12.0, 8.0),
          child:
              // Message content
              app.settings.renderHtml
                  ? Html(
                      data: homework.content,
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
                      text: escapeHtml(homework.content),
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
        ),
      );
    },
    footerBuilder: (context, state) {
      return Material(
        color: app.settings.theme.backgroundColor,
        child: homework.attachments == []
            ? Container()
            : Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: homework.attachments
                    .map((attachment) => AttachmentTile(attachment))
                    .toList()),
      );
    },
  );
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
