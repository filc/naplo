import 'package:flutter/material.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/message.dart';
import 'package:filcnaplo/generated/i18n.dart';

class MessageArchiveHelper {
  Future archiveMessage(
    BuildContext context,
    Message message,
    bool archiving,
    Function updateCallback,
  ) async {
    MessageType oldPlace, newPlace;
    if (archiving) {
      oldPlace = message.type;
      newPlace = MessageType.archived;
    } else {
      oldPlace = MessageType.archived;
      newPlace = message.type;
    }

    await app.user.kreta.trashMessage(archiving, message.id);

    moveMessage(message, oldPlace, newPlace);
    // We move the message from it's old tab to the new tab
    message.deleted = archiving;
    updateCallback();

    if (archiving) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(I18n.of(context).messageDeleted),
        duration: Duration(seconds: 5),
        action: SnackBarAction(
          label: I18n.of(context).dialogUndo,
          onPressed: () {
            app.user.kreta.trashMessage(false, message.id);
            moveMessage(message, newPlace, oldPlace);
            // We move from the "newPlace" to the "oldPlace", essentially reversing the original moving action.
            message.deleted = false;
            updateCallback();
          },
        ),
      ));
    }
  }

  void moveMessage(message, fromPlace, toPlace) {
    localMessages(fromPlace).removeWhere((msg) => msg.id == message.id);
    localMessages(toPlace).add(message);
    localMessages(toPlace).sort((a, b) => a.date.compareTo(b.date));
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
      default:
        return null;
    }
  }
}
