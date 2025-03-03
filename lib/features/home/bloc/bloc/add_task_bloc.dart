import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasknexus/data/models/task_model.dart';
import 'package:tasknexus/data/services/add_task_service.dart';

part 'add_task_event.dart';
part 'add_task_state.dart';

class AddTaskBloc extends Bloc<AddTaskEvent, AddTaskState> {
  final AddTaskService _addTaskService = AddTaskService();

  AddTaskBloc() : super(AddTaskInitialState()) {
    on<AddTaskInitial>(_onAddTaskInitial);
    on<AddTaskSave>(_onAddTaskSave);
    on<AddTaskUpdate>(_onAddTaskUpdate);
    on<AddTaskLoadExisting>(_onAddTaskLoadExisting);
  }

  //! INITIALIZE TASK (CHECK IF EDIT MODE OR NEW TASK)
  Future<void> _onAddTaskInitial(
    AddTaskInitial event,
    Emitter<AddTaskState> emit,
  ) async {
    emit(AddTaskLoading());
    try {
      // If this is an edit mode (has URN), load the task
      if (event.urn != null) {
        final task = await _addTaskService.getTaskByURN(
          event.urn!,
          event.currentUserName!,
        );
        if (task != null) {
          emit(AddTaskLoaded(task)); // Emit loaded state with task data
        } else {
          emit(const AddTaskFailure('Task not found'));
        }
      } else {
        // This is a new task, just return to initial state
        emit(AddTaskInitialState());
      }
    } catch (e) {
      log('Error initializing add task: $e');
      emit(AddTaskFailure('Failed to initialize: $e'));
    }
  }

  //! SAVE TASK BLOC
  Future<void> _onAddTaskSave(
    AddTaskSave event,
    Emitter<AddTaskState> emit,
  ) async {
    emit(AddTaskLoading());
    try {
      // Save task details using the service
      final success = await _addTaskService.saveTask(
        taskName: event.taskName,
        urn: event.urn,
        description: event.description,
        commencementDate: event.commencementDate,
        dueDate: event.dueDate,
        assignedTo: event.assignedTo,
        assignedBy: event.assignedBy,
        clientName: event.clientName,
        clientDetailsControllers: event.clientDetailsControllers,
        userEmail: event.userEmail,
      );

      if (success) {
        emit(const AddTaskSuccess('Task saved successfully'));
      } else {
        emit(const AddTaskFailure('Failed to save task'));
      }
    } catch (e) {
      log('Error saving task: $e');
      emit(AddTaskFailure('Failed to save task: $e'));
    }
  }

  //! UPDATE TASK BLOC
  Future<void> _onAddTaskUpdate(
    AddTaskUpdate event,
    Emitter<AddTaskState> emit,
  ) async {
    emit(AddTaskLoading());
    try {
      // Update task details using the service
      final success = await _addTaskService.updateTask(
        taskName: event.taskName,
        urn: event.urn,
        description: event.description,
        commencementDate: event.commencementDate,
        dueDate: event.dueDate,
        assignedTo: event.assignedTo,
        assignedBy: event.assignedBy,
        clientName: event.clientName,
        clientDetailsControllers: event.clientDetailsControllers,
        userEmail: event.userEmail,
        status: event.status,
      );

      if (success) {
        emit(const AddTaskSuccess('Task updated successfully'));
      } else {
        emit(const AddTaskFailure('Failed to update task'));
      }
    } catch (e) {
      log('Error updating task: $e');
      emit(AddTaskFailure('Failed to update task: $e'));
    }
  }

  //! LOAD EXISTING TASK BLOC
  Future<void> _onAddTaskLoadExisting(
    AddTaskLoadExisting event,
    Emitter<AddTaskState> emit,
  ) async {
    emit(AddTaskLoading());
    try {
      // Load task details using the provided URN
      final task = await _addTaskService.getTaskByURN(
        event.urn,
        event.userEmail,
      );
      if (task != null) {
        emit(AddTaskLoaded(task));
      } else {
        emit(const AddTaskFailure('Task not found'));
      }
    } catch (e) {
      log('Error loading task: $e');
      emit(AddTaskFailure('Failed to load task: $e'));
    }
  }
}
