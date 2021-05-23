import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/helpers/averages.dart';
import 'package:filcnaplo/ui/common/label.dart';
import 'package:filcnaplo/utils/colors.dart';
import 'package:flutter/material.dart';

class GeneralSettings extends StatefulWidget {
  @override
  _GeneralSettingsState createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  Map<String, String> languages = {
    "en_US": "🇬🇧  English",
    "de_DE": "🇩🇪  Deutsch",
    "hu_HU": "🇭🇺  Magyar",
  };

  @override
  Widget build(BuildContext context) {
    List<IconData> pages = [
      FeatherIcons.search,
      FeatherIcons.bookmark,
      FeatherIcons.calendar,
      FeatherIcons.messageSquare,
      FeatherIcons.clock,
    ];
    List<String> pageNames = [
      I18n.of(context).homepage,
      I18n.of(context).evaluationTitle,
      I18n.of(context).plannerTitle,
      I18n.of(context).messageTitle,
      I18n.of(context).aboutTitle,
    ];
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              centerTitle: true,
              leading: BackButton(color: app.settings.appColor),
              title: Text(I18n.of(context).settingsGeneralTitle),
              shadowColor: Colors.transparent,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            ListTile(
              leading: Icon(FeatherIcons.globe),
              title: Text(I18n.of(context).settingsGeneralLanguage),
              trailing: DropdownButton(
                underline: Container(),
                value:
                    ['hu_HU', 'en_US', 'de_DE'].contains(app.settings.language)
                        ? app.settings.language
                        : app.settings.deviceLanguage,
                items: ['hu_HU', 'en_US', 'de_DE']
                    .map((String value) => DropdownMenuItem(
                          value: value,
                          child: Text(languages[value]!,
                              textAlign: TextAlign.right),
                        ))
                    .toList(),
                onChanged: (String? language) {
                  if (language != null) {
                    setState(() {
                      app.settings.language = language;
                      I18n.onLocaleChanged(Locale(
                        language.split("_")[0],
                        language.split("_")[1],
                      ));
                    });

                    app.storage.storage.update("settings", {
                      "language": language,
                    });
                  }
                },
              ),
            ),

            // Default Page
            Label(I18n.of(context).settingsGeneralStartPage),

            Row(
              children: () {
                List<Widget> items = [];

                for (int i = 0; i < pages.length; i++) {
                  items.add(
                    IconButton(
                      color: app.settings.defaultPage == i
                          ? app.settings.appColor
                          : null,
                      icon: Icon(pages[i]),
                      onPressed: () => _defaultPage(i),
                      tooltip: pageNames[i],
                    ),
                  );
                }

                return items;
              }(),
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),

            // Default Page
            Label(I18n.of(context).settingsGeneralRound),

            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(45.0)),
                        color: app.theme.evalColors[
                            (3 + (app.settings.roundUp / 10)).floor() - 1],
                      ),
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        app.settings.language.split("_")[0] == "en"
                            ? (3 + (app.settings.roundUp / 10))
                                .toStringAsFixed(1)
                            : (3 + (app.settings.roundUp / 10))
                                .toStringAsFixed(1)
                                .split(".")
                                .join(","),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                          fontSize: 18.0,
                          color: textColor(
                            app.theme.evalColors[
                                (3 + (app.settings.roundUp / 10)).floor() - 1],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Icon(FeatherIcons.arrowRight),
                    ),
                    Container(
                      width: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(45.0)),
                        color: getAverageColor(3 + (app.settings.roundUp / 10)),
                      ),
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        app.settings.language.split("_")[0] == "en"
                            ? roundSubjAvg(3 + (app.settings.roundUp / 10))
                                .toStringAsFixed(1)
                            : roundSubjAvg(3 + (app.settings.roundUp / 10))
                                .toStringAsFixed(1)
                                .split(".")
                                .join(","),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                          fontSize: 18.0,
                          color: textColor(
                              getAverageColor(3 + (app.settings.roundUp / 10))),
                        ),
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: app.settings.roundUp.toDouble(),
                  divisions: 8,
                  min: 1.0,
                  max: 9.0,
                  onChanged: (roundUp) {
                    setState(() => app.settings.roundUp = roundUp.toInt());
                    app.storage.storage
                        .update("settings", {"round_up": roundUp.toInt()});
                  },
                  activeColor: app.settings.appColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _defaultPage(int newDefaultPage) {
    setState(() {
      app.settings.defaultPage = newDefaultPage;
    });
    app.storage.storage.update("settings", {"default_page": newDefaultPage});
  }
}
