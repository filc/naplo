import 'package:flutter/material.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/message.dart';
import 'package:filcnaplo/ui/pages/messages/message/tile.dart';

class MessageBuilder {
  final updateCallback;
  MessageBuilder(this.updateCallback);

  MessageTiles messageTiles = MessageTiles();

  void build() {
    messageTiles.clear();
    // We have to clear our tiles every time before rebuilding them to avoid duplicates

    app.user.sync.messages.sent.reversed.forEach((Message message) {
      messageTiles.sent.add(
        MessageTile(message, [message], this.updateCallback,
            key: Key(message.id.toString())),
      );
    });
    app.user.sync.messages.archived.reversed.forEach((Message message) {
      messageTiles.archived.add(
        MessageTile(message, [message], this.updateCallback,
            key: Key(message.id.toString())),
      );
    });
    // We don't check if sent or archived messages are part of a conversation, we always display every one of them.
    // The next part builds single received messages, and the latest received messages of conversations.
    List<Message> received = app.user.sync.messages.received;
    Map<int, List<Message>> conversations = {};

    received.sort(
      (a, b) => -a.date.compareTo(b.date),
    );

    received.forEach((Message message) {
      if (message.conversationId == null) {
        messageTiles.received.add(MessageTile(
            message, [message], this.updateCallback,
            key: Key(message.id.toString())));
      } else {
        if (conversations[message.conversationId] == null)
          conversations[message.conversationId] = [];
        conversations[message.conversationId].add(message);
      }
    });

    conversations.keys.forEach((conversationId) {
      Message firstMessage = received.firstWhere(
          (message) => message.messageId == conversationId,
          orElse: () => null);

      if (firstMessage == null)
        firstMessage = app.user.sync.messages.sent.firstWhere(
            (message) => message.messageId == conversationId,
            orElse: () => null);

      if (firstMessage != null) conversations[conversationId].add(firstMessage);
      messageTiles.received.add(MessageTile(
        conversations[conversationId].first,
        conversations[conversationId],
        this.updateCallback,
        key: Key(conversations[conversationId][0].id.toString()),
      ));
    });

    messageTiles.received
        .sort((a, b) => -a.message.date.compareTo(b.message.date));
  }
}

class MessageTiles {
  List<MessageTile> received = [];
  List<MessageTile> sent = [];
  List<MessageTile> archived = [];
  List<MessageTile> drafted = [];
  List<MessageTile> getSelectedMessages(int i) {
    // The DropDown() widget that selects the specific message types only gives back an integer, so we have to include a function that returns the needed messageTiles from a numeric index.
    switch (i) {
      case 0:
        return received;
      case 1:
        return sent;
      case 2:
        return archived;
      case 3:
        return drafted;
      default:
        return null;
    }
  }

  void clear() {
    received = [];
    sent = [];
    archived = [];
    drafted = [];
  }
}
