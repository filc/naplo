import 'package:filcnaplo/utils/colors.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';

class ResponseView extends StatelessWidget {
  final int statusCode;
  final String response;
  final String uri;
  final Map<String, String> headers;

  ResponseView({
    this.uri,
    this.response,
    this.statusCode,
    this.headers = const {},
  });

  @override
  Widget build(BuildContext context) {
    List<InlineSpan> headerParts = [];
    headers.forEach((key, value) {
      headerParts.add(TextSpan(
        text: capitalize(key),
        style: TextStyle(fontWeight: FontWeight.bold),
      ));
      headerParts.add(TextSpan(text: ": $value\n"));
    });
    TextSpan headerText = TextSpan(children: headerParts);
    List<String> responseLines = response.replaceAll("\r", "").split("\n");
    dynamic lines = [];
    dynamic lineNumbers = [];
    for (int i = 0; i < responseLines.length; i++) {
      lineNumbers.add("${i + 1}");
      lines.add("${responseLines[i]}");
    }
    lines = lines.join('\n');
    lineNumbers = lineNumbers.join('\n');

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
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: SelectableText.rich(
                  headerText,
                  scrollPhysics: NeverScrollableScrollPhysics(),
                  style: TextStyle(
                    fontSize: 12.0,
                    fontFamily: "SpaceMono",
                  ),
                ),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Text(
                    lineNumbers,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontFamily: "SpaceMono",
                      color: Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SelectableText(
                      lines,
                      scrollPhysics: NeverScrollableScrollPhysics(),
                      style: TextStyle(
                        fontSize: 12.0,
                        fontFamily: "SpaceMono",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
