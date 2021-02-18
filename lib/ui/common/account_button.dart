import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/ui/common/page_transition.dart';
import 'package:filcnaplo/ui/pages/accounts/page.dart';
import 'package:flutter/material.dart';

class AccountButton extends StatelessWidget {
  final EdgeInsetsGeometry padding;

  AccountButton({this.padding = const EdgeInsets.only(right: 8.0)});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: padding,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6.0, spreadRadius: -8.0)
        ],
      ),
      child: IconButton(
        icon: app.user.profileIcon,
        onPressed: () {
          Navigator.of(context, rootNavigator: true)
              .push(PageTransition.vertical(AccountPage()));
        },
      ),
    );
  }
}
