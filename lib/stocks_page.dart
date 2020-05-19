import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:random_color/random_color.dart';
import 'package:stocks_app/grid_graph.dart';
import 'bsecodes.dart';
import 'info_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

RandomColor _randomColor = RandomColor();
Color color1 = _randomColor.randomColor(
    colorSaturation: ColorSaturation.lowSaturation,
    colorHue: ColorHue.pink,
    colorBrightness: ColorBrightness.light);
Color color2 = _randomColor.randomColor(
    colorSaturation: ColorSaturation.highSaturation,
    colorHue: ColorHue.pink,
    colorBrightness: ColorBrightness.light);
Map<String, List<GridSeries>> graphs = {};
Map dataAll = {};
Map lastDataAll = {};
List<bool> dataFetched = [];

class Stocks extends StatefulWidget {
  @override
  _StocksState createState() => _StocksState();
}

class _StocksState extends State<Stocks> {
  String getInitials(String nameString) {
    if (nameString.isEmpty) return " ";

    List<String> nameArray =
        nameString.replaceAll(new RegExp(r"\s+\b|\b\s"), " ").split(" ");
    String initials = ((nameArray[0])[0] != null ? (nameArray[0])[0] : " ") +
        (nameArray.length == 1 ? " " : (nameArray[nameArray.length - 1])[0]);

    return initials;
  }

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

  TextEditingController editingController = TextEditingController();
  final duplicateItems = bse_names;
  var items = List<String>();

  void filterSearchResults(String query) {
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item) {
        if (item.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }

  StockData stock = StockData();

  void getstock() async {
    for (int b = 0; b < 20; b++) {
      try {
        Map dataMap = await stock.getdata(bse_codes[b]
            .toString()
            .replaceAll("{", "")
            .replaceAll("}", "")
            .split(': ')[1]
            .toString());

        setState(
          () {
            dataAll["stock$b"] = dataMap["data0"];
            lastDataAll["stock$b"] = dataMap["data1"];
            graphs["stock$b"] = new List();
          },
        );

        for (var c = 0; c < 30; c++) {
          graphs["stock$b"].add(
            new GridSeries(
                date: dataMap["data$c"]["date"],
                close: dataMap["data$c"]["close"]),
          );
        }
        // print("Graph is " + graphs.toString());
        setState(() {
          dataFetched[b] = true;
        });
        // print(data["data0"].toString());
      } catch (e) {
        print(e);
      }
    }
    print(dataAll.toString());
  }

  @override
  void initState() {
    items.addAll(duplicateItems);
    super.initState();
    for (int a = 0; a < 5000; a++) {
      dataFetched.add(false);
    }
    getstock();
  }

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1440, allowFontScaling: true);
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (value) {
              filterSearchResults(value);
            },
            controller: editingController,
            decoration: InputDecoration(
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
              // border: OutlineInputBorder(
              //     borderRadius: BorderRadius.all(Radius.circular(5.0)))
            ),
          ),
        ),
        Expanded(
          child: Scrollbar(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 0.70,
                crossAxisCount: 2,
              ),
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, position) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                  child: Stack(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) {
                                return Info(
                                    bse_codes[
                                            bse_names.indexOf(items[position])]
                                        .toString()
                                        .replaceAll("{", "")
                                        .replaceAll("}", "")
                                        .replaceAll(" EOD Prices", "")
                                        .replaceAll("-", "")
                                        .split(': ')[0]
                                        .toString(),
                                    bse_codes[
                                            bse_names.indexOf(items[position])]
                                        .toString()
                                        .replaceAll("{", "")
                                        .replaceAll("}", "")
                                        .split(': ')[1]
                                        .toString());
                              },
                            ),
                          );
                          print(bse_codes[bse_names.indexOf(items[position])]
                              .toString()
                              .replaceAll("{", "")
                              .replaceAll("}", "")
                              .split(': ')[1]
                              .toString());
                        },
                        child: Card(
                          color: Colors.pink[50],
                          elevation: 2,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 195,
                                  width: 195,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        child: Container(
                                          decoration: dataFetched[bse_names
                                                  .indexOf(items[position])]
                                              ? BoxDecoration(
                                                  color: Colors.white)
                                              : BoxDecoration(
                                                  gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                      colors: [
                                                      color1,
                                                      color2
                                                    ])),
                                          child:
                                              SizedBox(width: 195, height: 195),
                                        ),
                                      ),
                                      // InitialNameAvatar(
                                      //   items[position],
                                      //   circleAvatar: true,
                                      //   backgroundColor: _randomColor.randomColor(
                                      //       colorBrightness: ColorBrightness.light),
                                      //   foregroundColor: Colors.black12,
                                      //   textSize: 25.0,
                                      // ),
                                      dataFetched[bse_names
                                              .indexOf(items[position])]
                                          ? Align(
                                              alignment: Alignment.topCenter,
                                              child: Text(
                                                getInitials(items[position]),
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.black87),
                                              ),
                                            )
                                          : Text(
                                              getInitials(items[position]),
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.black87),
                                            ),

                                      dataFetched[bse_names
                                              .indexOf(items[position])]
                                          ? GridChart(
                                              dataChart: graphs[
                                                  "stock${bse_names.indexOf(items[position])}"],
                                            )
                                          : CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      Colors.white12),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 270,
                                      child: Text(
                                        titleCase(items[position])
                                            .replaceAll(" Ltd.", "")
                                            .replaceAll(" Ltd", "")
                                            .replaceAll(".ltd.", ""),
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18),
                                      ),
                                    ),
                                    Text(
                                      items[position],
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 12),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          dataFetched[bse_names
                                                  .indexOf(items[position])]
                                              ? dataAll["stock${bse_names.indexOf(items[position])}"]
                                                      ["close"]
                                                  .toString()
                                              : '',
                                          style: TextStyle(
                                              color: Colors.pink,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12),
                                        ),
                                        Text(' '),
                                        Text(
                                          dataFetched[bse_names
                                                  .indexOf(items[position])]
                                              ? " ${(dataAll["stock${bse_names.indexOf(items[position])}"]["close"] - lastDataAll["stock${bse_names.indexOf(items[position])}"]["close"]).toStringAsFixed(2)} "
                                              : '',
                                          style: TextStyle(
                                              backgroundColor: dataFetched[
                                                      bse_names.indexOf(
                                                          items[position])]
                                                  ? dataAll["stock${bse_names.indexOf(items[position])}"]
                                                              ["close"] >=
                                                          lastDataAll[
                                                                  "stock${bse_names.indexOf(items[position])}"]
                                                              ["close"]
                                                      ? Colors.green
                                                      : Colors.red
                                                  : Colors.white,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: IconButton(
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onPressed: () {
                              print("Hello");
                            },
                            icon: Icon(
                              Icons.favorite_border,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
