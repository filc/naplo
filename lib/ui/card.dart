import 'package:filcnaplo/data/context/app.dart';
import 'package:flutter/material.dart';

class BaseCard extends StatelessWidget {
  final Widget child;
  final Key key;
  final EdgeInsetsGeometry padding;
  final DateTime compare;

  BaseCard({this.child, this.key, this.padding, this.compare});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(18.0, 0, 18.0, 12.0),
      padding: padding ?? EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: app.settings.theme.backgroundColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: app.settings.theme.brightness == Brightness.dark
            ? null
            : [BoxShadow(color: Colors.grey[300], blurRadius: 6.0)],
      ),
      child: child,
    );
  }
}
