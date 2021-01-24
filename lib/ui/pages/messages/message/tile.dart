import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/data/models/message.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/ui/common/profile_icon.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo/ui/pages/messages/message/view.dart';
import 'package:filcnaplo/helpers/archive_message.dart';

class MessageTile extends StatelessWidget {
  final Message message;
  final List<Message> children;
  final updateCallback;
  final Key key;

  MessageTile(this.message, this.children, this.updateCallback, {this.key});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: key,
      onDismissed: (direction) => () {
        if (message.deleted) {
          if (direction == DismissDirection.startToEnd) {
            // Archived, pulled from left, should delete permanently.
            MessageArchiveHelper()
                .deleteMessage(context, message, updateCallback);
          } else {
            // Archived, pulled from right, should unarchive
            MessageArchiveHelper()
                .archiveMessage(context, message, false, updateCallback);
          }
        } else {
          // Not archived, so both directions should archive.
          MessageArchiveHelper()
              .archiveMessage(context, message, true, updateCallback);
        }
      }(),
      secondaryBackground: Container(
        color: message.deleted ? Colors.blue[600] : Colors.green[600],
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 24.0),
        child: Icon(
          message.deleted ? FeatherIcons.arrowUp : FeatherIcons.archive,
          color: Colors.white,
        ),
      ),
      background: Container(
        color: message.deleted ? Colors.red[600] : Colors.green[600],
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 24.0),
        child: Icon(
          message.deleted ? FeatherIcons.trash2 : FeatherIcons.archive,
          color: Colors.white,
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.0),
        child: ListTile(
          leading: ProfileIcon(name: message.sender),
          title: Row(children: [
            Expanded(
              child: Text(
                message.sender,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Row(children: [
              (message.attachments.length > 0)
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Icon(FeatherIcons.paperclip, size: 20.0))
                  : Container(),
              Text(
                formatDate(context, message.date),
                textAlign: TextAlign.right,
              )
            ]),
          ]),
          subtitle: Text(
            message.subject +
                "\n" +
                escapeHtml(message.content.replaceAll("\n", " ")),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();

            Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
                builder: (context) => MessageView(children, updateCallback)));
          },
        ),
      ),
    );
  }
}
