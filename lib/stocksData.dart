import 'dart:convert';
import 'package:http/http.dart' as http;

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
      Map totalData = {};
      // To fetch data for last 30 Days
      for (var i = 0; i < 30; i++) {
        Map dataMap = {
          'date': data[i][0].toString(),
          'open': data[i][1],
          'high': data[i][2],
          'low': data[i][3],
          'close': data[i][4],
          'turn': data[i][8],
          'dqtq': data[i][10]
        };
        totalData["data$i"] = dataMap;
      }
      return totalData;
    } else {
      print(response.statusCode);
      throw 'cant fetch data';
    }
  }
}
