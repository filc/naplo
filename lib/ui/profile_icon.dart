import 'dart:io';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/utils/colors.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:google_fonts/google_fonts.dart';
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
    Color color = TinyColor(stringToColor(name))
        .desaturate(12)
        .brighten(5)
        .lighten(10)
        .spin(64)
        .color;

    return image == "" || image == null
        ? name != null
            ? name.toLowerCase() != "rendszerüzenet"
                ? Container(
                    width: 44.0 * size,
                    height: 44.0 * size,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        capital(name[0]),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 24.0 * size,
                          fontWeight: FontWeight.w900,
                          color: textColor(color),
                        ),
                      ),
                    ),
                  )
                : Container(
                    width: 44.0 * size,
                    height: 44.0 * size,
                    padding: EdgeInsets.only(top: 3.0 * size),
                    decoration: BoxDecoration(
                      color: Colors.red[400],
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      "!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.righteous(
                        decoration: TextDecoration.none,
                        color: Colors.white,
                        fontSize: 32.0 * size,
                        height: 1.2,
                      ),
                    ),
                  )
            : Padding(
                padding: EdgeInsets.all(6.0),
                child: Icon(FeatherIcons.user, size: 26 * size),
              )
        : Container(
            width: 44.0 * size,
            height: 44.0 * size,
            child: ClipOval(
              child: Image.file(
                File(
                  path.join(app.appDataPath + "profile_" + image + ".jpg"),
                ),
              ),
            ),
          );
  }
}
