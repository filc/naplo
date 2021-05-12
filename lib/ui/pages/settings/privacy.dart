import 'package:filcnaplo/data/context/app.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';

class PrivacySettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            AppBar(
              centerTitle: true,
              leading: BackButton(color: app.settings.appColor),
              title: Text(I18n.of(context).settingsPrivacyTitle),
              shadowColor: Colors.transparent,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            ListTile(
              leading: Icon(FeatherIcons.eye),
              title: Text(I18n.of(context).settingsPrivacySeen),
              trailing: Switch(
                activeColor: app.settings.appColor,
                value: false,
                onChanged: null,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                I18n.of(context).settingsNotImplemented,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
