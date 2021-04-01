import 'package:flutter/material.dart';

class Searchable {
  String text;
  Widget child;
  DateTime date;

  Searchable({
    @required this.text,
    @required this.child,
    @required this.date,
  });
}
