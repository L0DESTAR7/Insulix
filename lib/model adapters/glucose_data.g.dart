// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../models/glucose_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GlucoseDataAdapter extends TypeAdapter<GlucoseData> {
  @override
  final int typeId = 0;

  @override
  GlucoseData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GlucoseData()
      ..latestLog = fields[0] as double
      ..Logs = (fields[1] as List).cast<double>()
      ..BeforeAfter = (fields[2] as List).cast<int>()
      ..LogTime = (fields[3] as List).cast<DateTime>();
  }

  @override
  void write(BinaryWriter writer, GlucoseData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.latestLog)
      ..writeByte(1)
      ..write(obj.Logs)
      ..writeByte(2)
      ..write(obj.BeforeAfter)
      ..writeByte(3)
      ..write(obj.LogTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GlucoseDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
