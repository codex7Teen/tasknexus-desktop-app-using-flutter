part of 'add_task_bloc.dart';

abstract class AddTaskState extends Equatable {
  const AddTaskState();

  @override
  List<Object?> get props => [];
}

final class AddTaskInitialState extends AddTaskState {}

class AddTaskLoading extends AddTaskState {}

class AddTaskSuccess extends AddTaskState {
  final String message;

  const AddTaskSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AddTaskFailure extends AddTaskState {
  final String error;

  const AddTaskFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class AddTaskLoaded extends AddTaskState {
  final TaskModel task;

  const AddTaskLoaded(this.task);

  @override
  List<Object?> get props => [task];
}
