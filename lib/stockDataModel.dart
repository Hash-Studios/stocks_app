import 'package:stocks_app/stockDataDayModel.dart';

class StockDataModel {
  String code;
  Map<String, StockDayDataModel> stockData;
  StockDataModel({this.code, this.stockData});
}
