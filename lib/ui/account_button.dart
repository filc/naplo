import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/ui/page_transition.dart';
import 'package:filcnaplo/ui/pages/accounts/page.dart';
import 'package:flutter/material.dart';

class AccountButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8.0),
      child: IconButton(
        icon: app.user.profileIcon,
        onPressed: () {
          Navigator.of(context).push(PageTransition.vertical(AccountPage()));
        },
      ),
    );
  }
}
