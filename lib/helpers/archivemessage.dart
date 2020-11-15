import 'package:flutter/material.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/message.dart';
//import 'package:filcnaplo/ui/pages/messages/message/tile.dart';
import 'package:filcnaplo/generated/i18n.dart';

Future archiveMessage(_scaffoldKey, BuildContext context, Message message, bool put, Function callback) async {
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
          app.user.sync.messages.data[2].removeWhere((msg) => msg.id == message.id);
          app.user.sync.messages.data[0].insert(0, message);
          app.user.sync.messages.data[0].sort((a, b) => a.date.compareTo(b.date));
          message.deleted = false;
          callback();
        },
      ),
    ));
  }
  //app.user.sync.messages.data[app.selectedMessagePage].removeWhere((msg) => msg.id == message.id); // Searchből futtatva nem szedi le

  if (put) {
    app.user.sync.messages.data[0].removeWhere((msg) => msg.id == message.id);
    app.user.sync.messages.data[2].add(message);
    app.user.sync.messages.data[2].sort((a, b) => a.date.compareTo(b.date));
  } else {
    app.user.sync.messages.data[2].removeWhere((msg) => msg.id == message.id);
    app.user.sync.messages.data[0].add(message);
    app.user.sync.messages.data[0].sort((a, b) => a.date.compareTo(b.date));
  }
  message.deleted=put;
  callback();
}