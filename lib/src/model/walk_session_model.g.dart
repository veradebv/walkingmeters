// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'walk_session_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WalkSessionAdapter extends TypeAdapter<WalkSession> {
  @override
  final int typeId = 1;

  @override
  WalkSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WalkSession(
      date: fields[0] as DateTime,
      distanceMeters: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, WalkSession obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.distanceMeters);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalkSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
