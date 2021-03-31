import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/ui/common/page_transition.dart';
import 'package:filcnaplo/ui/pages/accounts/page.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/ui/common/notificationBadge.dart';

class AccountButton extends StatelessWidget {
  final EdgeInsetsGeometry padding;

  AccountButton({this.padding = const EdgeInsets.only(right: 8.0)});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: padding,
          child: IconButton(
            icon: app.user.profileIcon,
            onPressed: () {
              Navigator.of(context, rootNavigator: true)
                  .push(PageTransition.vertical(AccountPage()));
            },
          ),
        ),
        if (app.user.sync.release.isNew) NotificationBadge(),
      ],
    );
  }
}
