import 'package:filcnaplo/helpers/settings.dart';
import 'package:filcnaplo/ui/common/label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:filcnaplo/utils/colors.dart';
import 'package:filcnaplo/data/context/theme.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:tinycolor/tinycolor.dart';

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

      Color displayColor = TinyColor(color).darken(15).color;

      colorButtons.add(
        GestureDetector(
          child: Stack(
            children: [
              Container(
                height: 32.0,
                width: 32.0,
                margin: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: displayColor,
                  borderRadius: BorderRadius.circular(99.0),
                ),
              ),
              app.settings.rawAppColor == color
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
                            color: displayColor,
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
    for (int i = 0; i < 5; i++) {
      colorButtons.add(SizedBox(height: 56.0, width: 56.0));
    }

    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            CupertinoScrollbar(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  AppBar(
                    leading: BackButton(color: app.settings.appColor),
                    centerTitle: true,
                    title: Text(
                      I18n.of(context).settingsAppearanceTitle,
                      style: TextStyle(fontSize: 18.0),
                    ),
                    shadowColor: Colors.transparent,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  ),

                  // Theme Title
                  Label(I18n.of(context).settingsAppearanceTheme),

                  // Theme
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Light theme
                      GestureDetector(
                        key: _lightKey,
                        child: Stack(
                          children: [
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
                          children: [
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
                          children: [
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
                          children: [
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

                  Label(I18n.of(context).settingsAppearanceColor),

                  Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.spaceEvenly,
                    children: colorButtons,
                  ),

                  // Evaluation Colors

                  Label(I18n.of(context).settingsAppearanceEvalColors),

                  Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
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
  final Function(Color, int)? onChanged;

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
