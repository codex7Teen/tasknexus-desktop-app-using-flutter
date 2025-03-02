import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tasknexus/data/models/client_contact_model.dart';
import 'package:tasknexus/data/models/task_model.dart';
import 'package:tasknexus/data/services/task_service.dart';

class AddTaskService {
  final TaskService _taskService = TaskService();

  // Convert form data to TaskModel
  TaskModel createTaskFromForm({
    required String taskName,
    required String urn,
    required String description,
    required String commencementDate,
    required String dueDate,
    required String assignedTo,
    required String assignedBy,
    required String clientName,
    required List<List<TextEditingController>> clientDetailsControllers,
    required String userEmail,
  }) {
    // Create client contacts list from controllers
    final List<ClientContactModel> clientContacts = [];

    for (var row in clientDetailsControllers) {
      // Only add non-empty contacts
      if (row[0].text.isNotEmpty ||
          row[1].text.isNotEmpty ||
          row[2].text.isNotEmpty) {
        clientContacts.add(
          ClientContactModel(
            name: row[0].text,
            designation: row[1].text,
            email: row[2].text,
          ),
        );
      }
    }

    return TaskModel(
      urn: urn,
      name: taskName,
      description: description,
      commencementDate: commencementDate,
      dueDate: dueDate,
      assignedTo: assignedTo,
      assignedBy: assignedBy,
      clientName: clientName,
      userEmail: userEmail,
      clientContacts: clientContacts,
    );
  }

  // Save task to Hive
  Future<bool> saveTask({
    required String taskName,
    required String urn,
    required String description,
    required String commencementDate,
    required String dueDate,
    required String assignedTo,
    required String assignedBy,
    required String clientName,
    required List<List<TextEditingController>> clientDetailsControllers,
    required String userEmail,
  }) async {
    try {
      final task = createTaskFromForm(
        taskName: taskName,
        urn: urn,
        description: description,
        commencementDate: commencementDate,
        dueDate: dueDate,
        assignedTo: assignedTo,
        assignedBy: assignedBy,
        clientName: clientName,
        clientDetailsControllers: clientDetailsControllers,
        userEmail: userEmail,
      );

      await _taskService.saveTask(task);
      log('TASK: SAVED TO HIVE');
      return true;
    } catch (e) {
      log('Error saving task: $e');
      return false;
    }
  }

  // Update existing task
  Future<bool> updateTask({
    required String taskName,
    required String urn,
    required String description,
    required String commencementDate,
    required String dueDate,
    required String assignedTo,
    required String assignedBy,
    required String clientName,
    required List<List<TextEditingController>> clientDetailsControllers,
    required String userEmail,
    String? status,
  }) async {
    try {
      // Create task with form data
      final task = createTaskFromForm(
        taskName: taskName,
        urn: urn,
        description: description,
        commencementDate: commencementDate,
        dueDate: dueDate,
        assignedTo: assignedTo,
        assignedBy: assignedBy,
        clientName: clientName,
        clientDetailsControllers: clientDetailsControllers,
        userEmail: userEmail,
      );

      // If status is provided, set it (for editing tasks that are already started)
      final taskWithStatus =
          status != null ? task.copyWith(status: status) : task;

      await _taskService.updateTask(taskWithStatus);
      log('TASK: UPDATED IN HIVE');
      return true;
    } catch (e) {
      log('Error updating task: $e');
      return false;
    }
  }

  // Populate form controllers with existing task data
  void populateFormWithTask({
    required TaskModel task,
    required TextEditingController taskNameController,
    required TextEditingController urnController,
    required TextEditingController descriptionController,
    required TextEditingController commencementDateController,
    required TextEditingController dueDateController,
    required TextEditingController assignedToController,
    required TextEditingController assignedByController,
    required TextEditingController clientNameController,
    required List<List<TextEditingController>> clientDetailsControllers,
  }) {
    // Set basic task details
    taskNameController.text = task.name;
    urnController.text = task.urn;
    descriptionController.text = task.description;
    commencementDateController.text = task.commencementDate;
    dueDateController.text = task.dueDate;
    assignedToController.text = task.assignedTo;
    assignedByController.text = task.assignedBy;
    clientNameController.text = task.clientName;

    // Clear existing client details
    for (var row in clientDetailsControllers) {
      for (var controller in row) {
        controller.clear();
      }
    }

    // Add client contacts from task
    for (int i = 0; i < task.clientContacts.length; i++) {
      // If we need more rows, add them
      if (i >= clientDetailsControllers.length) {
        clientDetailsControllers.add([
          TextEditingController(),
          TextEditingController(),
          TextEditingController(),
        ]);
      }

      // Set the values
      clientDetailsControllers[i][0].text = task.clientContacts[i].name;
      clientDetailsControllers[i][1].text = task.clientContacts[i].designation;
      clientDetailsControllers[i][2].text = task.clientContacts[i].email;
    }
  }

  // Get a specific task by URN
  Future<TaskModel?> getTaskByURN(String urn, String userEmail) async {
    final tasks = await _taskService.getTasks(userEmail);
    try {
      return tasks.firstWhere((task) => task.urn == urn);
    } catch (e) {
      return null;
    }
  }

  // Generate new URN for task
  String generateURN() {
    return _taskService.generateURN();
  }
}
