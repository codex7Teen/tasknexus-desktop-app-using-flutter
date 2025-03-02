// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskModelAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = 2;

  @override
  TaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskModel(
      urn: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      commencementDate: fields[3] as String,
      dueDate: fields[4] as String,
      assignedTo: fields[5] as String,
      assignedBy: fields[6] as String,
      clientName: fields[7] as String,
      status: fields[8] as String,
      userEmail: fields[9] as String,
      clientContacts: (fields[10] as List).cast<ClientContactModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.urn)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.commencementDate)
      ..writeByte(4)
      ..write(obj.dueDate)
      ..writeByte(5)
      ..write(obj.assignedTo)
      ..writeByte(6)
      ..write(obj.assignedBy)
      ..writeByte(7)
      ..write(obj.clientName)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.userEmail)
      ..writeByte(10)
      ..write(obj.clientContacts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
