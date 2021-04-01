import 'package:flutter/material.dart';

class ThemeContext {
  static final Map<String, Color> colors = {
    "blue": Colors.blue[200],
    "default": Color(0xFF6bc2b9),
    "green": Colors.green[200],
    "lime": Colors.lime[200],
    "yellow": Colors.yellow[200],
    "orange": Colors.deepOrange[200],
    "red": Colors.red[200],
    "pink": Colors.pink[200],
    "purple": Colors.purple[200],
  };

  static const Color filcGreen = Color(0xFF236A5B);

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
        scaffoldBackgroundColor: Colors.white,
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
        accentColor: colors["default"],
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

  static Color darkBackground = Color(0xff2f3136);
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
