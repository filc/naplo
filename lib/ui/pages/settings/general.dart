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

  List<String> pages = [
    "Főoldal",
    "Jegyek",
    "Tervező",
    "Üzenetek",
    "Hiányzások"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
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
              title: Text("Kezdőoldal"),
              trailing: DropdownButton(
                underline: Container(),
                value: app.settings.defaultPage,
                items: [0, 1, 2, 3, 4].map((int value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(pages[value]),
                  );
                }).toList(),
                onChanged: (int newDefaultPage) {
                  setState(() {
                    app.settings.defaultPage = newDefaultPage;
                  });
                  app.storage.storage
                      .update("settings", {"default_page": newDefaultPage});
                },
              ),
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
                items: ['hu_HU', 'en_US', 'de_DE'].map((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(languages[value]),
                  );
                }).toList(),
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
          ],
        ),
      ),
    );
  }
}
