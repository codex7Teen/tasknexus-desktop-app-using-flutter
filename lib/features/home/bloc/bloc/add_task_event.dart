part of 'add_task_bloc.dart';

/// Abstract class representing all events related to adding or updating a task.
abstract class AddTaskEvent extends Equatable {
  const AddTaskEvent();

  @override
  List<Object?> get props => [];
}

/// Event triggered when initializing the Add Task screen.
/// If [urn] is provided, the task is loaded for editing.
class AddTaskInitial extends AddTaskEvent {
  final String? urn;
  final String? currentUserName;

  const AddTaskInitial({this.urn, required this.currentUserName});

  @override
  List<Object?> get props => [urn, currentUserName];
}

/// Event triggered when saving a new task.
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

/// Event triggered when updating an existing task.
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

/// Event triggered to load an existing task using its [urn].
class AddTaskLoadExisting extends AddTaskEvent {
  final String urn;
  final String userEmail;

  const AddTaskLoadExisting({required this.urn, required this.userEmail});

  @override
  List<Object?> get props => [urn, userEmail];
}
