import 'dart:convert';

import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/note.dart';
import 'package:filcnaplo/data/models/dummy.dart';

class NoteSync {
  List<Note> data = [];

  Future<bool> sync() async {
    if (!app.debugUser) {
      List<Note> notes;
      notes = await app.user.kreta.getNotes();

      if (notes == null) {
        await app.user.kreta.refreshLogin();
        notes = await app.user.kreta.getNotes();
      }

      if (notes != null) {
        data = notes;

        await app.user.storage.delete("kreta_notes");

        await Future.forEach(notes, (note) async {
          if (note.json != null) {
            await app.user.storage.insert("kreta_notes", {
              "json": jsonEncode(note.json),
            });
          }
        });
      }
      
      return notes != null;
    } else {
      data = Dummy.notes;
      return true;
    }
  }

  delete() {
    data = [];
  }
}
