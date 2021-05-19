import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';

class TutorialView extends StatefulWidget {
  final Function callback;

  TutorialView({this.callback});

  @override
  _TutorialViewState createState() => _TutorialViewState();
}

class _TutorialViewState extends State<TutorialView> {
  int currentPage = 0;
  List<Widget> tutorialPages = [
    TutorialPage1(),
    TutorialPage2(),
    TutorialPage3(),
    TutorialPage4(),
    TutorialPage5(),
    TutorialPage6(),
    TutorialPage7(),
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(brightness: Brightness.dark),
      child: Container(
        child: Stack(children: [
          tutorialPages[currentPage],
          GestureDetector(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
            ),
            onTap: () {
              if (currentPage < tutorialPages.length - 1)
                setState(() => currentPage++);
              else
                Navigator.pop(context);

              if (currentPage < 5)
                widget.callback(currentPage);
              else
                widget.callback(0);
            },
          ),
          Container(
            padding: EdgeInsets.all(12.0),
            child: IconButton(
              icon: Icon(FeatherIcons.x, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ]),
      ),
    );
  }
}

class TutorialPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 12.0),
          alignment: Alignment.center,
          child: ListTile(
            title: Text(
              capital(I18n.of(context).homepage),
              style: TextStyle(
                fontSize: 20.0,
                height: 3.0,
              ),
            ),
            subtitle: Text(
              I18n.of(context).tutorial1,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: EdgeInsets.all(8.0),
                margin: EdgeInsets.symmetric(horizontal: 6.0),
                decoration: BoxDecoration(
                  color: app.settings.theme.backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(FeatherIcons.search, color: app.settings.appColor),
              ),
              SizedBox(width: 52.0),
              SizedBox(width: 52.0),
              SizedBox(width: 52.0),
              SizedBox(width: 52.0),
            ],
          ),
        ),
      ],
    );
  }
}

class TutorialPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 12.0),
          alignment: Alignment.center,
          child: ListTile(
            title: Text(
              I18n.of(context).evaluationTitle,
              style: TextStyle(
                fontSize: 20.0,
                height: 3.0,
              ),
            ),
            subtitle: Text(
              I18n.of(context).tutorial2,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(width: 52.0),
              Container(
                padding: EdgeInsets.all(8.0),
                margin: EdgeInsets.symmetric(horizontal: 6.0),
                decoration: BoxDecoration(
                  color: app.settings.theme.backgroundColor,
                  shape: BoxShape.circle,
                ),
                child:
                    Icon(FeatherIcons.bookmark, color: app.settings.appColor),
              ),
              SizedBox(width: 52.0),
              SizedBox(width: 52.0),
              SizedBox(width: 52.0),
            ],
          ),
        ),
      ],
    );
  }
}

class TutorialPage3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 12.0),
          alignment: Alignment.center,
          child: ListTile(
            title: Text(
              I18n.of(context).plannerTitle,
              style: TextStyle(
                fontSize: 20.0,
                height: 3.0,
              ),
            ),
            subtitle: Text(
              I18n.of(context).tutorial3,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: EdgeInsets.all(8.0),
                margin: EdgeInsets.symmetric(horizontal: 6.0),
                decoration: BoxDecoration(
                  color: app.settings.theme.backgroundColor,
                  shape: BoxShape.circle,
                ),
                child:
                    Icon(FeatherIcons.calendar, color: app.settings.appColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TutorialPage4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 12.0),
          alignment: Alignment.center,
          child: ListTile(
            title: Text(
              I18n.of(context).messageTitle,
              style: TextStyle(
                fontSize: 20.0,
                height: 3.0,
              ),
            ),
            subtitle: Text(
              I18n.of(context).tutorial4,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(width: 52.0),
              SizedBox(width: 52.0),
              SizedBox(width: 52.0),
              Container(
                padding: EdgeInsets.all(8.0),
                margin: EdgeInsets.symmetric(horizontal: 6.0),
                decoration: BoxDecoration(
                  color: app.settings.theme.backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(FeatherIcons.messageSquare,
                    color: app.settings.appColor),
              ),
              SizedBox(width: 52.0),
            ],
          ),
        ),
      ],
    );
  }
}

class TutorialPage5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 12.0),
          alignment: Alignment.center,
          child: ListTile(
            title: Text(
              I18n.of(context).absenceTitle,
              style: TextStyle(
                fontSize: 20.0,
                height: 3.0,
              ),
            ),
            subtitle: Text(
              I18n.of(context).tutorial5,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(width: 52.0),
              SizedBox(width: 52.0),
              SizedBox(width: 52.0),
              SizedBox(width: 52.0),
              Container(
                padding: EdgeInsets.all(8.0),
                margin: EdgeInsets.symmetric(horizontal: 6.0),
                decoration: BoxDecoration(
                  color: app.settings.theme.backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(FeatherIcons.slash, color: app.settings.appColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TutorialPage6 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.topRight,
          padding: EdgeInsets.only(top: 17.0, right: 22.0),
          child: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: app.settings.theme.backgroundColor,
              shape: BoxShape.circle,
            ),
            child: app.user.profileIcon,
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: ListTile(
            title: Text(
              I18n.of(context).accountTitle,
              style: TextStyle(
                fontSize: 20.0,
                height: 3.0,
              ),
            ),
            subtitle: Text(
              I18n.of(context).tutorial6,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ),
      ],
    );
  }
}

class TutorialPage7 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: ListTile(
        title: Text(
          I18n.of(context).tutorial7,
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}
