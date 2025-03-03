part of 'task_commencement_bloc.dart';

abstract class TaskCommencementEvent extends Equatable {
  const TaskCommencementEvent();

  @override
  List<Object?> get props => [];
}

//! Event to initialize task commencement
class InitializeTaskCommencement extends TaskCommencementEvent {
  final String taskUrn;
  final String userEmail;

  const InitializeTaskCommencement({
    required this.taskUrn,
    required this.userEmail,
  });

  @override
  List<Object?> get props => [taskUrn, userEmail];
}

//! Event to save general data
class SaveGeneralData extends TaskCommencementEvent {
  final String taskUrn;
  final String areaName;
  final int totalSchools;
  final String userEmail;

  const SaveGeneralData({
    required this.taskUrn,
    required this.areaName,
    required this.totalSchools,
    required this.userEmail,
  });

  @override
  List<Object?> get props => [taskUrn, areaName, totalSchools, userEmail];
}

//! Event to update school-specific data
class UpdateSchoolData extends TaskCommencementEvent {
  final String taskUrn;
  final int schoolIndex;
  final String schoolName;
  final String schoolType;
  final List<String> curriculum;
  final String establishedDate;
  final List<String> grades;
  final String userEmail;

  const UpdateSchoolData({
    required this.taskUrn,
    required this.schoolIndex,
    required this.schoolName,
    required this.schoolType,
    required this.curriculum,
    required this.establishedDate,
    required this.grades,
    required this.userEmail,
  });

  @override
  List<Object?> get props => [
    taskUrn,
    schoolIndex,
    schoolName,
    schoolType,
    curriculum,
    establishedDate,
    grades,
    userEmail,
  ];
}

//! Event to complete the task
class CompleteTask extends TaskCommencementEvent {
  final String taskUrn;
  final String userEmail;

  const CompleteTask({required this.taskUrn, required this.userEmail});

  @override
  List<Object?> get props => [taskUrn, userEmail];
}

//! Event to change the selected school index
class ChangeSelectedSchool extends TaskCommencementEvent {
  final int schoolIndex;

  const ChangeSelectedSchool(this.schoolIndex);

  @override
  List<Object?> get props => [schoolIndex];
}
