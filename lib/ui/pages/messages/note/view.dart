import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:share/share.dart';
import 'package:filcnaplo/ui/common/profile_icon.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo/data/models/note.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

SlidingSheetDialog noteView(Note note, BuildContext context) {
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
                note.title,
                style: TextStyle(
                  fontSize: 22.0,
                ),
              ),
            ),
            ListTile(
              leading: ProfileIcon(name: note.teacher),
              title: Text(note.teacher),
              subtitle: Text(formatDate(context, note.date)),
              trailing: IconButton(
                icon: Icon(FeatherIcons.share2, color: app.settings.appColor),
                onPressed: () {
                  Share.share(note.content);
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
                  data: note.content,
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
                  text: escapeHtml(note.content),
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
