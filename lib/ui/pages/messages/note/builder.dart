import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/note.dart';
import 'package:filcnaplo/ui/pages/messages/note/tile.dart';

class NoteBuilder {
  List<NoteTile> noteTiles = [];

  void build() {
    noteTiles = [];
    List<Note> notes = app.user.sync.note.data
        .where((miss) =>
            miss.type.name != "HaziFeladatHiany" &&
            miss.type.name != "Felszereleshiany")
        .toList();

    notes.sort(
      (a, b) => -a.date.compareTo(b.date),
    );

    notes.forEach((note) => noteTiles.add(NoteTile(note)));
  }
}
