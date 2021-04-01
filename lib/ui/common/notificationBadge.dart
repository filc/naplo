import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 29,
      top: 4,
      child: Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(45),
            color: Theme.of(context).accentColor,
            border: Border.all(
                color: Theme.of(context).scaffoldBackgroundColor, width: 2.2)),
      ),
    );
  }
}
