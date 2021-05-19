import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:filcnaplo/utils/format.dart';

class EvaluationsDial extends StatelessWidget {
  final int selectedOption;
  final bool inverted;
  final Function onSelect;

  EvaluationsDial(this.selectedOption, this.inverted, {this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme:
          IconThemeData(size: 22.0, color: app.settings.appColor),
      marginEnd: 14.0,
      overlayColor: Colors.black,
      overlayOpacity: 0.35,
      tooltip: I18n.of(context).sort,
      backgroundColor: app.settings.theme.backgroundColor,
      children: [
        speedDialButton(
          context,
          selected: selectedOption == 2,
          sortInverted: inverted,
          icon: FeatherIcons.award,
          text: I18n.of(context).evaluationValue,
          onTap: () => onSelect(0),
        ),
        speedDialButton(
          context,
          selected: selectedOption == 1,
          sortInverted: inverted,
          icon: FeatherIcons.edit,
          text: I18n.of(context).evaluationWriteDate,
          onTap: () => onSelect(1),
        ),
        speedDialButton(
          context,
          selected: selectedOption == 0,
          sortInverted: inverted,
          icon: FeatherIcons.clock,
          text: I18n.of(context).evaluationDate,
          onTap: () => onSelect(2),
        ),
      ],
    );
  }
}

SpeedDialChild speedDialButton(
  BuildContext context, {
  bool sortInverted,
  IconData icon,
  String text,
  bool selected,
  Function onTap,
}) {
  return SpeedDialChild(
    child: Row(
      mainAxisAlignment:
          selected ? MainAxisAlignment.start : MainAxisAlignment.center,
      children: [
        selected
            ? Container(
                decoration: BoxDecoration(
                  color: app.settings.theme.backgroundColor,
                  shape: BoxShape.circle,
                ),
                width: 20.0,
                height: 24.0,
                child: Icon(
                  sortInverted
                      ? FeatherIcons.chevronDown
                      : FeatherIcons.chevronUp,
                  size: 16.0,
                  color: app.settings.theme.textTheme.bodyText1.color,
                ),
              )
            : Container(),
        Icon(
          icon,
          color: selected
              ? app.settings.appColor
              : app.settings.theme.textTheme.bodyText1.color,
        ),
      ],
    ),
    backgroundColor: app.settings.theme.backgroundColor,
    labelWidget: Padding(
      padding: EdgeInsets.only(right: 14.0),
      child: Text(
        capital(text),
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.white,
        ),
      ),
    ),
    onTap: onTap,
  );
}
