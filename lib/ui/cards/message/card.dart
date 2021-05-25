import 'package:filcnaplo/ui/cards/message/tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/ui/cards/base.dart';
import 'package:filcnaplo/data/models/message.dart';
import 'package:filcnaplo/ui/pages/messages/message/view.dart';

class MessageCard extends BaseCard {
  final Message message;
  final DateTime compare;
  final Function()? updateCallback;

  MessageCard(this.message, this.updateCallback, {required this.compare})
      : super(compare: compare);

  @override
  Widget build(BuildContext context) {
    return BaseCardWidget(
      child: GestureDetector(
        child: Container(
          child: MessageTile(message),
        ),
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
              builder: (context) =>
                  MessageView([message], this.updateCallback)));
        },
      ),
    );
  }
}
