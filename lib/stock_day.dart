import 'package:hive/hive.dart';

part 'stock_day.g.dart';

@HiveType(typeId: 1)
@HiveType()
class StockDayModel {
  @HiveField(0)
  String date;
  @HiveField(1)
  double open;
  @HiveField(2)
  double high;
  @HiveField(3)
  double low;
  @HiveField(4)
  double close;
  @HiveField(5)
  double turn;
  @HiveField(6)
  double dqtq;

  StockDayModel(
    this.date,
    this.open,
    this.high,
    this.low,
    this.close,
    this.turn,
    this.dqtq,
  );
}
