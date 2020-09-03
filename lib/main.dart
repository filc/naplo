import 'package:filcnaplo/data/context/theme.dart';
import 'package:filcnaplo/ui/pages/welcome.dart';
import 'package:flutter/material.dart';
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

  try {
    List<Map<String, dynamic>> settings =
        await app.storage.storage.query("settings");
    if (!settings[0].containsKey("default_page")) {
      await app.storage.storage
          .rawQuery("ALTER TABLE settings ADD COLUMN default_page INTIGER;");
      await app.storage.storage.update("settings", {"default_page": 0});
    }
  } catch (_) {
    await app.storage.create();
    app.firstStart = true;
  }
  
  await app.settings.update(login: false);
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
    }

    if (app.settings.theme.backgroundColor.value !=
            ThemeContext().tinted().backgroundColor.value &&
        app.settings.theme.brightness == Brightness.dark &&
        app.settings.backgroundColor == 1) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xff18191c),
        systemNavigationBarIconBrightness: Brightness.light,
      ));
    }

    if (app.settings.theme.backgroundColor.value !=
            ThemeContext().tinted().backgroundColor.value &&
        app.settings.theme.brightness == Brightness.dark &&
        app.settings.backgroundColor == 0) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ));
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
              : app.users.length > 0 ? PageFrame() : LoginPage(),
        );
      },
    );
  }
}
