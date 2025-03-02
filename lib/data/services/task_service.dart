import 'package:hive_flutter/hive_flutter.dart';
import 'dart:math' as math;

import 'package:tasknexus/data/models/task_model.dart';

class TaskService {
  // Get the tasks box
  Future<Box<TaskModel>> _getTasksBox() async {
    return await Hive.openBox<TaskModel>(TaskModel.boxName);
  }
  
  // Save a new task
  Future<void> saveTask(TaskModel task) async {
    final box = await _getTasksBox();
    await box.add(task);
  }
  
  // Get all tasks for a specific user
  Future<List<TaskModel>> getTasks(String userEmail) async {
    final box = await _getTasksBox();
    return box.values
        .where((task) => task.userEmail == userEmail)
        .toList();
  }
  
  // Get tasks by status for a specific user
  Future<List<TaskModel>> getTasksByStatus(String userEmail, String status) async {
    final box = await _getTasksBox();
    return box.values
        .where((task) => task.userEmail == userEmail && task.status == status)
        .toList();
  }
  
  // Update an existing task
  Future<void> updateTask(TaskModel updatedTask) async {
    final box = await _getTasksBox();
    
    // Find the task index by URN
    final taskToUpdateIndex = box.values.toList().indexWhere(
          (task) => task.urn == updatedTask.urn && task.userEmail == updatedTask.userEmail
        );
    
    if (taskToUpdateIndex != -1) {
      await box.putAt(taskToUpdateIndex, updatedTask);
    }
  }
  
  // Update task status
  Future<void> updateTaskStatus(String urn, String userEmail, String newStatus) async {
    final box = await _getTasksBox();
    
    // Find the task index by URN
    final tasksList = box.values.toList();
    final taskToUpdateIndex = tasksList.indexWhere(
          (task) => task.urn == urn && task.userEmail == userEmail
        );
    
    if (taskToUpdateIndex != -1) {
      final task = tasksList[taskToUpdateIndex];
      final updatedTask = task.copyWith(status: newStatus);
      await box.putAt(taskToUpdateIndex, updatedTask);
    }
  }
  
  // Delete a task
  Future<void> deleteTask(String urn, String userEmail) async {
    final box = await _getTasksBox();
    
    // Find the key of the task to delete
    final taskToDeleteKey = box.keys.firstWhere(
      (k) {
        final task = box.get(k);
        return task != null && task.urn == urn && task.userEmail == userEmail;
      },
      orElse: () => null,
    );
    
    if (taskToDeleteKey != null) {
      await box.delete(taskToDeleteKey);
    }
  }
  
  // Generate a unique URN for a new task
  String generateURN() {
    final random = math.Random();
    final number = random.nextInt(10000).toString().padLeft(4, '0');
    final year = DateTime.now().year;
    return 'TN-$year-$number';
  }
}