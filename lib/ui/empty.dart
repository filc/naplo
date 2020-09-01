import 'package:flutter/material.dart';

class Empty extends StatelessWidget {
  final String title;

  Empty({this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "¯\\_(ツ)_/¯",
              style: TextStyle(fontSize: 18.0, color: Colors.grey[600]),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: title != null
                  ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                        title,
                        style: TextStyle(fontSize: 16.0, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                  )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
