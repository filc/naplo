import 'package:filcnaplo/ui/pages/messages/event/view.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/data/models/event.dart';

class EventTile extends StatelessWidget {
  final Event event;

  EventTile(this.event);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        title: Row(children: [
          Expanded(
            child: Text(event.title, overflow: TextOverflow.ellipsis),
          ),
          Text(formatDate(context, event.start)),
        ]),
        subtitle: Text(
          escapeHtml(event.content),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () => showModalBottomSheet(
          context: context,
          builder: (context) => EventView(event),
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          useRootNavigator: true,
        ),
      ),
    );
  }
}
