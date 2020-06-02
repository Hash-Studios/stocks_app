// import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:stocks_app/grid_graph.dart';
import 'package:stocks_app/searchBar.dart';
import 'package:stocks_app/stockTile.dart';
import 'package:stocks_app/stocksData.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_app/bseCodesData.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:stocks_app/stockDataDayModel.dart';
import 'package:stocks_app/stockDataModel.dart';

// ->Globals

// Thumbnail Graphs
Map<String, List<GridSeries>> graphs = {};

// Data Vars
Map dataAll = {};
Map lastDataAll = {};
List<bool> dataFetched = [];

// ->Stocks Widget
class Stocks extends StatefulWidget {
  @override
  _StocksState createState() => _StocksState();
}

class _StocksState extends State<Stocks> {
  // StockData Object which is used to fetch stocks data
  StockData stock = StockData();

  void getstock() async {
    // For only 20 stocks
    for (int b = 0; b < 20; b++) {
      try {
        // Fetching data for each code
        StockDataModel dataMap = await stock.getdata(
          // Extracting Stock Code
          bse_codes[b]
              .toString()
              .replaceAll("{", "")
              .replaceAll("}", "")
              .split(': ')[1]
              .toString(),
        );

        setState(
          () {
            dataAll["stock$b"] = dataMap.stockData["data0"]; // Latest Data
            lastDataAll["stock$b"] =
                dataMap.stockData["data1"]; // Last Day's Data
            graphs["stock$b"] = new List(); // Initialising List to Store Graphs
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
      } catch (e) {
        print(e);
      }
    }
    // print(dataAll.toString());
  }

  // Search Input Text Controllers
  TextEditingController editingController = TextEditingController();
  final duplicateItems = bse_names;
  var items = List<String>();

  // Future<Void> initHive() async {
  //   final dir = await getApplicationDocumentsDirectory();
  //   Hive.init(dir.path);
  //   var _box = await Hive.openBox('stocks_data');
  //   _box.put('name', 'Greg');
  //   print(_box.get('name'));
  // }

  @override
  void initState() {
    // initHive();
    items.addAll(duplicateItems); // Initialising Search Filter
    super.initState();
    for (int a = 0; a < 5000; a++) {
      dataFetched.add(false); // Setting Data is not Fetched for every Stock
    }
    getstock(); // Get data as soon as initialised
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
            child: SearchBar(editingController, duplicateItems, items)),
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
                    items, position, dataFetched, dataAll, lastDataAll, graphs);
              },
            ),
          ),
        ),
      ],
    );
  }
}
