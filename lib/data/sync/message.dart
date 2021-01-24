import 'dart:convert';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/message.dart';
import 'package:filcnaplo/data/models/dummy.dart';

class MessageSync {
  List<Message> inbox = [];
  List<Message> sent = [];
  List<Message> trash = [];
  List<Message> draft = [];

  Future<bool> sync() async {
    if (!app.debugUser) {
      // Fetch messages from Kréta by type and store them in their own lists.
      Future getMessages() async {
        List types = [
          "beerkezett",
          "elkuldott",
          "torolt",
        ];
        inbox = await app.user.kreta.getMessages(types[0]) ?? [];
        sent = await app.user.kreta.getMessages(types[1]) ?? [];
        trash = await app.user.kreta.getMessages(types[2]) ?? [];
      }

      await getMessages();
      bool success = (inbox != null && sent != null && trash != null);
      if (!success) {
        await app.user.kreta.refreshLogin();
        await getMessages();
        // refresh Login and try again in case we get null back.
      }
      inbox ??= [];
      sent ??= [];
      trash ??= [];
      draft ??= [];
      // Replace nulls with empty lists if Kreta is non-cooperative.

      if (success) {
        List types = ["inbox", "sent", "trash", "draft"];
        for (int i = 0; i < 3; i++) {
          // Delete preexisting local messages from database
          await app.user.storage.delete("messages_" + types[i]);
        }

        Future saveLocally(List<Message> messages, String type) async {
          // Save given messages to database
          await Future.forEach(messages, (message) async {
            if (message.json != []) {
              await app.user.storage.insert("messages_" + type, {
                "json": jsonEncode(message.json),
              });
            }
          });
        }

        await saveLocally(inbox, types[0]);
        await saveLocally(sent, types[1]);
        await saveLocally(trash, types[2]);
      }

      return success;
    } else {
      inbox = Dummy.messages;
      return true;
    }
  }

  delete() {
    inbox = [];
    sent = [];
    trash = [];
    draft = [];
  }
}
