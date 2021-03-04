import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/kreta/client.dart';
import 'package:filcnaplo/ui/common/label.dart';
import 'package:filcnaplo/ui/pages/debug/response_view.dart';
import 'package:filcnaplo/ui/pages/debug/struct.dart';
import 'package:filcnaplo/utils/colors.dart';
import 'package:flutter/material.dart';

class DebugTile extends StatelessWidget {
  final DebugEndpoint endpoint;
  DebugTile(this.endpoint);

  Future<DebugResponse> execute() async {
    DebugResponse res = DebugResponse();
    KretaClient api = app.user.kreta;

    try {
      var req = await api.client.get(
        Uri.parse(endpoint.host + endpoint.uri),
        headers: {
          "User-Agent": api.userAgent,
          "Authorization": "Bearer ${api.accessToken}",
        },
      );
      res.response = req.body;
      res.statusCode = req.statusCode;
      res.headers = req.headers;
    } catch (error) {
      res.errors.add(DebugError(
        parent: "DebugEndpoint.execute",
        details: error.toString(),
      ));
    }

    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: execute(),
        builder: (BuildContext context, AsyncSnapshot<DebugResponse> snapshot) {
          List<Color> statusColors = [
            Colors.green,
            Colors.grey,
            Colors.yellow[600],
            Colors.red,
          ];
          Color statusColor = snapshot.data != null
              ? statusColors[
                  ((snapshot.data.statusCode / 100).floor() - 2).clamp(0, 3)]
              : null;

          return
          GestureDetector(
            onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResponseView(
                              uri: endpoint.uri,
                              response: snapshot.data.response,
                              statusCode: snapshot.data.statusCode,
                              headers: snapshot.data.headers,
                            ),
                          ),
                        ),
            child: Container(
              padding: EdgeInsets.all(12.0),
              child: snapshot.hasData
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Label(endpoint.name),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container( //Response code
                              padding: EdgeInsets.all(4),
                              margin: EdgeInsets.only(right: 12.0),
                              decoration: BoxDecoration(
                                color: statusColor,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                snapshot.data.statusCode.toString(),
                                style: TextStyle(
                                  color: textColor(statusColor),
                                  fontSize: 18.0,
                                  fontFamily: "SpaceMono",
                                ),
                              ),
                            ),
                            Expanded( //Request endpoint
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 4,
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SelectableText(
                                    endpoint.uri,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: "SpaceMono",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                          Container( //Response
                            margin: EdgeInsets.only(top: 6),
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Text(
                              snapshot.data.response
                                  .replaceAll(RegExp(r'[\n\t\s]+'), " "),
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: "SpaceMono",
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                          
                      ],
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
          );
        },
      ),
    );
  }
}
