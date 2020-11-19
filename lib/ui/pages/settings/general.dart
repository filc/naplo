import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:flutter/material.dart';

class GeneralSettings extends StatefulWidget {
  @override
  _GeneralSettingsState createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  Map<String, String> languages = {
    "en_US": "English",
    "de_DE": "Deutsch",
    "hu_HU": "Magyar",
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
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AppBar(
              centerTitle: true,
              leading: BackButton(),
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
                          child: Text(languages[value],
                              textAlign: TextAlign.right),
                        ))
                    .toList(),
                onChanged: (String language) {
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
                },
              ),
            ),

            // Default Page
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                I18n.of(context).settingsGeneralStartPage.toUpperCase(),
                style: TextStyle(
                  fontSize: 15.0,
                  letterSpacing: .7,
                ),
              ),
            ),

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
                    ),
                  );
                }

                return items;
              }(),
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
