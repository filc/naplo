import 'package:filcnaplo/data/models/evaluation.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:fl_chart/fl_chart.dart';

class SubjectGraph extends StatefulWidget {
  final List<Evaluation> data;
  final int dayThreshold;

  SubjectGraph(this.data, {this.dayThreshold = 7});

  @override
  _SubjectGraphState createState() => _SubjectGraphState();
}

class _SubjectGraphState extends State<SubjectGraph> {
  @override
  Widget build(BuildContext context) {
    List<FlSpot> subjectData = [];
    List<List<Evaluation>> sortedData = [[]];

    List<Evaluation> data = widget.data
        .where((evaluation) => evaluation.value.weight != 0)
        .toList();
    data.sort((a, b) => a.writeDate.compareTo(b.writeDate));

    widget.data.forEach((element) {
      if (sortedData.last.length != 0 &&
          sortedData.last.last.writeDate.difference(element.writeDate).inDays >
              widget.dayThreshold) sortedData.add([]);
      sortedData.forEach((dataList) {
        dataList.add(element);
      });
    });

    sortedData.forEach((dataList) {
      double average = 0;

      dataList.forEach((e) {
        average += e.value.value * (e.value.weight / 100);
      });

      average = average /
          dataList.map((e) => e.value.weight / 100).reduce((a, b) => a + b);

      subjectData.add(FlSpot(
        dataList[0].writeDate.month +
            (dataList[0].writeDate.day / 31) +
            ((dataList[0].writeDate.year - data.first.writeDate.year) * 12),
        double.parse(average.toStringAsFixed(2)),
      ));
    });

    return Container(
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: subjectData,
              isCurved: true,
              curveSmoothness: .1,
              colors: [app.settings.theme.accentColor],
              barWidth: 8,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                colors: [
                  app.settings.theme.accentColor.withOpacity(0.7),
                  app.settings.theme.accentColor.withOpacity(0.3),
                  app.settings.theme.accentColor.withOpacity(0.2),
                  app.settings.theme.accentColor.withOpacity(0.1),
                ],
                gradientColorStops: [0.1, 0.6, 0.8, 1],
                gradientFrom: Offset(0, 0),
                gradientTo: Offset(0, 1),
              ),
            ),
          ],
          minY: 1,
          maxY: 5,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            getDrawingHorizontalLine: (_) => FlLine(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey[400]
                  : app.settings.theme.backgroundColor,
              strokeWidth: 1,
            ),
            getDrawingVerticalLine: (_) => FlLine(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey[400]
                  : app.settings.theme.backgroundColor,
              strokeWidth: 1,
            ),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.black54,
              fitInsideVertically: true,
              fitInsideHorizontally: true,
            ),
            touchCallback: (LineTouchResponse touchResponse) {},
            handleBuiltInTouches: true,
            touchSpotThreshold: 50.0,
            getTouchedSpotIndicator: (_, spots) => List.generate(
              spots.length,
              (index) => TouchedSpotIndicatorData(
                FlLine(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey[400]
                      : app.settings.theme.backgroundColor,
                  strokeWidth: 3.5,
                ),
                FlDotData(
                  getDotPainter: (a, b, c, d) => FlDotCirclePainter(
                    strokeWidth: 0,
                    color: app.settings.theme.backgroundColor,
                    radius: 10.0,
                  ),
                ),
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey[400]
                  : app.settings.theme.backgroundColor,
              width: 4,
            ),
          ),
          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              getTextStyles: (_) => TextStyle(
                color: textColor(app.settings.theme.backgroundColor),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              interval: 1.2,
              margin: 12,
              getTitles: (value) {
                String ret = "";

                switch (value.floor() % 12) {
                  case 0:
                    ret = I18n.of(context).dateDec;
                    break;
                  case 1:
                    ret = I18n.of(context).dateJan;
                    break;
                  case 2:
                    ret = I18n.of(context).dateFeb;
                    break;
                  case 3:
                    ret = I18n.of(context).dateMar;
                    break;
                  case 4:
                    ret = I18n.of(context).dateApr;
                    break;
                  case 5:
                    ret = I18n.of(context).dateMay;
                    break;
                  case 6:
                    ret = I18n.of(context).dateJun;
                    break;
                  case 7:
                    ret = I18n.of(context).dateJul;
                    break;
                  case 8:
                    ret = I18n.of(context).dateAug;
                    break;
                  case 9:
                    ret = I18n.of(context).dateSep;
                    break;
                  case 10:
                    ret = I18n.of(context).dateOct;
                    break;
                  case 11:
                    ret = I18n.of(context).dateNov;
                    break;
                  case 12:
                    ret = I18n.of(context).dateDec;
                    break;
                  default:
                    ret = '?';
                    break;
                }

                return ret.toUpperCase();
              },
            ),
            leftTitles: SideTitles(
              showTitles: true,
              getTextStyles: (value) => TextStyle(
                color: textColor(app.settings.theme.backgroundColor),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              margin: 16,
            ),
          ),
        ),
      ),
    );
  }
}
