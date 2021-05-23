import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/utils/colors.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
SnackBar CustomSnackBar({
  required String message,
  Color? color,
  SnackBarAction? action,
  Duration duration = const Duration(seconds: 4),
}) {
  return SnackBar(
    elevation: 0,
    duration: duration,
    padding: EdgeInsets.zero,
    backgroundColor: Colors.transparent,
    content: Container(
      margin: EdgeInsets.all(12.0),
      height: 48.0,
      decoration: BoxDecoration(
        color: color ?? app.settings.theme.backgroundColor,
        boxShadow: [BoxShadow(blurRadius: 8.0, color: Colors.black26)],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                message,
                overflow: TextOverflow.fade,
                maxLines: 2,
                style: TextStyle(
                    color:
                        textColor(color ?? app.settings.theme.backgroundColor)),
              ),
            ),
          ),
          action!
        ],
      ),
    ),
  );
}
