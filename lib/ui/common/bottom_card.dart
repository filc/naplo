import 'package:filcnaplo/data/context/app.dart';
import 'package:flutter/material.dart';

class BottomCard extends StatelessWidget {
  final Widget child;

  BottomCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 16.0),
      padding: EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 14.0),
      decoration: BoxDecoration(
        color: app.settings.theme.backgroundColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: child,
    );
  }
}
