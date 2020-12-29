import 'package:flutter/material.dart';

class ThemeContext {
  static final Map<String, Color> colors = {
    "blue": Color(0xFF44c0f0),
    "default": Color(0xFF00bc9d),
    "green": Color(0xFF4aad0f),
    "lime": Color(0xFF7fd21e),
    "yellow": Color(0xFFffe934),
    "orange": Color(0xFFffa400),
    "red": Color(0xFFf45937),
    "pink": Color(0xFFff34a8),
    "purple": Color(0xFFd163ff),
  };

  List<Color> evalColors = [
    Colors.red,
    Colors.amber[700],
    Colors.yellow[600],
    Colors.lightGreen,
    Colors.green[600],
  ];

  static Color lightTextColor = Colors.grey[700];
  static TextTheme lightText = TextTheme(
    headline6: TextStyle(
      fontFamily: "GoogleSans",
      color: lightTextColor,
      fontSize: 20.0,
    ),
    bodyText1: TextStyle(
      fontFamily: "GoogleSans",
      color: lightTextColor,
    ),
    bodyText2: TextStyle(
      fontFamily: "GoogleSans",
      color: lightTextColor,
    ),
  );

  static Color lightBackground = Colors.white;

  // ThemeContext().tinted().backgroundColor.value
  //         ? Color(0xFF101C19)
  //         : app.settings.theme.brightness == Brightness.dark
  //             ? app.settings.backgroundColor == 0
  //                 ? Colors.black
  //                 : Color(0xff18191c)
  //             : Colors.white,

  ThemeData light(Color appColor) => ThemeData(
        brightness: Brightness.light,
        accentColor: appColor,
        backgroundColor: lightBackground,
        textTheme: lightText,
        primaryTextTheme: lightText,
        iconTheme: IconThemeData(color: lightTextColor),
        fontFamily: "GoogleSans",
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.grey[200],
          actionTextColor: appColor,
          contentTextStyle: TextStyle(color: lightTextColor),
        ),
        dialogBackgroundColor: lightBackground,
        appBarTheme: AppBarTheme(
            color: Colors.white,
            textTheme: lightText,
            iconTheme: IconThemeData(color: lightTextColor)),
        bottomNavigationBarTheme:
            BottomNavigationBarThemeData(backgroundColor: Colors.white),
      );

  ThemeData tinted() => ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.teal[600],
        backgroundColor: Color(0xFF1c2d2a),
        scaffoldBackgroundColor: Color(0xFF1c2d2a),
        textTheme: darkText,
        iconTheme: IconThemeData(color: darkTextColor),
        fontFamily: "GoogleSans",
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Color(0xFF273d38),
          actionTextColor: Colors.teal[600],
          contentTextStyle: TextStyle(color: darkTextColor),
        ),
        dialogBackgroundColor: Color(0xFF273d38),
        appBarTheme: AppBarTheme(
            color: Color(0xFF273d38),
            textTheme: darkText,
            iconTheme: IconThemeData(color: darkTextColor)),
        bottomNavigationBarTheme:
            BottomNavigationBarThemeData(backgroundColor: Color(0xFF1c2d2a)),
      );

  static Color darkTextColor = Colors.grey[100];
  static TextTheme darkText = TextTheme(
      headline6: TextStyle(
          fontFamily: "GoogleSans", color: darkTextColor, fontSize: 20.0),
      bodyText1: TextStyle(fontFamily: "GoogleSans", color: darkTextColor),
      bodyText2: TextStyle(fontFamily: "GoogleSans", color: darkTextColor));

  static Color darkBackground = Color(0xff36393f);
  static Color blackBackground = Color(0xff18191c);

  ThemeData dark(Color appColor, int backgroundColor) => ThemeData(
        brightness: Brightness.dark,
        accentColor: appColor,
        backgroundColor:
            backgroundColor == 0 ? blackBackground : darkBackground,
        textTheme: darkText,
        primaryTextTheme: darkText,
        iconTheme: IconThemeData(color: Colors.grey[100]),
        fontFamily: "GoogleSans",
        scaffoldBackgroundColor:
            backgroundColor == 0 ? Colors.black : Color(0xff202225),
        snackBarTheme: SnackBarThemeData(
          backgroundColor:
              backgroundColor == 0 ? blackBackground : darkBackground,
          actionTextColor: appColor,
          contentTextStyle: TextStyle(color: darkTextColor),
        ),
        dialogBackgroundColor:
            backgroundColor == 0 ? blackBackground : darkBackground,
        appBarTheme: AppBarTheme(
            color: backgroundColor == 0 ? blackBackground : darkBackground,
            textTheme: darkText),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor:
                backgroundColor == 0 ? Colors.black : Color(0xff202225)),
      );
}
