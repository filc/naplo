import 'package:filcnaplo/data/context/app.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/generated/i18n.dart';

class MoreHomework extends StatefulWidget {
  final Function()? callback;

  const MoreHomework({this.callback});
  @override
  _MoreHomeworkState createState() => _MoreHomeworkState();
}

class _MoreHomeworkState extends State<MoreHomework> {
  bool ready = true;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ready
            ? TextButton(
                onPressed: syncmore,
                child: Text(
                  I18n.of(context).homeworkMore,
                  style: TextStyle(color: app.settings.theme.accentColor),
                ))
            : Container(
                margin: EdgeInsets.all(4.0),
                child: Center(
                  heightFactor: 1,
                  widthFactor: 1,
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        app.settings.theme.accentColor,
                      ),
                      strokeWidth: 3,
                    ),
                  ),
                ),
              ));
  }

  void syncmore() async {
    setState(() {
      ready = false;
    });
    await app.user.sync.homework.sync(
      duration:
          Duration(days: app.user.sync.homework.currentDuration.inDays + 7),
    );
    if (mounted)
      setState(() {
        ready = true;
      });
    widget.callback!();
  }
}
