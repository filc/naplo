import 'package:filcnaplo/ui/pages/messages/event/tile.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/event.dart';

class EventBuilder {
  List<EventTile> eventTiles = [];

  void build() {
    eventTiles = [];
    List<Event> events = app.user.sync.event.data;

    events.sort(
      (a, b) => -a.start.compareTo(b.start),
    );

    events.forEach((event) => eventTiles.add(EventTile(event)));
  }
}
