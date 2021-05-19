import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/event.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:share/share.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

SlidingSheetDialog eventView(Event event, BuildContext context) {
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
            Padding(
              padding: EdgeInsets.fromLTRB(12.0, 0, 12.0, 8.0),
              child: Text(
                event.title,
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
            ),
            ListTile(
              title: Text(formatDate(context, event.start)),
              trailing: IconButton(
                icon: Icon(FeatherIcons.share2, color: app.settings.appColor),
                onPressed: () {
                  Share.share(event.content);
                },
              ),
            ),
          ],
        ),
      );
    },
    builder: (context, state) {
      return Material(
        color: app.settings.theme.backgroundColor,
        child: Padding(
          padding: EdgeInsets.fromLTRB(12.0, 0, 12.0, 8.0),
          child: app.settings.renderHtml
              ? Html(
                  data: event.content,
                  onLinkTap: (url, ctx, attr, elem) async {
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
                  text: escapeHtml(event.content),
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
  );
}
