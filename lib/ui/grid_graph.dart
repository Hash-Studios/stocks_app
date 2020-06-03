import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GridSeries {
  final String date;
  final double close;

  GridSeries({@required this.date, @required this.close});
}

class GridChart extends StatelessWidget {
  final List<GridSeries> dataChart;

  GridChart({@required this.dataChart});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<GridSeries, DateTime>> series = [
      charts.Series(
          id: "Stocks",
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          data: dataChart,
          domainFn: (GridSeries series, _) => DateTime(
              int.parse(series.date.split("-")[0]),
              int.parse(series.date.split("-")[1]),
              int.parse(series.date.split("-")[2])),
          measureFn: (GridSeries series, _) => series.close)
      // double.parse(series.date.split("-")[2])
    ];
    return Container(
      height: 290.h,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: charts.TimeSeriesChart(
                  series,
                  animate: false,
                  defaultRenderer: new charts.LineRendererConfig(
                      includeArea: true, stacked: true),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
