import 'package:flutter/material.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/message.dart';
import 'package:filcnaplo/ui/pages/messages/message/tile.dart';
import 'package:filcnaplo/generated/i18n.dart';

class MessageBuilder {
  final updateCallback;

  MessageBuilder(this.updateCallback);

  List<List<MessageTile>> messageTiles = [[], [], [], []];

  void build() {
    for (var i = 1; i < 3; i++) {
      messageTiles[i] = [];
      List<Message> messagesByTypeInt(int j) {
        switch(j) {
          case 1:
            return app.user.sync.messages.sent;
          case 2:
            return app.user.sync.messages.archived;
        }
      }

      messagesByTypeInt(i).reversed.forEach((Message message) {
        messageTiles[i].add(
          MessageTile(message, [message], this.updateCallback,
              key: Key(message.id.toString())),
        );
      });
    }

    messageTiles[0] = [];
    List<Message> messages = app.user.sync.messages.received;
    Map<int, List<Message>> conversations = {};

    messages.sort(
      (a, b) => -a.date.compareTo(b.date),
    );

    messages.forEach((Message message) {
      if (message.conversationId == null) {
        messageTiles[0].add(MessageTile(message, [message], this.updateCallback,
            key: Key(message.id.toString())));
      } else {
        if (conversations[message.conversationId] == null)
          conversations[message.conversationId] = [];
        conversations[message.conversationId].add(message);
      }
    });

    conversations.keys.forEach((conversationId) {
      Message firstMessage = messages.firstWhere(
          (message) => message.messageId == conversationId,
          orElse: () => null);

      if (firstMessage == null)
        firstMessage = app.user.sync.messages.sent.firstWhere(
            (message) => message.messageId == conversationId,
            orElse: () => null);

      if (firstMessage != null) conversations[conversationId].add(firstMessage);
      messageTiles[0].add(MessageTile(
        conversations[conversationId].first,
        conversations[conversationId],
        this.updateCallback,
        key: Key(conversations[conversationId][0].id.toString()),
      ));
    });

    messageTiles[0].sort((a, b) => -a.message.date.compareTo(b.message.date));
  }
}
