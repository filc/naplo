import 'dart:convert';

import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/note.dart';
import 'package:filcnaplo/data/models/dummy.dart';
import 'package:flutter/material.dart';

class NoteSync {
  List<Note> notes = [];
  Key key;

  Future<bool> sync() async {
    if (!app.debugUser) {
      List<Note> _notes;
      _notes = await app.user.kreta.getNotes();

      if (_notes == null) {
        await app.user.kreta.refreshLogin();
        _notes = await app.user.kreta.getNotes();
      }

      if (_notes != null) {
        notes = _notes;

        await app.user.storage.delete("kreta_notes");

        await Future.forEach(_notes, (note) async {
          if (note.json != null) {
            await app.user.storage.insert("kreta_notes", {
              "json": jsonEncode(note.json),
            });
          }
        });
      }

      key = UniqueKey();
      return _notes != null;
    } else {
      notes = Dummy.notes;
      return true;
    }
  }

  delete() {
    notes = [];
  }

  bool match(Key oldKey) {
    return oldKey == key;
  }
}
