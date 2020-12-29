import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:filcnaplo/utils/colors.dart';
import 'package:filcnaplo/data/context/theme.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class AppearanceSettings extends StatefulWidget {
  @override
  _AppearanceSettingsState createState() => _AppearanceSettingsState();
}

class _AppearanceSettingsState extends State<AppearanceSettings>
    with SingleTickerProviderStateMixin {
  _AppearanceSettingsState();

  GlobalKey _lightKey = GlobalKey();
  GlobalKey _tintedKey = GlobalKey();
  GlobalKey _darkKey = GlobalKey();
  GlobalKey _blackKey = GlobalKey();

  void setTheme(String theme) {
    Color systemNavigationBarColor;
    Brightness systemNavigationBarIconBrightness;
    Map<String, dynamic> settings;
    ThemeData themeData;

    switch (theme) {
      case "light":
        systemNavigationBarColor = Colors.grey[200];
        systemNavigationBarIconBrightness = Brightness.dark;
        settings = <String, dynamic>{"theme": "light"};
        themeData = ThemeContext().light(app.settings.appColor);
        break;
      case "tinted":
        systemNavigationBarColor = Color(0xFF101C19);
        systemNavigationBarIconBrightness = Brightness.light;
        settings = <String, dynamic>{
          "theme": "tinted",
          "app_color": "default",
        };
        app.settings.appColor = Colors.teal[600];
        themeData = ThemeContext().tinted();
        break;
      case "dark":
        systemNavigationBarColor = Color(0xFF18191c);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            CupertinoScrollbar(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  AppBar(
                    leading: BackButton(),
                    centerTitle: true,
                    title: Text(
                      I18n.of(context).settingsAppearanceTitle,
                      style: TextStyle(fontSize: 18.0),
                    ),
                    shadowColor: Colors.transparent,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  ),

                  // Theme Title
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      I18n.of(context).settingsAppearanceTheme.toUpperCase(),
                      style: TextStyle(
                        fontSize: 15.0,
                        letterSpacing: .7,
                      ),
                    ),
                  ),

                  // Theme
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      // Light theme
                      GestureDetector(
                        key: _lightKey,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: 42.0,
                              width: 42.0,
                              margin: EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            app.settings.theme.brightness == Brightness.light
                                ? Container(
                                    height: 64.0,
                                    width: 64.0,
                                    alignment: Alignment.center,
                                    child: Icon(
                                      FeatherIcons.check,
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                        onTap: () => setTheme("light"),
                      ),

                      // Tinted Theme
                      GestureDetector(
                        key: _tintedKey,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: 42.0,
                              width: 42.0,
                              margin: EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: Colors.teal,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            app.settings.theme.backgroundColor.value ==
                                    ThemeContext()
                                        .tinted()
                                        .backgroundColor
                                        .value
                                ? Container(
                                    height: 64.0,
                                    width: 64.0,
                                    alignment: Alignment.center,
                                    child: Icon(FeatherIcons.check),
                                  )
                                : Container(),
                          ],
                        ),
                        onTap: () => setTheme("tinted"),
                      ),

                      // Dark Theme
                      GestureDetector(
                        key: _darkKey,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: 42.0,
                              width: 42.0,
                              margin: EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[700],
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            app.settings.theme.backgroundColor.value !=
                                        ThemeContext()
                                            .tinted()
                                            .backgroundColor
                                            .value &&
                                    app.settings.theme.brightness ==
                                        Brightness.dark &&
                                    app.settings.backgroundColor == 1
                                ? Container(
                                    height: 64.0,
                                    width: 64.0,
                                    alignment: Alignment.center,
                                    child: Icon(FeatherIcons.check),
                                  )
                                : Container(),
                          ],
                        ),
                        onTap: () => setTheme("dark"),
                      ),

                      // Black theme
                      GestureDetector(
                        key: _blackKey,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: 42.0,
                              width: 42.0,
                              margin: EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            app.settings.theme.backgroundColor.value !=
                                        ThemeContext()
                                            .tinted()
                                            .backgroundColor
                                            .value &&
                                    app.settings.theme.brightness ==
                                        Brightness.dark &&
                                    app.settings.backgroundColor == 0
                                ? Container(
                                    height: 64.0,
                                    width: 64.0,
                                    alignment: Alignment.center,
                                    child: Icon(FeatherIcons.check),
                                  )
                                : Container(),
                          ],
                        ),
                        onTap: () => setTheme("black"),
                      ),
                    ],
                  ),

                  // App Color

                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      I18n.of(context).settingsAppearanceColor.toUpperCase(),
                      style: TextStyle(
                        fontSize: 15.0,
                        letterSpacing: .7,
                      ),
                    ),
                  ),

                  Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.spaceEvenly,
                    children: () {
                      List<Widget> colorButtons = [];

                      for (int i = 0;
                          i < ThemeContext.colors.values.toList().length;
                          i++) {
                        Color color = ThemeContext.colors.values.toList()[i];

                        colorButtons.add(GestureDetector(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height: 32.0,
                                width: 32.0,
                                margin: EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(99.0),
                                ),
                              ),
                              Theme.of(context).accentColor == color
                                  ? Container(
                                      alignment: Alignment.center,
                                      width: 56.0,
                                      height: 56.0,
                                      child: Container(
                                        width: 24.0,
                                        height: 24.0,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: app.settings.theme
                                              .scaffoldBackgroundColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Container(
                                          width: 18.0,
                                          height: 18.0,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: color,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 0,
                                      height: 0,
                                    ),
                            ],
                          ),
                          onTap: () {
                            setState(() {
                              if (Theme.of(context).backgroundColor.value ==
                                  ThemeContext().tinted().backgroundColor.value)
                                return;

                              app.settings.appColor = color;

                              if (Theme.of(context).brightness ==
                                  Brightness.light)
                                app.settings.theme =
                                    ThemeContext().light(app.settings.appColor);
                              else
                                app.settings.theme = ThemeContext().dark(
                                    app.settings.appColor,
                                    app.settings.backgroundColor);

                              DynamicTheme.of(context)
                                  .setThemeData(app.settings.theme);
                            });

                            app.storage.storage.update("settings", {
                              "app_color": ThemeContext.colors.keys.toList()[i],
                            });

                            app.storage.storage.update("settings", {
                              "theme": Theme.of(context).brightness ==
                                      Brightness.light
                                  ? "light"
                                  : "dark",
                            });
                          },
                        ));
                      }

                      // add ghost buttons to pad alignment
                      for (int i = 0; i < 3; i++) {
                        colorButtons.add(SizedBox(height: 56.0, width: 56.0));
                      }

                      return colorButtons;
                    }(),
                  ),

                  // Evaluation Colors

                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      I18n.of(context)
                          .settingsAppearanceEvalColors
                          .toUpperCase(),
                      style: TextStyle(
                        fontSize: 15.0,
                        letterSpacing: .7,
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        EvaluationColor(5, onChanged: changeColor),
                        EvaluationColor(4, onChanged: changeColor),
                        EvaluationColor(3, onChanged: changeColor),
                        EvaluationColor(2, onChanged: changeColor),
                        EvaluationColor(1, onChanged: changeColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void changeColor(Color color, int value) {
    setState(() => app.theme.evalColors[value] = color);

    app.storage.storage.update("eval_colors", {
      "color" + (value + 1).toString():
          "#" + color.toString().substring(10, 16),
    });

    DynamicTheme.of(context).setThemeData(app.settings.theme);
  }
}

class EvaluationColor extends StatelessWidget {
  final int value;
  final Function onChanged;

  EvaluationColor(this.value, {this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 46.0,
        height: 46.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: app.theme.evalColors[value - 1],
        ),
        child: Container(
          alignment: Alignment.center,
          child: Text(
            value.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "GoogleSans",
              fontSize: 32.0,
              height: 1.2,
              fontWeight: FontWeight.w500,
              color: textColor(app.theme.evalColors[value - 1]),
            ),
          ),
        ),
      ),
      onTap: () {
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
            actions: <Widget>[
              FlatButton(
                child: Text(
                  I18n.of(context).dialogOk,
                  style: TextStyle(color: Theme.of(context).accentColor),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
