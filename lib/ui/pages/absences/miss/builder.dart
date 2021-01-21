import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/note.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/ui/cards/note/tile.dart';

class MissBuilder {
  List<Widget> missTiles = [];
  void build() {
    missTiles = [];
    List<Note> misses = app.user.sync.note.data
        .where((miss) =>
            miss.type.name == "HaziFeladatHiany" ||
            miss.type.name == "Felszereleshiany")
        .toList();

    misses.sort(
      (a, b) => -a.date.compareTo(b.date),
    );

    misses.forEach((miss) => missTiles.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          child: NoteTile(miss),
        )));
  }
}
