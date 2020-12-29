import 'package:flutter/material.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/message.dart';
import 'package:filcnaplo/generated/i18n.dart';




Future archiveMessage(BuildContext context, Message message, bool archiving, Function updateCallback) async {
  messageLocalType typeUndeleted = (message.sender == app.user.realName) ? messageLocalType.sent : messageLocalType.received; //Amennyiben nincs törölve, küldve, vagy kapva van?
  messageLocalType oldType, newType;
  switch(archiving) {
    case true:
      newType = messageLocalType.archived;
      oldType = typeUndeleted;
      break;
    case false:
      newType = typeUndeleted;
      oldType = messageLocalType.archived;
  }

  app.user.kreta.trashMessage(archiving, message.id);
  if (archiving) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
      content: Text(I18n
          .of(context)
          .messageDeleted),
      duration: Duration(seconds: 5),
      action: SnackBarAction(
        label: I18n
            .of(context)
            .dialogUndo,
        onPressed: () {
          app.user.kreta.trashMessage(false, message.id);
          messageMove(message, newType, oldType);
          message.deleted = false;
          updateCallback();
        },
      ),
    ));
  }
  messageMove(message, oldType, newType);
  message.deleted=archiving;
  updateCallback();
}
void messageMove(message, fromType, toType) {
  messageArray(fromType).removeWhere((msg) => msg.id == message.id);
  messageArray(toType).add(message);
  messageArray(toType).sort((a, b) => a.date.compareTo(b.date));
}
List<Message> messageArray(messageLocalType type) {
  switch(type) {
    case messageLocalType.received:
      return app.user.sync.messages.received;
      break;
    case messageLocalType.sent:
      return app.user.sync.messages.sent;
      break;
    case messageLocalType.archived:
      return app.user.sync.messages.archived;
      break;
    case messageLocalType.draft:
      return app.user.sync.messages.drafted;
      break;
  }
}
