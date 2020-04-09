import 'package:flutter/material.dart';
import 'package:stocks_app/stock_graph.dart';
import 'bsecodes.dart';

Map data = {};
Map recentData = {};
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
      Map dataMap = await stock.getdata(widget.code);
      setState(
        () {
          data = dataMap;
          for (var c = 0; c < 30; c++) {
            dataList.add(
              new StockSeries(
                  date: data["data$c"]["date"], close: data["data$c"]["close"]),
            );
          }
          recentData = data["data0"];
          print(recentData["dqtq"]);
          dataFetched = true;
        },
      );
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
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: null),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: null),
          IconButton(icon: Icon(Icons.more_vert), onPressed: null)
        ],
      ),
      body: dataFetched
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ClipRRect(
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
                                fontSize: 35, fontWeight: FontWeight.bold),
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
                        width: 100,
                        height: 55,
                        padding: EdgeInsets.fromLTRB(20, 35, 40, 0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                          child: Container(
                            child: LinearProgressIndicator(
                              value: recentData["dqtq"]/100,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        height: 80,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(22, 10, 6, 10),
                              child: Text('${recentData["dqtq"].toString()}%',style: TextStyle(fontSize: 35, color: Colors.pink,fontWeight: FontWeight.bold),),
                            ),
                            Text(
                              'Deliverable Quantity to Traded Quantity',
                              style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    ],
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
                            color: Colors.blueGrey[700],
                            child: SizedBox(
                              width: 140,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      'OPENING',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      recentData["open"].toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
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
                            color: Colors.blueGrey[700],
                            child: SizedBox(
                              width: 140,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      'HIGH',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      recentData["high"].toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
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
                            color: Colors.blueGrey[700],
                            child: SizedBox(
                              width: 140,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      'LOW',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      recentData["low"].toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
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
                            color: Colors.blueGrey[700],
                            child: SizedBox(
                              width: 140,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      'CLOSING',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      recentData["close"].toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
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
                            color: Colors.blueGrey[700],
                            child: SizedBox(
                              width: 200,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      'TOTAL TURNOVER',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      recentData["turn"].toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
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
          : Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
