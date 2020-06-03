import 'package:flutter/material.dart';
import 'package:stocks_app/data/stock.dart';
import 'package:stocks_app/data/stock_day.dart';
import 'package:stocks_app/ui/stock_graph.dart';
import 'package:stocks_app/data/stocksData.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
// import 'package:stocks_app/data/stockDayDataModel.dart';
// import 'package:stocks_app/data/stockDataModel.dart';

StockModel data;
StockDayModel recentData;
StockDayModel lastData;
bool dataFetched = false;
List<StockSeries> dataList = [];
// Hive Box
var _box = Hive.box<StockModel>('stocks');
var _fav = Hive.box('fav_stocks');

class Info extends StatefulWidget {
  String name;
  String code;

  Info(this.name, this.code);

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  String titleCase(String text) {
    var texxt = text.toLowerCase();
    if (texxt.length <= 1) return texxt.toUpperCase();
    var words = texxt.split(' ');
    var capitalized = words.map((word) {
      var first = word.substring(0, 1).toUpperCase();
      var rest = word.substring(1);
      return '$first$rest';
    });
    return capitalized.join(' ');
  }

  StockData stock = StockData();

  void getstock() async {
    try {
      if (_box.get(widget.code) == null) {
        StockModel dataMap = await stock.getdata(widget.code);
        setState(
          () {
            data = dataMap;
            for (var c = 0; c < 30; c++) {
              dataList.add(
                new StockSeries(
                    date: data.stockData["data$c"].date,
                    close: data.stockData["data$c"].close),
              );
            }
            recentData = data.stockData["data0"];
            lastData = data.stockData["data1"];
            // print(recentData.dqtq);
            dataFetched = true;
            _box.put(dataMap.code, dataMap);
          },
        );
      } else {
        StockModel dataMap = _box.get(widget.code);
        setState(
          () {
            data = dataMap;
            for (var c = 0; c < 30; c++) {
              dataList.add(
                new StockSeries(
                    date: data.stockData["data$c"].date,
                    close: data.stockData["data$c"].close),
              );
            }
            recentData = data.stockData["data0"];
            lastData = data.stockData["data1"];
            // print(recentData.dqtq);
            dataFetched = true;
          },
        );
        if (_box.get(widget.code).date !=
            DateFormat("yy-MM-dd").format(DateTime.now())) {
          StockModel dataMap = await stock.getdata(widget.code);
          setState(
            () {
              data = dataMap;
              for (var c = 0; c < 30; c++) {
                dataList.add(
                  new StockSeries(
                      date: data.stockData["data$c"].date,
                      close: data.stockData["data$c"].close),
                );
              }
              recentData = data.stockData["data0"];
              lastData = data.stockData["data1"];
              // print(recentData.dqtq);
              dataFetched = true;
              _box.put(dataMap.code, dataMap);
            },
          );
        }
      }
      // print(data["data0"].toString());
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
    ScreenUtil.init(context, width: 720, height: 1440, allowFontScaling: true);
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.grey,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                _fav.get(widget.code) == true
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.grey,
              ),
              onPressed: () {
                _fav.get(widget.code) == true
                    ? _fav.delete(widget.code)
                    : _fav.put(widget.code, true);
                setState(() {});
              }),
          IconButton(
              icon: Icon(
                Icons.more_vert,
                color: Colors.grey,
              ),
              onPressed: null)
        ],
      ),
      body: dataFetched
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  decoration: new BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(150)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 2.0, // soften the shadow
                        spreadRadius: 1.0, //extend the shadow
                        offset: Offset(
                          0.0, // Move to right 10  horizontally
                          2.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(150),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                            child: Text(
                              titleCase(widget.name),
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        Center(
                          child: StockChart(
                            dataChart: dataList,
                            dataMapped: recentData,
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          height: 70.h,
                          padding: EdgeInsets.fromLTRB(20, 25, 50, 0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            child: Container(
                              child: LinearProgressIndicator(
                                backgroundColor: Colors.grey[200],
                                value: recentData.dqtq / 100,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          height: 130.h,
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(22, 10, 6, 10),
                                child: Text(
                                  '${recentData.dqtq.toString()}%',
                                  style: TextStyle(
                                      fontSize: 35,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                'Deliverable Quantity to Traded Quantity',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 6, 20),
                          child: Card(
                            elevation: 2,
                            color: Colors.blue[50],
                            child: SizedBox(
                              width: 220.w,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      recentData.open.toString(),
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      (recentData.open - lastData.open)
                                          .toStringAsFixed(2),
                                      style: TextStyle(
                                          color:
                                              recentData.open >= lastData.open
                                                  ? Colors.green
                                                  : Colors.red,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'OPENING',
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 6, 20),
                          child: Card(
                            elevation: 2,
                            color: Colors.blue[50],
                            child: SizedBox(
                              width: 220.w,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      recentData.high.toString(),
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      (recentData.high - lastData.high)
                                          .toStringAsFixed(2),
                                      style: TextStyle(
                                          color:
                                              recentData.high >= lastData.high
                                                  ? Colors.green
                                                  : Colors.red,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'HIGH',
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 6, 20),
                          child: Card(
                            elevation: 2,
                            color: Colors.blue[50],
                            child: SizedBox(
                              width: 220.w,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      recentData.low.toString(),
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      (recentData.low - lastData.low)
                                          .toStringAsFixed(2),
                                      style: TextStyle(
                                          color: recentData.low >= lastData.low
                                              ? Colors.green
                                              : Colors.red,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'LOW',
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 6, 20),
                          child: Card(
                            elevation: 2,
                            color: Colors.blue[50],
                            child: SizedBox(
                              width: 220.w,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      recentData.close.toString(),
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      (recentData.close - lastData.close)
                                          .toStringAsFixed(2),
                                      style: TextStyle(
                                          color:
                                              recentData.close >= lastData.close
                                                  ? Colors.green
                                                  : Colors.red,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'CLOSING',
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                          child: Card(
                            elevation: 2,
                            color: Colors.blue[50],
                            child: SizedBox(
                              width: 380.w,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      recentData.turn.toString(),
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${((recentData.turn - lastData.turn) / lastData.turn).toStringAsFixed(2)}%',
                                      style: TextStyle(
                                          color:
                                              recentData.turn >= lastData.turn
                                                  ? Colors.green
                                                  : Colors.red,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'TOTAL TURNOVER',
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  decoration: new BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(150)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 2.0, // soften the shadow
                        spreadRadius: 1.0, //extend the shadow
                        offset: Offset(
                          0.0, // Move to right 10  horizontally
                          2.0, // Move to bottom 10 Vertically
                        ),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(150),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                            child: Text(
                              titleCase(widget.name),
                              style: TextStyle(
                                  color: Colors.black12,
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            color: Colors.white,
                            child: SizedBox(
                              height: 650.h,
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    205, 180, 205, 180),
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          height: 70.h,
                          padding: EdgeInsets.fromLTRB(20, 25, 50, 0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            child: Container(
                              child: LinearProgressIndicator(
                                backgroundColor: Colors.grey[200],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          height: 130.h,
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(22, 10, 6, 10),
                                child: Text(
                                  '       ',
                                  style: TextStyle(
                                      fontSize: 35,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                '       ',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 6, 20),
                          child: Card(
                            elevation: 2,
                            color: Colors.blue[50],
                            child: SizedBox(
                              width: 220.w,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.blue[100]),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 6, 20),
                          child: Card(
                            elevation: 2,
                            color: Colors.blue[50],
                            child: SizedBox(
                              width: 220.w,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.blue[100]),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 6, 20),
                          child: Card(
                            elevation: 2,
                            color: Colors.blue[50],
                            child: SizedBox(
                              width: 220.w,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.blue[100]),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 6, 20),
                          child: Card(
                            elevation: 2,
                            color: Colors.blue[50],
                            child: SizedBox(
                              width: 220.w,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.blue[100]),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                          child: Card(
                            elevation: 2,
                            color: Colors.blue[50],
                            child: SizedBox(
                              width: 380.w,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.blue[100]),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
