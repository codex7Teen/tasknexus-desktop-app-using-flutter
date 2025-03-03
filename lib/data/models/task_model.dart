import 'package:hive_flutter/adapters.dart';
import 'package:tasknexus/data/models/client_contact_model.dart';
part 'task_model.g.dart';

// Hive model for storing tasks
@HiveType(typeId: 2)
class TaskModel extends HiveObject {
  static const String boxName = 'Tasks_db';
  // Task details
  @HiveField(0)
  final String urn;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String commencementDate;

  @HiveField(4)
  final String dueDate;

  @HiveField(5)
  final String assignedTo;

  @HiveField(6)
  final String assignedBy;

  @HiveField(7)
  final String clientName;

  @HiveField(8)
  final String status; // Task progress status

  @HiveField(9)
  final String userEmail; // Task progress status

  @HiveField(10)
  final List<ClientContactModel> clientContacts;
  // Constructor to initialize task details
  TaskModel({
    required this.urn,
    required this.name,
    required this.description,
    required this.commencementDate,
    required this.dueDate,
    required this.assignedTo,
    required this.assignedBy,
    required this.clientName,
    this.status = 'Not Started',
    required this.userEmail,
    required this.clientContacts,
  });
  // Creates a modified copy of the task
  TaskModel copyWith({
    String? urn,
    String? name,
    String? description,
    String? commencementDate,
    String? dueDate,
    String? assignedTo,
    String? assignedBy,
    String? clientName,
    String? status,
    String? userEmail,
    List<ClientContactModel>? clientContacts,
  }) {
    return TaskModel(
      urn: urn ?? this.urn,
      name: name ?? this.name,
      description: description ?? this.description,
      commencementDate: commencementDate ?? this.commencementDate,
      dueDate: dueDate ?? this.dueDate,
      assignedTo: assignedTo ?? this.assignedTo,
      assignedBy: assignedBy ?? this.assignedBy,
      clientName: clientName ?? this.clientName,
      status: status ?? this.status,
      userEmail: userEmail ?? this.userEmail,
      clientContacts: clientContacts ?? this.clientContacts,
    );
  }
}
