import 'package:flutter/material.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/message.dart';
import 'package:filcnaplo/generated/i18n.dart';

class MessageArchiveHelper {
  Future archiveMessage(BuildContext context, Message message, bool archiving,
      Function updateCallback) async {
    MessageType typeUndeleted = (message.sender == app.user.realName)
        ? MessageType.sent
        : MessageType.received;
    // The type of the message (which tab it shows up on) if it's not archived.

    MessageType oldType, newType;
    switch (archiving) {
      case true:
        newType = MessageType.archived;
        oldType = typeUndeleted;
        break;
      case false:
        newType = typeUndeleted;
        oldType = MessageType.archived;
    }
    // We move from typeUndeleted (see above) to archived while archiving, and the opposite when unarchiving.

    app.user.kreta.trashMessage(archiving, message.id);
    if (archiving) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(I18n.of(context).messageDeleted),
        duration: Duration(seconds: 5),
        action: SnackBarAction(
          label: I18n.of(context).dialogUndo,
          onPressed: () {
            app.user.kreta.trashMessage(false, message.id);
            moveMessage(message, newType, oldType);
            // We move from the "newType" to the "oldType", essentially reversing the original moving action.
            message.deleted = false;
            updateCallback();
          },
        ),
      ));
    }
    moveMessage(message, oldType, newType);
    // We move the message from it's old tab to the new tab
    message.deleted = archiving;
    updateCallback();
  }

  void moveMessage(message, fromType, toType) {
    localMessages(fromType).removeWhere((msg) => msg.id == message.id);
    localMessages(toType).add(message);
    localMessages(toType).sort((a, b) => a.date.compareTo(b.date));
    // Removing from old tab, adding to new tab and sorting to maintain time continuity.
  }

  List<Message> localMessages(MessageType type) {
    // Returns the list in which the wanted type of messages are stored in.
    switch (type) {
      case MessageType.received:
        return app.user.sync.messages.received;
        break;
      case MessageType.sent:
        return app.user.sync.messages.sent;
        break;
      case MessageType.archived:
        return app.user.sync.messages.archived;
        break;
      case MessageType.drafted:
        return app.user.sync.messages.drafted;
        break;
    }
  }
}
