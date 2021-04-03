import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  final String text;

  Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      child: Text(
        capital(text),
        style: TextStyle(
          fontSize: 15.0,
          letterSpacing: .7,
          fontWeight: FontWeight.bold,
          color: app.settings.appColor,
        ),
      ),
    );
  }
}
