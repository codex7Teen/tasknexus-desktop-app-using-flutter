// task_commencement_state.dart
part of 'task_commencement_bloc.dart';

abstract class TaskCommencementState extends Equatable {
  const TaskCommencementState();

  @override
  List<Object?> get props => [];
}

class TaskCommencementInitial extends TaskCommencementState {}

class TaskCommencementLoading extends TaskCommencementState {}

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

class TaskCommencementFailure extends TaskCommencementState {
  final String message;

  const TaskCommencementFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class TaskCommencementCompleted extends TaskCommencementState {}
