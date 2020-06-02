import 'package:hive/hive.dart';
import 'package:stocks_app/stock_day.dart';

part 'stock.g.dart';

@HiveType(typeId: 0)
@HiveType()
class StockModel {
  @HiveField(0)
  String code;

  @HiveField(1)
  Map<String, StockDayModel> stockData;

  StockModel(this.code, this.stockData);
}
