import 'package:filcnaplo/data/context/app.dart';
import 'package:flutter/material.dart';

Widget customChip({
  IconData iconData,
  String textString,
  Function onTap,
  Function onLongPress,
  Color color,
}) {
  color ??= app.settings.theme.accentColor;
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
        children: <Widget>[
          iconData != null
              ? Icon(
                  iconData,
                  size: 14,
                  color: color,
                )
              : Container(),
          (textString != null && iconData != null)
              ? SizedBox(width: 4)
              : Container(),
          textString != null
              ? Flexible(
                  child: Text(
                    textString,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: color),
                  ),
                )
              : Container(),
        ],
      ),
    ),
    onTap: onTap,
    onLongPress: onLongPress,
  );
}
