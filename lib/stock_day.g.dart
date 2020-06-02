// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_day.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StockDayModelAdapter extends TypeAdapter<StockDayModel> {
  @override
  final typeId = 1;
  @override
  StockDayModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StockDayModel(
      fields[0] as String,
      fields[1] as double,
      fields[2] as double,
      fields[3] as double,
      fields[4] as double,
      fields[5] as double,
      fields[6] as double,
    );
  }

  @override
  void write(BinaryWriter writer, StockDayModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.open)
      ..writeByte(2)
      ..write(obj.high)
      ..writeByte(3)
      ..write(obj.low)
      ..writeByte(4)
      ..write(obj.close)
      ..writeByte(5)
      ..write(obj.turn)
      ..writeByte(6)
      ..write(obj.dqtq);
  }
}
