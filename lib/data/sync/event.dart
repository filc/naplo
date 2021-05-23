import 'dart:convert';

import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/dummy.dart';
import 'package:filcnaplo/data/models/event.dart';

class EventSync {
  List<Event> events = [];
  bool uiPending = true;

  Future<bool> sync() async {
    if (!app.debugUser) {
      List<Event>? _events;
      _events = await app.user.kreta.getEvents();

      if (_events == null) {
        await app.user.kreta.refreshLogin();
        _events = await app.user.kreta.getEvents();
      }

      if (_events != null) {
        events = _events;

        await app.user.storage.delete("kreta_events");

        await Future.forEach(_events, (Event event) async {
          if (event.json != null) {
            await app.user.storage.insert("kreta_events", {
              "json": jsonEncode(event.json),
            });
          }
        });
      }

      uiPending = true;

      return _events != null;
    } else {
      events = Dummy.events;
      return true;
    }
  }

  delete() {
    events = [];
  }
}
