// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'school_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SchoolDataModelAdapter extends TypeAdapter<SchoolDataModel> {
  @override
  final int typeId = 5;

  @override
  SchoolDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SchoolDataModel(
      name: fields[0] as String,
      type: fields[1] as String,
      curriculum: (fields[2] as List).cast<String>(),
      establishedDate: fields[3] as String,
      grades: (fields[4] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, SchoolDataModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.curriculum)
      ..writeByte(3)
      ..write(obj.establishedDate)
      ..writeByte(4)
      ..write(obj.grades);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchoolDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
