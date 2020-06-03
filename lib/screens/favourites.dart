import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:stocks_app/ui/grid_graph.dart';
import 'package:stocks_app/ui/searchBar.dart';
import 'package:stocks_app/data/stock.dart';
import 'package:stocks_app/ui/stockTile.dart';
import 'package:stocks_app/data/stock_day.dart';
import 'package:stocks_app/data/stocksData.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_app/data/bseCodesData.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
// import 'package:stocks_app/data/stockDataModel.dart';

// ->Globals

// Thumbnail Graphs
Map<String, List<GridSeries>> graphs = {};

// Data Vars
Map dataAll = {};
Map lastDataAll = {};
List<bool> dataFetched = [];

// Global Refresh Indicator Key
var refreshKey = GlobalKey<RefreshIndicatorState>();

// Hive Box
var _box = Hive.box<StockModel>('stocks');
var _fav = Hive.box('fav_stocks');
bool favLoaded = true;

// ->Stocks Widget
class Favourites extends StatefulWidget {
  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  // StockData Object which is used to fetch stocks data
  StockData stock = StockData();

  void getstock() async {
    items = [];
    for (int b = 0; b < bse_codes.length; b++) {
      if (_fav.get(
            bse_codes[b]
                .toString()
                .replaceAll("{", "")
                .replaceAll("}", "")
                .split(': ')[1]
                .toString(),
          ) ==
          true) {
        try {
          if (_box.get(
                bse_codes[b]
                    .toString()
                    .replaceAll("{", "")
                    .replaceAll("}", "")
                    .split(': ')[1]
                    .toString(),
              ) ==
              null) {
            // Fetching data for each code
            StockModel dataMap = await stock.getdata(
              // Extracting Stock Code
              bse_codes[b]
                  .toString()
                  .replaceAll("{", "")
                  .replaceAll("}", "")
                  .split(': ')[1]
                  .toString(),
            );

            // Map<String, StockDayModel> newData = {};
            // for (var p = 0; p < 30; p++) {
            //   newData["data$p"] = StockDayModel(
            //     dataMap.stockData["data$p"].date,
            //     dataMap.stockData["data$p"].open,
            //     dataMap.stockData["data$p"].high,
            //     dataMap.stockData["data$p"].low,
            //     dataMap.stockData["data$p"].close,
            //     dataMap.stockData["data$p"].turn,
            //     dataMap.stockData["data$p"].dqtq,
            //   );
            // }
            // _box.put(dataMap.code, StockModel(dataMap.code, dataMap.stockData));
            _box.put(dataMap.code, dataMap);
            print("Written");
            print(_box.get(dataMap.code));

            setState(
              () {
                dataAll["stock$b"] = dataMap.stockData["data0"]; // Latest Data
                lastDataAll["stock$b"] =
                    dataMap.stockData["data1"]; // Last Day's Data
                graphs["stock$b"] =
                    new List(); // Initialising List to Store Graphs
              },
            );

            // Adding Graph for Last 30 Days
            for (var c = 0; c < 30; c++) {
              graphs["stock$b"].add(
                new GridSeries(
                    date: dataMap.stockData["data$c"].date,
                    close: dataMap.stockData["data$c"].close),
              );
            }

            // Data is Fetched
            setState(() {
              dataFetched[b] = true;
            });
          } else {
            StockModel dataMap = _box.get(
              bse_codes[b]
                  .toString()
                  .replaceAll("{", "")
                  .replaceAll("}", "")
                  .split(': ')[1]
                  .toString(),
            );
            dataAll["stock$b"] = dataMap.stockData["data0"]; // Latest Data
            lastDataAll["stock$b"] =
                dataMap.stockData["data1"]; // Last Day's Data
            graphs["stock$b"] = new List(); // Initialising List to Store Graphs

            // Adding Graph for Last 30 Days
            for (var c = 0; c < 30; c++) {
              graphs["stock$b"].add(
                new GridSeries(
                    date: dataMap.stockData["data$c"].date,
                    close: dataMap.stockData["data$c"].close),
              );
            }

            // Data is Fetched
            setState(() {
              dataFetched[b] = true;
            });
            if (_box
                    .get(
                      bse_codes[b]
                          .toString()
                          .replaceAll("{", "")
                          .replaceAll("}", "")
                          .split(': ')[1]
                          .toString(),
                    )
                    .date !=
                DateFormat("yy-MM-dd").format(DateTime.now())) {
              // Fetching data for each code
              StockModel dataMap = await stock.getdata(
                // Extracting Stock Code
                bse_codes[b]
                    .toString()
                    .replaceAll("{", "")
                    .replaceAll("}", "")
                    .split(': ')[1]
                    .toString(),
              );

              // Map<String, StockDayModel> newData = {};
              // for (var p = 0; p < 30; p++) {
              //   newData["data$p"] = StockDayModel(
              //     dataMap.stockData["data$p"].date,
              //     dataMap.stockData["data$p"].open,
              //     dataMap.stockData["data$p"].high,
              //     dataMap.stockData["data$p"].low,
              //     dataMap.stockData["data$p"].close,
              //     dataMap.stockData["data$p"].turn,
              //     dataMap.stockData["data$p"].dqtq,
              //   );
              // }
              // _box.put(dataMap.code, StockModel(dataMap.code, dataMap.stockData));
              _box.put(dataMap.code, dataMap);
              print("Written");
              print(_box.get(dataMap.code));

              setState(
                () {
                  dataAll["stock$b"] =
                      dataMap.stockData["data0"]; // Latest Data
                  lastDataAll["stock$b"] =
                      dataMap.stockData["data1"]; // Last Day's Data
                  graphs["stock$b"] =
                      new List(); // Initialising List to Store Graphs
                },
              );

              // Adding Graph for Last 30 Days
              for (var c = 0; c < 30; c++) {
                graphs["stock$b"].add(
                  new GridSeries(
                      date: dataMap.stockData["data$c"].date,
                      close: dataMap.stockData["data$c"].close),
                );
              }
            }
          }
        } catch (e) {
          print(e);
        }
        items.add(bse_names[b]);
        // Data is Fetched
        setState(() {
          dataFetched[b] = true;
        });
      }
    }
    // print(dataAll.toString());
  }

  // Search Input Text Controllers
  // TextEditingController editingController = TextEditingController();
  // final duplicateItems = bse_names;
  var items = List<String>();

  @override
  void initState() {
    getstock(); // Get data as soon as initialised
    // items.addAll(duplicateItems); // Initialising Search Filter
    super.initState();
    for (int a = 0; a < 5000; a++) {
      dataFetched.add(false); // Setting Data is not Fetched for every Stock
    }
  }

  // @override
  // void dispose() {
  //   editingController.dispose();
  //   super.dispose();
  // }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: true);
    await Future.delayed(Duration(seconds: 1));
    getstock();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1440, allowFontScaling: true);
    return RefreshIndicator(
      child: Column(
        children: <Widget>[
          // Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: SearchBar(editingController, duplicateItems, items)),
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
                  return StockTile(
                      ValueKey(bse_codes[position]),
                      items,
                      position,
                      dataFetched,
                      dataAll,
                      lastDataAll,
                      graphs,
                      favLoaded);
                },
              ),
            ),
          ),
        ],
      ),
      onRefresh: refreshList,
    );
  }
}
