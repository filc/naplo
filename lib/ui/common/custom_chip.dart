import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final IconData? icon;
  final String text;
  final Function()? onTap;
  final Function()? onLongPress;
  final Color color;

  CustomChip({
    this.icon,
    required this.text,
    this.onTap,
    this.onLongPress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: ShapeDecoration(
          shape: StadiumBorder(
            side: BorderSide(color: color, width: 1.2),
          ),
        ),
        margin: EdgeInsets.only(right: 5.0),
        padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon != null
                ? Icon(
                    icon,
                    size: 14,
                    color: color,
                  )
                : Container(),
            (icon != null) ? SizedBox(width: 4) : Container(),
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.fade,
                style:
                    TextStyle(color: color),
              ),
            ),
          ],
        ),
      ),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
