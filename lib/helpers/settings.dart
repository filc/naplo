import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/context/theme.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class SettingsHelper {
  BuildContext context;
  Map<String, dynamic> settings;

  SettingsHelper({this.context, this.settings});

  void changeColor(Color color, int value) {
    app.theme.evalColors[value] = color;

    app.storage.storage.update("eval_colors", {
      "color" + (value + 1).toString():
          "#" + color.toString().substring(10, 16),
    });

    DynamicTheme.of(context).setThemeData(app.settings.theme);
  }

  void showColorPicker(int value, Function onChanged) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(I18n.of(context).settingsAppearancePickColor),
        content: MaterialColorPicker(
          onColorChange: (Color color) => onChanged(color, value - 1),
          selectedColor: app.theme.evalColors[value - 1],
          circleSize: 54,
          shrinkWrap: true,
        ),
        actions: [
          TextButton(
            child: Text(
              I18n.of(context).dialogOk,
              style: TextStyle(color: app.settings.appColor),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void setTheme(String theme) {
    Color systemNavigationBarColor;
    Brightness systemNavigationBarIconBrightness;
    Map<String, dynamic> settings;
    ThemeData themeData;

    switch (theme) {
      case "light":
        systemNavigationBarColor = Colors.white;
        systemNavigationBarIconBrightness = Brightness.dark;
        settings = <String, dynamic>{"theme": "light"};
        themeData = ThemeContext().light(app.settings.appColor);
        break;
      case "tinted":
        systemNavigationBarColor = Color(0xFF1c2d2a);
        systemNavigationBarIconBrightness = Brightness.light;
        settings = <String, dynamic>{
          "theme": "tinted",
          "app_color": "default",
        };
        app.settings.appColor = Colors.teal[600];
        themeData = ThemeContext().tinted();
        break;
      case "dark":
        systemNavigationBarColor = Color(0xff202225);
        systemNavigationBarIconBrightness = Brightness.light;
        settings = <String, dynamic>{
          "theme": "dark",
          "background_color": 1,
        };
        app.settings.backgroundColor = 1;
        themeData = ThemeContext().dark(app.settings.appColor, 1);
        break;
      case "black":
        systemNavigationBarColor = Colors.black;
        systemNavigationBarIconBrightness = Brightness.light;
        settings = <String, dynamic>{
          "theme": "dark",
          "background_color": 0,
        };
        app.settings.backgroundColor = 0;
        themeData = ThemeContext().dark(app.settings.appColor, 0);
        break;
    }

    app.settings.theme = themeData;

    DynamicTheme.of(context).setThemeData(themeData);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: systemNavigationBarColor,
      systemNavigationBarIconBrightness: systemNavigationBarIconBrightness,
    ));

    app.storage.storage.update("settings", settings);
  }

  void setSecondaryColor(Color color, int i) {
    if (Theme.of(context).backgroundColor.value ==
        ThemeContext().tinted().backgroundColor.value) return;

    app.settings.appColor = color;

    if (Theme.of(context).brightness == Brightness.light)
      app.settings.theme = ThemeContext().light(app.settings.appColor);
    else
      app.settings.theme = ThemeContext()
          .dark(app.settings.appColor, app.settings.backgroundColor);

    DynamicTheme.of(context).setThemeData(app.settings.theme);
    app.storage.storage.update("settings", {
      "app_color": ThemeContext.colors.keys.toList()[i],
    });

    app.storage.storage.update("settings", {
      "theme":
          Theme.of(context).brightness == Brightness.light ? "light" : "dark",
    });
  }

  dynamic checkDBkey(String key, dynamic value) {
    print("INFO: DB Migration: " +
        key +
        ": " +
        settings[key].toString() +
        ", default: " +
        value.toString());

    if (settings[key].toString() == 'null') {
      print("INFO: DB Migration: Resetting " + key);
      return value;
    } else {
      return settings[key];
    }
  }
}
