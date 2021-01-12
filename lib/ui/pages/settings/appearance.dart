import 'package:filcnaplo/helpers/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:filcnaplo/utils/colors.dart';
import 'package:filcnaplo/data/context/theme.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';

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

  List<Widget> colorButtons = [];

  @override
  Widget build(BuildContext context) {
    colorButtons = [];
    for (int i = 0; i < ThemeContext.colors.values.toList().length; i++) {
      Color color = ThemeContext.colors.values.toList()[i];

      colorButtons.add(
        GestureDetector(
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
                          color: app.settings.theme.scaffoldBackgroundColor,
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
          onTap: () =>
              SettingsHelper(context: context).setSecondaryColor(color, i),
        ),
      );
    }

    // add ghost buttons to pad alignment
    for (int i = 0; i < 3; i++) {
      colorButtons.add(SizedBox(height: 56.0, width: 56.0));
    }

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
                                color: Colors.white,
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
                        onTap: () =>
                            SettingsHelper(context: context).setTheme("light"),
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
                        onTap: () =>
                            SettingsHelper(context: context).setTheme("tinted"),
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
                        onTap: () =>
                            SettingsHelper(context: context).setTheme("dark"),
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
                                color: Colors.black,
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
                        onTap: () =>
                            SettingsHelper(context: context).setTheme("black"),
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
                    children: colorButtons,
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

  void changeColor(Color color, int value) => setState(
      () => SettingsHelper(context: context).changeColor(color, value));
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
      onTap: () =>
          SettingsHelper(context: context).showColorPicker(value, onChanged),
    );
  }
}
