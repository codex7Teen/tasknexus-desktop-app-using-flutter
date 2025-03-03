// task_commencement_event.dart
part of 'task_commencement_bloc.dart';

abstract class TaskCommencementEvent extends Equatable {
  const TaskCommencementEvent();

  @override
  List<Object?> get props => [];
}

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

class CompleteTask extends TaskCommencementEvent {
  final String taskUrn;
  final String userEmail;

  const CompleteTask({
    required this.taskUrn,
    required this.userEmail,
  });

  @override
  List<Object?> get props => [taskUrn, userEmail];
}

class ChangeSelectedSchool extends TaskCommencementEvent {
  final int schoolIndex;

  const ChangeSelectedSchool(this.schoolIndex);

  @override
  List<Object?> get props => [schoolIndex];
}
