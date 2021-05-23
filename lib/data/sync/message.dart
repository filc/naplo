import 'dart:convert';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/message.dart';
import 'package:filcnaplo/data/models/dummy.dart';

class MessageSync {
  List<Message> inbox = [];
  List<Message> sent = [];
  List<Message> trash = [];
  bool uiPending = true;

  Future<bool> sync() async {
    List<Message>? _inbox = [];
    List<Message>? _sent = [];
    List<Message>? _trash = [];

    if (!app.debugUser) {
      // Fetch messages from Kréta by type and store them in their own lists.
      Future getMessages() async {
        List types = [
          "beerkezett",
          "elkuldott",
          "torolt",
        ];
        _inbox = await app.user.kreta.getMessages(types[0]);
        _sent = await app.user.kreta.getMessages(types[1]);
        _trash = await app.user.kreta.getMessages(types[2]);
      }

      await getMessages();
      bool success = (_inbox != null && _sent != null && _trash != null);
      if (!success) {
        await app.user.kreta.refreshLogin();
        await getMessages();
        success = (_inbox != null && _sent != null && _trash != null);
        // refresh Login and try again in case we get null back.
      }

      if (success) {
        List types = ["inbox", "sent", "trash"];
        for (int i = 0; i <= 2; i++) {
          // Delete preexisting local messages from database
          await app.user.storage.delete("messages_" + types[i]);
        }

        Future saveLocally(List<Message> messages, String type) async {
          // Save given messages to database
          await Future.forEach(messages, (Message message) async {
            await app.user.storage.insert("messages_" + type, {
              "json": jsonEncode(message.json),
            });
          });
        }

        if (_inbox != null) inbox = _inbox!;
        await saveLocally(inbox, types[0]);
        if (_sent != null) sent = _sent!;
        await saveLocally(sent, types[1]);
        if (_trash != null) trash = _trash!;
        await saveLocally(trash, types[2]);
      }

      uiPending = true;

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
  }
}
