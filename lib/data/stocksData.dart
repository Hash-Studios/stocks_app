import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
// import 'package:stocks_app/data/stockDataModel.dart';
// import 'package:stocks_app/data/stockDayDataModel.dart';
import 'package:stocks_app/data/stock.dart';
import 'package:stocks_app/data/stock_day.dart';

class StockData {
  List bseNames;
  Future getdata(String code) async {
    String fetchUrl =
        "https://www.quandl.com/api/v3/datasets/BSE/$code/data.json?api_key=wrCX6Fs2x_M-ZyJ8aPQX";
    http.Response response = await http.get(fetchUrl);
    if (response.statusCode == 200) {
      var fetchdata = jsonDecode(response.body);
      Map datasetData = fetchdata["dataset_data"];
      List data = datasetData["data"];
      // Map<String, StockDayDataModel> totalData1 = {};
      Map<String, StockDayModel> totalData1 = {};
      // To fetch data for last 30 Days
      for (var i = 0; i < 30; i++) {
        StockDayModel dataMap = StockDayModel(
          data[i][0].toString(),
          data[i][1],
          data[i][2],
          data[i][3],
          data[i][4],
          data[i][8],
          data[i][10],
        );
        // StockDayDataModel dataMap = StockDayDataModel(
        //   date: data[i][0].toString(),
        //   open: data[i][1],
        //   high: data[i][2],
        //   low: data[i][3],
        //   close: data[i][4],
        //   turn: data[i][8],
        //   dqtq: data[i][10],
        // );
        // Map dataMap = {
        //   'date': data[i][0].toString(),
        //   'open': data[i][1],
        //   'high': data[i][2],
        //   'low': data[i][3],
        //   'close': data[i][4],
        //   'turn': data[i][8],
        //   'dqtq': data[i][10]
        // };
        // totalData1["data$i"] = dataMap;
        totalData1["data$i"] = dataMap;
      }
      // StockDataModel totalData = StockDataModel(
      //   code: code,
      //   stockData: totalData1,
      // );
      StockModel totalData = StockModel(
        code,
        DateFormat("yy-MM-dd").format(DateTime.now()),
        totalData1,
      );
      return totalData;
    } else {
      print(response.statusCode);
      throw 'cant fetch data';
    }
  }
}
