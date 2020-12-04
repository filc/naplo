import 'package:flutter/material.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/message.dart';
import 'package:filcnaplo/generated/i18n.dart';

Future archiveMessage(_scaffoldKey, BuildContext context, Message message, bool put, Function callback) async {
  int sentByUser = (message.sender == app.user.realName) ? 1 : 0;
  int oldPlace = put ? sentByUser : 2;
  int newPlace = put ? 2 : sentByUser;

  app.user.kreta.trashMessage(put, message.id);
  if(put && !(_scaffoldKey.currentState == null)) { //searchből nem kap rendes scaffoldkeyt
    _scaffoldKey.currentState.showSnackBar(SnackBar(
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
          callback();
        },
      ),
    ));
  }
  app.user.sync.messages.data[oldPlace].removeWhere((msg) => msg.id == message.id);
  app.user.sync.messages.data[newPlace].add(message);
  app.user.sync.messages.data[newPlace].sort((a, b) => a.date.compareTo(b.date));
  message.deleted=put;
  callback();
}
