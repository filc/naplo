import 'dart:convert';

import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/note.dart';
import 'package:filcnaplo/data/models/dummy.dart';

class NoteSync {
  List<Note> notes = [];
  bool uiPending = true;

  Future<bool> sync() async {
    if (!app.debugUser) {
      List<Note>? _notes;
      _notes = await app.user.kreta.getNotes();

      if (_notes == null) {
        await app.user.kreta.refreshLogin();
        _notes = await app.user.kreta.getNotes();
      }

      if (_notes != null) {
        notes = _notes;

        await app.user.storage.delete("kreta_notes");

        await Future.forEach(_notes, (Note note) async {
          if (note.json != null) {
            await app.user.storage.insert("kreta_notes", {
              "json": jsonEncode(note.json),
            });
          }
        });
      }

      uiPending = true;

      return _notes != null;
    } else {
      notes = Dummy.notes;
      return true;
    }
  }

  delete() {
    notes = [];
  }
}
