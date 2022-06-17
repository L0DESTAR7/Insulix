// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'glucose_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GlucoseLogAdapter extends TypeAdapter<GlucoseLog> {
  @override
  final int typeId = 1;

  @override
  GlucoseLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GlucoseLog(
      fields[0] as double,
      fields[1] as int,
      fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, GlucoseLog obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.log)
      ..writeByte(1)
      ..write(obj.before_after)
      ..writeByte(2)
      ..write(obj.dateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GlucoseLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
