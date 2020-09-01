import 'dart:convert';

import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/message.dart';
import 'package:filcnaplo/data/models/dummy.dart';

class MessageSync {
  List<List<Message>> data = [[], [], [], []];

  Future<bool> sync(i) async {
    if (!app.debugUser) {
      String type;
      List types = [
        "beerkezett",
        "elkuldott",
        "torolt",
      ];

      type = types[i];

      List<Message> messages;
      messages = await app.user.kreta.getMessages(type);

      if (messages == null) {
        await app.user.kreta.refreshLogin();
        messages = await app.user.kreta.getMessages(type);
      }

      if (messages != null) {
        data[i] = messages;

        List types = ["inbox", "sent", "trash", "draft"];

        String messageType = types[i];

        await app.user.storage.delete("messages_" + messageType);

        await Future.forEach(messages, (message) async {
          if (message.json != null) {
            await app.user.storage.insert("messages_" + messageType, {
              "json": jsonEncode(message.json),
            });
          }
        });
      }

      return messages != null;
    } else {
      data[0] = Dummy.messages;
      return true;
    }
  }

  delete() {
    data = [[], [], [], []];
  }
}
