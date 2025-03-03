import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasknexus/data/models/general_data_model.dart';
import 'package:tasknexus/data/services/task_commencement_service.dart';
part 'task_commencement_event.dart';
part 'task_commencement_state.dart';

class TaskCommencementBloc extends Bloc<TaskCommencementEvent, TaskCommencementState> {
  final TaskCommencementService _service = TaskCommencementService();
  
  TaskCommencementBloc() : super(TaskCommencementInitial()) {
    on<InitializeTaskCommencement>(_onInitializeTaskCommencement);
    on<SaveGeneralData>(_onSaveGeneralData);
    on<UpdateSchoolData>(_onUpdateSchoolData);
    on<CompleteTask>(_onCompleteTask);
    on<ChangeSelectedSchool>(_onChangeSelectedSchool);
  }
  
  Future<void> _onInitializeTaskCommencement(
    InitializeTaskCommencement event, 
    Emitter<TaskCommencementState> emit
  ) async {
    emit(TaskCommencementLoading());
    try {
      final generalData = await _service.getGeneralData(event.taskUrn);
      
      if (generalData != null) {
        // Data already exists, load it
        emit(TaskCommencementLoaded(
          generalData: generalData,
          selectedSchoolIndex: 0,
        ));
      } else {
        // No data exists, start fresh
        emit(TaskCommencementInitial());
      }
    } catch (e) {
      log('Error initializing task commencement: $e');
      emit(TaskCommencementFailure('Failed to initialize: $e'));
    }
  }
  
  Future<void> _onSaveGeneralData(
    SaveGeneralData event, 
    Emitter<TaskCommencementState> emit
  ) async {
    emit(TaskCommencementLoading());
    try {
      final success = await _service.saveGeneralData(
        taskUrn: event.taskUrn,
        areaName: event.areaName,
        totalSchools: event.totalSchools,
        userEmail: event.userEmail,
      );
      
      if (success) {
        final generalData = await _service.getGeneralData(event.taskUrn);
        
        if (generalData != null) {
          emit(TaskCommencementLoaded(
            generalData: generalData,
            selectedSchoolIndex: 0,
          ));
        } else {
          emit(TaskCommencementFailure('Failed to load saved data'));
        }
      } else {
        emit(TaskCommencementFailure('Failed to save general data'));
      }
    } catch (e) {
      log('Error saving general data: $e');
      emit(TaskCommencementFailure('Failed to save general data: $e'));
    }
  }
  
  Future<void> _onUpdateSchoolData(
    UpdateSchoolData event, 
    Emitter<TaskCommencementState> emit
  ) async {
    emit(TaskCommencementLoading());
    try {
      final success = await _service.updateSchoolData(
        taskUrn: event.taskUrn,
        schoolIndex: event.schoolIndex,
        schoolName: event.schoolName,
        schoolType: event.schoolType,
        curriculum: event.curriculum,
        establishedDate: event.establishedDate,
        grades: event.grades,
        userEmail: event.userEmail,
      );
      
      if (success) {
        final generalData = await _service.getGeneralData(event.taskUrn);
        
        if (generalData != null) {
          emit(TaskCommencementLoaded(
            generalData: generalData,
            selectedSchoolIndex: event.schoolIndex,
          ));
        } else {
          emit(TaskCommencementFailure('Failed to load updated data'));
        }
      } else {
        emit(TaskCommencementFailure('Failed to update school data'));
      }
    } catch (e) {
      log('Error updating school data: $e');
      emit(TaskCommencementFailure('Failed to update school data: $e'));
    }
  }
  
  Future<void> _onCompleteTask(
    CompleteTask event, 
    Emitter<TaskCommencementState> emit
  ) async {
    emit(TaskCommencementLoading());
    try {
      final success = await _service.completeTask(event.taskUrn, event.userEmail);
      
      if (success) {
        emit(TaskCommencementCompleted());
      } else {
        emit(TaskCommencementFailure('Failed to complete task'));
      }
    } catch (e) {
      log('Error completing task: $e');
      emit(TaskCommencementFailure('Failed to complete task: $e'));
    }
  }
  
  void _onChangeSelectedSchool(
    ChangeSelectedSchool event, 
    Emitter<TaskCommencementState> emit
  ) {
    if (state is TaskCommencementLoaded) {
      final loadedState = state as TaskCommencementLoaded;
      emit(TaskCommencementLoaded(
        generalData: loadedState.generalData,
        selectedSchoolIndex: event.schoolIndex,
      ));
    }
  }
}