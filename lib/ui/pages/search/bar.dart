import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/common/account_button.dart';
import 'package:filcnaplo/utils/format.dart';

class SearchBar extends StatelessWidget {
  final Function openSearch;

  SearchBar({@required this.openSearch});

  @override
  Widget build(context) {
    return Container(
      margin: EdgeInsets.fromLTRB(18.0, 40.0, 18.0, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: app.settings.theme.backgroundColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1.5),
            blurRadius: 6.0,
            color: Colors.black12,
          )
        ],
      ),
      padding: EdgeInsets.only(left: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(FeatherIcons.search, color: app.settings.appColor),
              Expanded(
                child: GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(11.5),
                    child: Text(
                      capital(I18n.of(context).search),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  onTap: openSearch,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 4.0),
                child: ClipOval(
                  child: Material(
                    color: Colors.transparent,
                    child: AccountButton(padding: EdgeInsets.zero),
                  ),
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ],
      ),
    );
  }
}
