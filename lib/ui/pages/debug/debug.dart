import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/kreta/client.dart';
import 'package:filcnaplo/utils/colors.dart';
import 'package:flutter/material.dart';

class DebugError {
  String details;
  String parent;

  DebugError({
    this.details,
    this.parent,
  });
}

class DebugResponse {
  String response = "";
  List<DebugError> errors = [];
  int statusCode = 0;
}

class DebugEndpoint extends StatelessWidget {
  final String host;
  final String uri;

  DebugEndpoint({
    this.host,
    this.uri,
  });

  Future<DebugResponse> execute() async {
    DebugResponse res = DebugResponse();
    KretaClient api = app.user.kreta;

    try {
      var req = await api.client.get(
        host + uri,
        headers: {
          "User-Agent": api.userAgent,
          "Authorization": "Bearer ${api.accessToken}",
        },
      );

      res.response = req.body;
      res.statusCode = req.statusCode;
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
            Color(0x0),
            Colors.yellow[600],
            Colors.red,
          ];
          Color statusColor = snapshot.data != null
              ? statusColors[
                  ((snapshot.data.statusCode / 100).floor() - 2).clamp(0, 3)]
              : null;

          return Container(
            padding: EdgeInsets.all(12.0),
            child: snapshot.hasData
                ? Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                Container(
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
                                Text(
                                  uri,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: "SpaceMono",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: Text(snapshot.data.response.substring(0,
                                400.clamp(1, snapshot.data.response.length)) +
                            "..."),
                      ),
                    ],
                  )
                : Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
