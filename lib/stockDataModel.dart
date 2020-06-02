import 'package:stocks_app/stockDayDataModel.dart';

class StockDataModel {
  String code;
  Map<String, StockDayDataModel> stockData;
  StockDataModel({this.code, this.stockData});
}
