import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/pages/about/supporters/builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutSupporters extends StatefulWidget {
  @override
  _AboutSupportersState createState() => _AboutSupportersState();
}

class _AboutSupportersState extends State<AboutSupporters> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  final _supporterBuilder = SupporterBuilder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _supporterBuilder.build(context),
        builder: (BuildContext context, snapshot) => Container(
          padding: EdgeInsets.only(top: 28.0),
          child: Column(
            children: [
              ListTile(
                leading: BackButton(color: app.settings.appColor),
                title: Text(
                  I18n.of(context).aboutSupporters,
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  key: _refreshKey,
                  onRefresh: () async {
                    await _supporterBuilder.build(context);
                    setState(() {});
                  },
                  child: CupertinoScrollbar(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      children: snapshot.hasData
                          ? snapshot.data
                          : [
                              Container(
                                height: 200.0,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
