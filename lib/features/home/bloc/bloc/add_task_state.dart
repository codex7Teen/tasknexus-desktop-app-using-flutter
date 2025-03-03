part of 'add_task_bloc.dart';

/// Base class for all AddTask states.
abstract class AddTaskState extends Equatable {
  const AddTaskState();

  @override
  List<Object?> get props => [];
}

/// Initial state when no action has been performed yet.
final class AddTaskInitialState extends AddTaskState {}

/// State when a task operation (like save or update) is in progress.
class AddTaskLoading extends AddTaskState {}

/// State when a task operation is successfully completed.
class AddTaskSuccess extends AddTaskState {
  final String message;

  const AddTaskSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// State when a task operation fails.
class AddTaskFailure extends AddTaskState {
  final String error;

  const AddTaskFailure(this.error);

  @override
  List<Object?> get props => [error];
}

/// State when a task is successfully loaded.
class AddTaskLoaded extends AddTaskState {
  final TaskModel task;

  const AddTaskLoaded(this.task);

  @override
  List<Object?> get props => [task];
}
