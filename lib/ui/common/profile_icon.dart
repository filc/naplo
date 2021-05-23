import 'dart:io';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/utils/colors.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:path/path.dart' as path;
import 'package:tinycolor/tinycolor.dart';

class ProfileIcon extends StatelessWidget {
  final String name;
  final double size;
  final Color? color;
  final String image;

  ProfileIcon({required this.name, this.color, this.size = 1, this.image = ""});

  @override
  Widget build(BuildContext context) {
    Color background;
    String text;

    background = color ??
        TinyColor(stringToColor(name))
            .desaturate(12)
            .brighten(5)
            .lighten(10)
            .spin(64)
            .color;

    if (name.toLowerCase() == "rendszerüzenet") {
      text = "!";
      background = Colors.red;
    } else {
      text = name != "" ? name[0] : "";
    }

    return CircleAvatar(
      radius: size * 24,
      child: image == ""
          ? text != ""
              ? Text(
                  text.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: size * 26,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                )
              : Icon(FeatherIcons.user, color: Colors.grey)
          : null,
      foregroundColor: textColor(background),
      backgroundColor:
          (image == "") && text != "" ? background : Colors.transparent,
      backgroundImage: image != ""
          ? FileImage(
              File(
                path.join(app.appDataPath! + "profile_" + image + ".jpg"),
              ),
            )
          : null,
    );
  }
}
