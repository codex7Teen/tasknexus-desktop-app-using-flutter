part of 'add_task_bloc.dart';

abstract class AddTaskEvent extends Equatable {
  const AddTaskEvent();

  @override
  List<Object?> get props => [];
}

class AddTaskInitial extends AddTaskEvent {
  final String? urn;
  final String? currentUserName;

  const AddTaskInitial({this.urn, required this.currentUserName});

  @override
  List<Object?> get props => [urn, currentUserName];
}

class AddTaskSave extends AddTaskEvent {
  final String taskName;
  final String urn;
  final String description;
  final String commencementDate;
  final String dueDate;
  final String assignedTo;
  final String assignedBy;
  final String clientName;
  final List<List<TextEditingController>> clientDetailsControllers;
  final String userEmail;

  const AddTaskSave({
    required this.taskName,
    required this.urn,
    required this.description,
    required this.commencementDate,
    required this.dueDate,
    required this.assignedTo,
    required this.assignedBy,
    required this.clientName,
    required this.clientDetailsControllers,
    required this.userEmail,
  });

  @override
  List<Object?> get props => [
    taskName,
    urn,
    description,
    commencementDate,
    dueDate,
    assignedTo,
    assignedBy,
    clientName,
    clientDetailsControllers,
    userEmail,
  ];
}

class AddTaskUpdate extends AddTaskEvent {
  final String taskName;
  final String urn;
  final String description;
  final String commencementDate;
  final String dueDate;
  final String assignedTo;
  final String assignedBy;
  final String clientName;
  final List<List<TextEditingController>> clientDetailsControllers;
  final String userEmail;
  final String? status;

  const AddTaskUpdate({
    required this.taskName,
    required this.urn,
    required this.description,
    required this.commencementDate,
    required this.dueDate,
    required this.assignedTo,
    required this.assignedBy,
    required this.clientName,
    required this.clientDetailsControllers,
    required this.userEmail,
    this.status,
  });

  @override
  List<Object?> get props => [
    taskName,
    urn,
    description,
    commencementDate,
    dueDate,
    assignedTo,
    assignedBy,
    clientName,
    clientDetailsControllers,
    userEmail,
    status,
  ];
}

class AddTaskLoadExisting extends AddTaskEvent {
  final String urn;
  final String userEmail;

  const AddTaskLoadExisting({
    required this.urn,
    required this.userEmail,
  });

  @override
  List<Object?> get props => [urn, userEmail];
}