import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'bsecodes.dart';

String data = 'Hello';

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
      var dataMap = await stock.getdata(widget.code);
      setState(() {
        data = dataMap.toString();
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getstock();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(widget.name)), body: Text(data));
  }
}
