// task_commencement_state.dart
part of 'task_commencement_bloc.dart';

abstract class TaskCommencementState extends Equatable {
  const TaskCommencementState();

  @override
  List<Object?> get props => [];
}

//! Initial state when task commencement hasn't started yet
class TaskCommencementInitial extends TaskCommencementState {}

//! State representing loading process
class TaskCommencementLoading extends TaskCommencementState {}

//! State when task commencement data is successfully loaded
class TaskCommencementLoaded extends TaskCommencementState {
  final GeneralDataModel generalData;
  final int selectedSchoolIndex;

  const TaskCommencementLoaded({
    required this.generalData,
    required this.selectedSchoolIndex,
  });

  @override
  List<Object?> get props => [generalData, selectedSchoolIndex];
}

//! State when an error occurs in task commencement
class TaskCommencementFailure extends TaskCommencementState {
  final String message;

  const TaskCommencementFailure(this.message);

  @override
  List<Object?> get props => [message];
}

//! State when the task is successfully completed
class TaskCommencementCompleted extends TaskCommencementState {}
