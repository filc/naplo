import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tinycolor/tinycolor.dart';

class SettingTile extends StatelessWidget {
  final String title;
  final String description;
  final Color color;
  final IconData icon;
  final Widget page;

  SettingTile({this.title, this.icon, this.page, this.color, this.description});

  @override
  Widget build(BuildContext context) {
    dynamic accentColor = TinyColor(color).spin(-20).saturate(10);

    if (Theme.of(context).brightness == Brightness.light) {
      accentColor = accentColor.darken(10);
    }

    accentColor = accentColor.color;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: MaterialButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: ListTile(
            contentPadding: EdgeInsets.only(left: 0.0),
            title: Text(capital(title)),
            leading: Container(
              height: 42.0,
              width: 42.0,
              decoration: BoxDecoration(
                color: Color.fromARGB(
                  Theme.of(context).brightness == Brightness.light ? 60 : 30,
                  accentColor.red,
                  accentColor.green,
                  accentColor.blue,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accentColor, size: 26),
            ),
            subtitle: Text(description)),
        onPressed: () {
          Navigator.push(
              context, CupertinoPageRoute(builder: (context) => page));
        },
      ),
    );
  }
}
