import 'package:flutter/material.dart';
import 'package:filcnaplo/ui/pages/messages/message/builder.dart';
import 'package:filcnaplo/ui/pages/messages/note/builder.dart';
import 'package:filcnaplo/ui/pages/messages/event/builder.dart';
import 'package:filcnaplo/ui/pages/messages/tabs.dart';

class MessagesPage extends StatefulWidget {
  final _scaffoldKey;

  MessagesPage(this._scaffoldKey);

  @override
  _MessagesPageState createState() => _MessagesPageState(this._scaffoldKey);
}

class _MessagesPageState extends State<MessagesPage> {
  MessageBuilder _messageBuilder;
  NoteBuilder _noteBuilder;
  EventBuilder _eventBuilder;

  _MessagesPageState(_scaffoldKey) {
    this._messageBuilder = MessageBuilder(_scaffoldKey, updateCallback);
    this._noteBuilder = NoteBuilder();
    this._eventBuilder = EventBuilder();
  }

  @override
  Widget build(BuildContext context) {
    buildPage();

    return MessageTabs(
      widget._scaffoldKey,
      _messageBuilder.messageTiles,
      _noteBuilder.noteTiles,
      _eventBuilder.eventTiles,
      callback: updateCallback,
    );
  }

  void updateCallback() {
    setState(() {});
  }

  void buildPage() {
    _messageBuilder.build();
    _noteBuilder.build();
    _eventBuilder.build();
  }
}
