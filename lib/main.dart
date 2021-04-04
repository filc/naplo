import 'dart:convert';

import 'package:filcnaplo/data/models/config.dart';
import 'package:filcnaplo/helpers/settings.dart';
import 'package:filcnaplo/ui/pages/welcome/page.dart';
import 'package:filcnaplo/utils/colors.dart';
import 'package:filcnaplo/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:package_info/package_info.dart';

import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/utils/format.dart';

import 'package:filcnaplo/ui/pages/frame.dart';
import 'package:filcnaplo/ui/pages/login/page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  app.currentAppVersion = packageInfo.version;

  await app.storage.init();
  Map<String, dynamic> settings;

  bool migrationRequired = false;
  Map<String, dynamic> settingsCopy;

  try {
    settings = (await app.storage.storage.query("settings"))[0];
    List<String> addedDBKeys = [
      "default_page",
      "config",
      "news_show",
      "notificationMask",
      "news_len",
      "round_up"
    ];

    migrationRequired = addedDBKeys.any((key) =>
        !settings.containsKey(key) || settings[key].toString() == 'null');

    if (migrationRequired) {
      // settings is immutable, see https://github.com/tekartik/sqflite/issues/140
      settingsCopy = Map<String, dynamic>.from(settings);
      var checker = SettingsHelper(settings: settingsCopy);
      settingsCopy["default_page"] = checker.checkDBkey("default_page", 0);
      settingsCopy["config"] =
          checker.checkDBkey("config", jsonEncode(Config.defaults.json));
      settingsCopy["news_len"] = checker.checkDBkey("news_len", 0);
      settingsCopy["news_show"] = checker.checkDBkey("news_show", 1);
      settingsCopy["notificationMask"] =
          checker.checkDBkey("notificationMask", 1022);
      settingsCopy["round_up"] = checker.checkDBkey("round_up", 5);
      await app.storage.storage.execute("drop table settings");
      try {
        await app.storage.storage.execute("drop table tabs");
      } catch (_) {}
      await app.storage.createSettingsTable(app.storage.storage);
      await app.storage.storage.insert("settings", settingsCopy);
      print("INFO: Database migrated");
    }
  } catch (error) {
    print("[WARN] main: (probably normal) " + error.toString());
    await app.storage.create();
    app.firstStart = true;
  }
  await app.settings.update(
      login: false, settings: migrationRequired ? settingsCopy : settings);

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final i18n = I18n.delegate;

  @override
  void initState() {
    super.initState();
    I18n.onLocaleChanged = onLocaleChange;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor:
          app.settings.theme.bottomNavigationBarTheme.backgroundColor,
      systemNavigationBarIconBrightness:
          invertBrightness(app.settings.theme.brightness),
    ));
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      I18n.locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    I18n.onLocaleChanged(languages[app.settings.language]);

    app.platform = getPlatform(context);

    return DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => app.settings.theme,
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          localizationsDelegates: [
            i18n,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          debugShowCheckedModeBanner: false,
          supportedLocales: i18n.supportedLocales,
          localeResolutionCallback: (device, supported) {
            if (device != null && app.settings.language == "auto") {
              I18n.locale = device;
              app.settings.deviceLanguage = device.toString();
              app.settings.language = device.toString();

              if (!['hu_HU', 'en_US', 'de_DE']
                  .contains(app.settings.deviceLanguage))
                app.settings.deviceLanguage = "en_US";
            }

            return i18n.resolution(fallback: Locale("hu", "HU"))(
                device, supported);
          },
          onGenerateTitle: (BuildContext context) => I18n.of(context).appTitle,
          title: 'Filc Napló',
          theme: theme,
          home: app.firstStart
              ? WelcomePage()
              : app.users.length > 0
                  ? PageFrame()
                  : LoginPage(),
        );
      },
    );
  }
}
