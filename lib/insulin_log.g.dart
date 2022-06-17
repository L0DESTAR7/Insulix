// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insulin_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InsulinLogAdapter extends TypeAdapter<InsulinLog> {
  @override
  final int typeId = 2;

  @override
  InsulinLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InsulinLog(
      fields[0] as double,
      fields[1] as double,
      fields[2] as int,
      fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, InsulinLog obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.fastinsulin_dose)
      ..writeByte(1)
      ..write(obj.basalinsulin_dose)
      ..writeByte(2)
      ..write(obj.before_after)
      ..writeByte(3)
      ..write(obj.dateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InsulinLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
