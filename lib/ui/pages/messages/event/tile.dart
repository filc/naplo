import 'package:filcnaplo/ui/pages/messages/event/view.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/data/models/event.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class EventTile extends StatelessWidget {
  final Event event;

  EventTile(this.event);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        title: Row(children: [
          Expanded(
            child:
                Text(event.title, softWrap: false, overflow: TextOverflow.fade),
          ),
          Text(formatDate(context, event.start)),
        ]),
        subtitle: Text(
          escapeHtml(event.content),
          maxLines: 2,
          softWrap: false,
          overflow: TextOverflow.fade,
        ),
        onTap: () => showSlidingBottomSheet(
          context,
          useRootNavigator: true,
          builder: (BuildContext context) => eventView(event, context),
        ),
      ),
    );
  }
}
