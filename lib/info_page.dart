import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:stocks_app/stock_graph.dart';
import 'bsecodes.dart';

Map data = {};
bool dataFetched = false;
List<StockSeries> dataList = [];

class Info extends StatefulWidget {
  String name;
  String code;

  Info(this.name, this.code);

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  StockData stock = StockData();

  void getstock() async {
    try {
      Map dataMap = await stock.getdata(widget.code);
      setState(
        () {
          data = dataMap;
          dataFetched = true;
          for (var c = 0; c < 100; c++) {
            dataList.add(
              new StockSeries(
                  date: data["data$c"]["date"], close: data["data$c"]["close"]),
            );
          }
        },
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    dataFetched = false;
    dataList = [];
    getstock();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: dataFetched
          ? Center(
              child: StockChart(
              data: dataList,
            ))
          : Center(child: CircularProgressIndicator()),
    );
  }
}
