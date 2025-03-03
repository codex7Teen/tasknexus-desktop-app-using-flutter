import 'package:hive_flutter/hive_flutter.dart';
import 'dart:math' as math;
import 'package:tasknexus/data/models/task_model.dart';

class TaskService {
  //! Open and return the tasks Hive box
  Future<Box<TaskModel>> _getTasksBox() async {
    return await Hive.openBox<TaskModel>(TaskModel.boxName);
  }

  //! Save a new task to the Hive database
  Future<void> saveTask(TaskModel task) async {
    final box = await _getTasksBox();
    await box.add(task);
  }

  //! Retrieve all tasks for a specific user
  Future<List<TaskModel>> getTasks(String userEmail) async {
    final box = await _getTasksBox();
    return box.values.where((task) => task.userEmail == userEmail).toList();
  }

  //! Retrieve tasks filtered by status for a specific user
  Future<List<TaskModel>> getTasksByStatus(
    String userEmail,
    String status,
  ) async {
    final box = await _getTasksBox();
    return box.values
        .where((task) => task.userEmail == userEmail && task.status == status)
        .toList();
  }

  //! Update an existing task by finding its index
  Future<void> updateTask(TaskModel updatedTask) async {
    final box = await _getTasksBox();

    // Find the task index by URN and user email
    final taskToUpdateIndex = box.values.toList().indexWhere(
      (task) =>
          task.urn == updatedTask.urn &&
          task.userEmail == updatedTask.userEmail,
    );

    if (taskToUpdateIndex != -1) {
      await box.putAt(taskToUpdateIndex, updatedTask);
    }
  }

  //! Update the status of a specific task
  Future<void> updateTaskStatus(
    String urn,
    String userEmail,
    String newStatus,
  ) async {
    final box = await _getTasksBox();

    // Find the task index
    final tasksList = box.values.toList();
    final taskToUpdateIndex = tasksList.indexWhere(
      (task) => task.urn == urn && task.userEmail == userEmail,
    );

    if (taskToUpdateIndex != -1) {
      final task = tasksList[taskToUpdateIndex];
      final updatedTask = task.copyWith(status: newStatus);
      await box.putAt(taskToUpdateIndex, updatedTask);
    }
  }

  //! Delete a task from the Hive database
  Future<void> deleteTask(String urn, String userEmail) async {
    final box = await _getTasksBox();

    // Find the key of the task to delete
    final taskToDeleteKey = box.keys.firstWhere((k) {
      final task = box.get(k);
      return task != null && task.urn == urn && task.userEmail == userEmail;
    }, orElse: () => null);

    if (taskToDeleteKey != null) {
      await box.delete(taskToDeleteKey);
    }
  }

  //! Generate a unique URN for each new task
  String generateURN() {
    final random = math.Random();
    final number = random.nextInt(10000).toString().padLeft(4, '0');
    final year = DateTime.now().year;
    return 'TN-$year-$number';
  }
}
