import 'package:filcnaplo/data/context/theme.dart';
import 'package:filcnaplo/data/models/supporter.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:flutter/material.dart';

class SupporterTile extends StatelessWidget {
  final Supporter supporter;

  SupporterTile(this.supporter);

  @override
  Widget build(BuildContext context) {
    Color color = Colors.grey;
    String suffix = "";

    switch (supporter.platform) {
      case "patreon":
        color = Color(0xFFE7513B);
        suffix = "/ " + I18n.of(context).dateMonth.substring(0, 2);
        break;
      // case "twitch":
      //   color = Color(0xFFA66BFF);
      //   suffix = "/ " + I18n.of(context).dateMonth.substring(0, 2);
      //   break;
      case "donate":
        color = ThemeContext.colors["default"];
        break;
    }

    return Container(
      child: ListTile(
        leading: Container(
          width: 16.0,
          alignment: Alignment.centerLeft,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            width: 16.0,
            height: 16.0,
          ),
        ),
        title: Text(
          supporter.name,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(supporter.amount + " " + suffix),
      ),
    );
  }
}
