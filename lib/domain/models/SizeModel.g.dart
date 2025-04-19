// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SizeModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SizeModelAdapter extends TypeAdapter<SizeModel> {
  @override
  final int typeId = 1;

  @override
  SizeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SizeModel(
      color: fields[0] as String,
      sizes: (fields[1] as List).cast<SizeQuantityModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, SizeModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.color)
      ..writeByte(1)
      ..write(obj.sizes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SizeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SizeQuantityModelAdapter extends TypeAdapter<SizeQuantityModel> {
  @override
  final int typeId = 2;

  @override
  SizeQuantityModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SizeQuantityModel(
      name: fields[0] as String,
      quantity: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SizeQuantityModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SizeQuantityModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
