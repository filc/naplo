import 'package:flutter/material.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/message.dart';
import 'package:filcnaplo/generated/i18n.dart';

Future archiveMessage(BuildContext context, Message message, bool archiving, Function updateCallback) async {
  int sentByUser = (message.sender == app.user.realName) ? 1 : 0;
  int oldPlace = archiving ? sentByUser : 2;
  int newPlace = archiving ? 2 : sentByUser;

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
          app.user.sync.messages.data[newPlace].removeWhere((msg) => msg.id == message.id);
          app.user.sync.messages.data[oldPlace].add(message);
          app.user.sync.messages.data[oldPlace].sort((a, b) => a.date.compareTo(b.date));
          message.deleted = false;
          updateCallback();
        },
      ),
    ));
  }
  app.user.sync.messages.data[oldPlace].removeWhere((msg) => msg.id == message.id);
  app.user.sync.messages.data[newPlace].add(message);
  app.user.sync.messages.data[newPlace].sort((a, b) => a.date.compareTo(b.date));
  message.deleted=archiving;
  updateCallback();
}
