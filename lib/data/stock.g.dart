// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StockModelAdapter extends TypeAdapter<StockModel> {
  @override
  final typeId = 0;
  @override
  StockModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StockModel(
      fields[0] as String,
      fields[1] as String,
      (fields[2] as Map)?.cast<String, StockDayModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, StockModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.stockData);
  }
}
