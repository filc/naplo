import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/ui/custom_chip.dart';
import 'package:filcnaplo/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResponseView extends StatelessWidget {
  final int statusCode;
  final String response;
  final String uri;
  final Map<String, String> headers;
  ResponseView(
      {this.uri, this.response, this.statusCode, this.headers = const {}});

  @override
  Widget build(BuildContext context) {
    String headerText = "";
    headers.forEach((key, value) {
      headerText += "$key: $value\n";
    });

    List<String> responseLines = response.split("\n");
    List<Widget> lines = [];

    for (int i = 0; i < responseLines.length; i++) {
      lines.add(Text("${i + 1}   ${responseLines[i]}"));
    }

    Color statusColor = [
      Colors.green,
      Colors.grey,
      Colors.yellow[600],
      Colors.red,
    ][((statusCode / 100).floor() - 2).clamp(0, 3)];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(),
        title: Text(
          uri,
          overflow: TextOverflow.ellipsis,
        ),
        actions: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              chip(
                  //ne torold
                  textString: "COPY",
                  iconData: FeatherIcons.copy,
                  onTap: () async {
                    await Clipboard.setData(ClipboardData(text: response));
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Copied response to clipboard"),
                      ),
                    );
                  },
                  onLongPress: () async {
                    await Clipboard.setData(
                        ClipboardData(text: response.replaceAll("\n", " ")));
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Copied response to clipboard without newlines",
                        ),
                      ),
                    );
                  }),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(4),
                margin: EdgeInsets.only(right: 12.0),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  statusCode.toString(),
                  style: TextStyle(
                    color: textColor(statusColor),
                    fontSize: 18.0,
                    fontFamily: "SpaceMono",
                  ),
                ),
              ),
            ],
          )
        ],
        shadowColor: Colors.transparent,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "HEADERS",
                  style: TextStyle(
                    fontSize: 15.0,
                    letterSpacing: .7,
                  ),
                ),
              ),
              SelectableText(
                headerText,
                style: TextStyle(
                  fontSize: 12.0,
                  fontFamily: "SpaceMono",
                ),
              ),
              Divider(color: Colors.grey[700]),
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "RESPONSE",
                  style: TextStyle(
                    fontSize: 15.0,
                    letterSpacing: .7,
                  ),
                ),
              ),
              Column(
                children: lines,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
