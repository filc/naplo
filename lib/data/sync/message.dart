import 'dart:convert';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/message.dart';
import 'package:filcnaplo/data/models/dummy.dart';

class MessageSync {
  List<Message> received = [];
  List<Message> sent = [];
  List<Message> archived = [];
  List<Message> drafted = [];

  Future<bool> sync() async {
    if (!app.debugUser) {
      // Fetch messages from Kréta by type and store them in their own lists.
      Future<void> getMessages() async {
        List types = [
          "beerkezett",
          "elkuldott",
          "torolt",
        ];
        received = await app.user.kreta.getMessages(types[0]);
        sent = await app.user.kreta.getMessages(types[1]);
        archived = await app.user.kreta.getMessages(types[2]);
      }

      getMessages();
      bool success = (received != null && sent != null && archived != null);
      if (!success) {
        await app.user.kreta.refreshLogin();
        getMessages();
        // refresh Login and try again in case we get null back.
      }
      received ??= [];
      sent ??= [];
      archived ??= [];
      drafted ??= [];
      // Replace nulls with empty lists if Kreta is non-cooperative.

      if (success) {
        List types = ["inbox", "sent", "trash", "draft"];
        for (int i = 0; i < 3; i++) {
          // Delete preexisting local messages from database
          await app.user.storage.delete("messages_" + types[i]);
        }

        Future<void> saveLocally(List<Message> messages, String type) async {
          // Save given messages to database
          await Future.forEach(messages, (message) async {
            if (message.json != []) {
              await app.user.storage.insert("messages_" + type, {
                "json": jsonEncode(message.json),
              });
            }
          });
        }

        await saveLocally(received, types[0]);
        await saveLocally(sent, types[1]);
        await saveLocally(archived, types[2]);
      }

      return success;
    } else {
      received = Dummy.messages;
      return true;
    }
  }

  delete() {
    received = [];
    sent = [];
    archived = [];
    drafted = [];
  }
}
