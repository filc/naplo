import 'package:filcnaplo/data/models/evaluation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class SubjectGraph extends StatefulWidget {
  final List<charts.Series> seriesList;

  SubjectGraph(this.seriesList);

  factory SubjectGraph.fromData({List<Evaluation> data}) {
    return SubjectGraph(_createData(data));
  }

  @override
  _SubjectGraphState createState() => _SubjectGraphState();

  static List<charts.Series<TimeSeries, DateTime>> _createData(
      List<Evaluation> data) {
    List<TimeSeries> series = [];
    List<List<Evaluation>> sortedData = [[]];

    data.forEach((element) {
      if (sortedData.last.length != 0 &&
          (sortedData.last.last.date ?? sortedData.last.last.date)
                  .difference(element.date ?? element.date)
                  .inDays >
              14) sortedData.add([]);
      sortedData.forEach((dataList) {
        dataList.add(element);
      });
    });

    sortedData = sortedData.reversed.toList();

    sortedData.forEach((dataList) {
      double average = 0;

      dataList.forEach((e) {
        average += e.value.value * (e.value.weight / 100);
      });

      average = average /
          dataList.map((e) => e.value.weight / 100).reduce((a, b) => a + b);

      series
          .add(TimeSeries(dataList[0].date ?? dataList[0].date, average));
    });

    Color c = app.settings.appColor;

    return [
      charts.Series<TimeSeries, DateTime>(
        id: 'average_graph',
        colorFn: (_, __) => charts.Color(r: c.red, g: c.green, b: c.blue),
        domainFn: (TimeSeries average, _) => average.time,
        measureFn: (TimeSeries average, _) => average.avg,
        data: series,
      )
    ];
  }
}

class _SubjectGraphState extends State<SubjectGraph> {
  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      widget.seriesList,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      defaultRenderer: charts.LineRendererConfig(includePoints: true),
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickProviderSpec: charts.StaticNumericTickProviderSpec([
          charts.TickSpec(5),
          charts.TickSpec(4),
          charts.TickSpec(3),
          charts.TickSpec(2),
          charts.TickSpec(1)
        ]),
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(
              fontSize: 14,
              color: app.settings.theme.brightness == Brightness.light
                  ? charts.MaterialPalette.black
                  : charts.MaterialPalette.white),
          lineStyle: charts.LineStyleSpec(
              color: charts.MaterialPalette.gray.shadeDefault),
        ),
      ),
      domainAxis: charts.DateTimeAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(
              fontSize: 14,
              color: app.settings.theme.brightness == Brightness.light
                  ? charts.MaterialPalette.black
                  : charts.MaterialPalette.white),
          lineStyle: charts.LineStyleSpec(
              color: charts.MaterialPalette.gray.shadeDefault),
        ),
      ),
      behaviors: [
        charts.LinePointHighlighter(
          showHorizontalFollowLine:
              charts.LinePointHighlighterFollowLineType.none,
          showVerticalFollowLine:
              charts.LinePointHighlighterFollowLineType.nearest,
        ),
        charts.SelectNearest(eventTrigger: charts.SelectionTrigger.tapAndDrag)
      ],
    );
  }
}

class TimeSeries {
  final DateTime time;
  final double avg;

  TimeSeries(this.time, this.avg);
}
