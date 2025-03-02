// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_contact_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClientContactModelAdapter extends TypeAdapter<ClientContactModel> {
  @override
  final int typeId = 3;

  @override
  ClientContactModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClientContactModel(
      name: fields[0] as String,
      designation: fields[1] as String,
      email: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ClientContactModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.designation)
      ..writeByte(2)
      ..write(obj.email);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClientContactModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
