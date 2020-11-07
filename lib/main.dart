import 'package:filcnaplo/data/context/theme.dart';
import 'package:filcnaplo/ui/pages/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:package_info/package_info.dart';

import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/utils/format.dart';

import 'package:filcnaplo/ui/pages/frame.dart';
import 'package:filcnaplo/ui/pages/login.dart';

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
      "evening_start_hour",
      "studying_periods_bitfield"
    ];
    migrationRequired = addedDBKeys.any((item) => !settings.containsKey(item));
    if (migrationRequired) {
      settingsCopy = Map<String, dynamic>.from(
          settings); //settings is immutable, see https://github.com/tekartik/sqflite/issues/140
      settingsCopy["default_page"] = settingsCopy["default_page"] ?? 0;
      settingsCopy["evening_start_hour"] =
          settingsCopy["evening_start_hour"] ?? 18;
      settingsCopy["studying_periods_bitfield"] =
          settingsCopy["studying_periods_bitfield"] ?? 1 << 3 | 1 << 4 | 1 << 5;
      settingsCopy["theme"] =
          SchedulerBinding.instance.window.platformBrightness == Brightness.dark
              ? 'dark'
              : 'light';
      await app.storage.storage.execute("drop table settings");
      await app.storage.createSettingsTable(app.storage.storage);
      await app.storage.storage.insert("settings", settingsCopy);
    }
  } catch (_) {
    await app.storage.create();
    app.firstStart = true;
  }
  await app.settings.update(
      login: false, settings: migrationRequired ? settingsCopy : settings);
  // Set current page to default page
  app.selectedPage = app.settings.defaultPage;
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

    if (app.settings.theme.brightness == Brightness.light) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.grey[200],
        systemNavigationBarIconBrightness: Brightness.dark,
      ));
    }

    if (app.settings.theme.backgroundColor.value ==
        ThemeContext().tinted().backgroundColor.value) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xFF101C19),
        systemNavigationBarIconBrightness: Brightness.light,
      ));
    } else if (app.settings.theme.brightness == Brightness.dark) {
      if (app.settings.backgroundColor == 1) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: Color(0xff18191c),
          systemNavigationBarIconBrightness: Brightness.light,
        ));
      } else {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.light,
        ));
      }
    }
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      I18n.locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    I18n.onLocaleChanged(languages[app.settings.language]);

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
