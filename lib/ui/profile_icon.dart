import 'dart:io';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/utils/colors.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:path/path.dart' as path;
import 'package:tinycolor/tinycolor.dart';

class ProfileIcon extends StatelessWidget {
  final String name;
  final double size;
  final Color color;
  final String image;

  ProfileIcon({this.name, this.color, this.size = 1, this.image = ""});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;

    if (name != null) {
      color = TinyColor(stringToColor(name))
          .desaturate(12)
          .brighten(5)
          .lighten(10)
          .spin(64)
          .color;
    } else {
      color = Colors.grey;
    }

    if ((name ?? "").toLowerCase() == "rendszerüzenet") {
      text = "!";
      color = Colors.red;
    } else {
      text = name != null && name != "" ? name[0] : "";
    }

    return CircleAvatar(
      radius: size * 24,
      child: image == null || image == ""
          ? name != null && text != ""
              ? Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: size * 26,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                )
              : Icon(FeatherIcons.user, color: Colors.grey)
          : null,
      foregroundColor: textColor(color),
      backgroundColor: name != null && text != "" ? color : Colors.transparent,
      backgroundImage: image != null && image != ""
          ? FileImage(
              File(
                path.join(app.appDataPath + "profile_" + image + ".jpg"),
              ),
            )
          : null,
    );
  }
}
