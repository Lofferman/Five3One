// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lift_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LiftDataAdapter extends TypeAdapter<LiftData> {
  @override
  final int typeId = 0;

  @override
  LiftData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LiftData(
      liftTotal: fields[0] as num,
      liftType: fields[1] as String,
      createdAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, LiftData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.liftTotal)
      ..writeByte(1)
      ..write(obj.liftType)
      ..writeByte(3)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LiftDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
