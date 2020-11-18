import 'package:filcnaplo/ui/cards/message/tile.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/ui/card.dart';
import 'package:filcnaplo/data/models/message.dart';
import 'package:filcnaplo/ui/pages/messages/message/view.dart';

class MessageCard extends BaseCard {
  final Message message;
  final Key key;
  final DateTime compare;
  final _scaffoldKey;
  final callback;

  MessageCard(this.message, this._scaffoldKey, this.callback, {this.compare, this.key});

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      key: key,
      compare: compare,
      child: GestureDetector(
        child: Container(
          child: MessageTile(message),
        ),
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MessageView([message], this._scaffoldKey, this.callback)));
        },
      ),
    );
  }
}
