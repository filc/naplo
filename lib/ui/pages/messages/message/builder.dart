import 'package:flutter/material.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/message.dart';
import 'package:filcnaplo/ui/pages/messages/message/tile.dart';

class MessageBuilder {
  final Function updateCallback;
  MessageBuilder(this.updateCallback);

  MessageTiles messageTiles = MessageTiles();

  void build() {
    messageTiles.clear();
    // We have to clear our tiles every time before rebuilding them to avoid duplicates

    app.user.sync.messages.sent.reversed.forEach((Message message) {
      messageTiles.sent.add(
        MessageTile(
          message,
          [message],
          updateCallback,
          key: Key(message.id.toString()),
        ),
      );
    });
    // We don't care about conversations for sent messages, so we display every one of them.
    // The following part groups received (+ archived) messages into conversations, and only displays the newest one in every category
    List<Message> received = app.user.sync.messages.inbox;
    List<Message> archived = app.user.sync.messages.trash;
    Map<int, List<Message>> conversations = {};

    void buildConversations(
        // If the message is a reply to something,add it to a conversation. If not, treat it as a single message and display it like sent messages
        List<Message> messages,
        List<MessageTile> messageTileList) {
      messages.sort(
        (a, b) => -a.date!.compareTo(b.date!),
      );

      messages.forEach((Message message) {
        if (message.conversationId == null) {
          messageTileList.add(MessageTile(
            message,
            [message],
            updateCallback,
            key: Key(message.id.toString()),
          ));
        } else {
          if (conversations[message.conversationId] == null)
            conversations[message.conversationId!] = [];
          conversations[message.conversationId]!.add(message);
        }
      });
    }

    buildConversations(received, messageTiles.received);
    buildConversations(archived, messageTiles.archived);

    conversations.keys.forEach((conversationId) {
      Message? firstMessage = received.firstWhere(
          (message) => message.messageId == conversationId,
          orElse: null);

      conversations[conversationId]!.add(firstMessage);
      List<MessageTile> messageTileListOfFirst = () {
            // Returns the list of messageTiles for the specific type
            if (conversations[conversationId]!.first.deleted) {
              return messageTiles.archived;
            } else if (conversations[conversationId]!.first.type ==
                MessageType.inbox) {
              return messageTiles.received;
            }
          }() ??
          [];

      // Display the newest message of the conversation
      messageTileListOfFirst.add(MessageTile(
        conversations[conversationId]!.first,
        conversations[conversationId]!,
        updateCallback,
        key: Key(conversations[conversationId]![0].id.toString()),
      ));

      // The oldest message is not replying to anything, so it was displayed like a single message. Now we remove it from the list to make sure that only the newest message is displayed from every conversation.
      messageTileListOfFirst.removeWhere((messageTile) =>
          messageTile.message.id == conversations[conversationId]!.last.id);
    });

    messageTiles.received
        .sort((a, b) => -a.message.date!.compareTo(b.message.date!));

    messageTiles.archived
        .sort((a, b) => -a.message.date!.compareTo(b.message.date!));
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
        return [];
    }
  }

  void clear() {
    received = [];
    sent = [];
    archived = [];
    drafted = [];
  }
}
