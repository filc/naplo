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
      margin: EdgeInsets.only(left: 6.0, right: 14.0),
      padding: padding ?? EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        // color: app.settings.theme.backgroundColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: child,
    );
  }
}
