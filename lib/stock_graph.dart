import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StockSeries {
  final String date;
  final double close;

  StockSeries(
      {@required this.date,
      @required this.close});
}

class StockChart extends StatelessWidget {
  final List<StockSeries> data;

  StockChart({@required this.data});

@override
Widget build(BuildContext context) {
  List<charts.Series<StockSeries, DateTime>> series = [
    charts.Series(
      id: "Stocks",
      data: data,
      domainFn: (StockSeries series, _) => DateTime(int.parse(series.date.split("-")[0]), int.parse(series.date.split("-")[1]), int.parse(series.date.split("-")[2])),
      measureFn: (StockSeries series, _) => series.close)
      // double.parse(series.date.split("-")[2])
  ];
  return Container(
      height: 400,
      padding: EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                "Stock Data",
                style: Theme.of(context).textTheme.body2,
              ),
              Expanded(
                child: charts.TimeSeriesChart(series, animate: true),
              )
            ],
          ),
        ),
      ),
    );
}

}
