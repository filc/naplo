import 'package:flutter/material.dart';
import 'package:filcnaplo/data/models/message.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/ui/profile_icon.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo/ui/pages/messages/message/view.dart';
import 'package:filcnaplo/helpers/archivemessage.dart';

class MessageTile extends StatelessWidget {
  final Message message;
  final List<Message> children;
  final _builderScaffold;
  final callback;
  final Key key;

  MessageTile(this.message, this.children, this._builderScaffold, this.callback, {this.key});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: key,
      onDismissed: (direction) => archiveMessage(_builderScaffold, context, message, !message.deleted, callback),
      secondaryBackground: Container(
        color: message.deleted ? Colors.green[600] : Colors.blue[600],
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 24.0),
        child: Icon(
           message.deleted ? FeatherIcons.externalLink : FeatherIcons.archive,
          color: Colors.white,
        ),
      ),
      background: Container(
        color: message.deleted ? Colors.green[600] : Colors.blue[600],
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 24.0),
        child: Icon(
          message.deleted ? FeatherIcons.externalLink : FeatherIcons.archive,
          color: Colors.white,
        ),
      ),
      child: GestureDetector(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 4.0),
          child: ListTile(
            leading: ProfileIcon(name: message.sender),
            title: Row(children: <Widget>[
              Expanded(
                child: Text(
                  message.sender,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              Row(children: <Widget>[
                (message.attachments.length > 0)
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: Icon(FeatherIcons.paperclip, size: 20.0))
                    : Container(),
                Text(formatDate(context, message.date),
                    textAlign: TextAlign.right)
              ]),
            ]),
            subtitle: Text(
              message.subject + "\n" + escapeHtml(message.content),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MessageView(children, this._builderScaffold, this.callback)));
        },
      ),
    );
  }
}
