// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'general_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GeneralDataModelAdapter extends TypeAdapter<GeneralDataModel> {
  @override
  final int typeId = 4;

  @override
  GeneralDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GeneralDataModel(
      taskUrn: fields[0] as String,
      areaName: fields[1] as String,
      totalSchools: fields[2] as int,
      schools: (fields[3] as List).cast<SchoolDataModel>(),
      userEmail: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GeneralDataModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.taskUrn)
      ..writeByte(1)
      ..write(obj.areaName)
      ..writeByte(2)
      ..write(obj.totalSchools)
      ..writeByte(3)
      ..write(obj.schools)
      ..writeByte(4)
      ..write(obj.userEmail);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeneralDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
