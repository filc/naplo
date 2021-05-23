import 'package:filcnaplo/ui/common/custom_snackbar.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/message.dart';
import 'package:filcnaplo/generated/i18n.dart';

class MessageArchiveHelper {
  Future deleteMessage(
      BuildContext context, Message message, Function updateCallback) async {
    await app.user.kreta.deleteMessage(message.id);
    app.user.sync.messages.trash.removeWhere((msg) => msg.id == message.id);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
      message: I18n.of(context).messageDeleted,
      duration: Duration(seconds: 5),
    ));
    updateCallback();
  }

  Future archiveMessage(
    BuildContext context,
    Message message,
    bool archiving,
    Function updateCallback, {
    bool showSnackbar = true,
  }) async {
    MessageType oldPlace, newPlace;
    if (message.type == null) return;

    if (archiving) {
      oldPlace = message.type!;
      newPlace = MessageType.trash;
    } else {
      oldPlace = MessageType.trash;
      newPlace = message.type!;
    }

    await app.user.kreta.trashMessage(archiving, message.id);

    moveMessage(message, oldPlace, newPlace);
    // We move the message from it's old tab to the new tab
    message.deleted = archiving;
    updateCallback();

    if (archiving && showSnackbar) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
        message: I18n.of(context).messageArchived,
        duration: Duration(seconds: 5),
        action: SnackBarAction(
          label: capital(I18n.of(context).dialogUndo),
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
    localMessages(fromPlace)?.removeWhere((msg) => msg.id == message.id);
    localMessages(toPlace)?.add(message);
    localMessages(toPlace)?.sort((a, b) => a.date!.compareTo(b.date!));
    // Removing from old tab, adding to new tab and sorting to maintain time continuity.
  }

  List<Message>? localMessages(MessageType type) {
    // Returns the list in which the wanted type of messages are stored in.
    switch (type) {
      case MessageType.inbox:
        return app.user.sync.messages.inbox;
      case MessageType.sent:
        return app.user.sync.messages.sent;
      case MessageType.trash:
        return app.user.sync.messages.trash;
      case MessageType.draft:
        return [];
      default:
        return null;
    }
  }
}
